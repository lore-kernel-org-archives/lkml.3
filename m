Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaA2Paz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:30:55 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34466 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaA2Pax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:30:53 -0500
Date: Wed, 29 Jan 2014 10:30:49 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] cgroup: drop module support
Message-ID: <20140129153049.GC30842@htj.dyndns.org>
References: <1390952641-15950-1-git-send-email-tj@kernel.org>
 <1390952641-15950-3-git-send-email-tj@kernel.org>
 <52E880A6.4040902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E880A6.4040902@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Jan 29, 2014 at 12:16:38PM +0800, Li Zefan wrote:
> > -#define for_each_builtin_subsys(ss, i)					\
> > -	for ((i) = 0; (i) < CGROUP_BUILTIN_SUBSYS_COUNT &&		\
> > -	     (((ss) = cgroup_subsys[i]) || true); (i)++)
> > +	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
> > +	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
> 
> Now cgroup_subsys[i] won't be NULL, so we can drop "|| true".

Hmmm... because the macro is kinda complex, I'd like to avoid changing
its implementation in this patch.  Also, the "|| true" tells the
compiler that it doesn't have to generate conditional branch on the
preceding condition.

Now that the array is always consecutive, I'm planning to further
simplify the iterators to not require ssid, so that it just becomes
for_each_subsys(ss).  Let's leave it alone for now.

> > +	if (need_forkexit_callback)
> > +		for_each_subsys(ss, i)
> >  			if (ss->fork)
> >  				ss->fork(child);
> > -	}
> 
> This looks a bit ugly. How about leaving the parentheses for the
> outmost if statement?
> 
> if (need_forkexit_callback) {
> 	for_each_subsys(ss, i)
> 		if (ss->fork)
> 			ss->fork(child);
> }

Maybe, I don't know.  I tend to aim for the minimum necessary as that
usually is the easiest way to achieve consistency.  That said certain
things are a lot easier on the eye with a bit of extra notations -
e.g. "(a & b) && c".  Alright, will add the parentheses.

Thanks!

-- 
tejun
