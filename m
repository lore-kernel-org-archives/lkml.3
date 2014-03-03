Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaCCWpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:45:14 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:33794 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaCCWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:45:09 -0500
Date: Mon, 3 Mar 2014 17:45:05 -0500
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
Message-ID: <20140303224505.GE26523@mtj.dyndns.org>
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com>
 <20140303223327.GB26523@mtj.dyndns.org>
 <5315057F.3030602@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5315057F.3030602@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 05:43:11PM -0500, Sasha Levin wrote:
> On 03/03/2014 05:33 PM, Tejun Heo wrote:
> >On Sat, Mar 01, 2014 at 10:00:11PM -0500, Sasha Levin wrote:
> >>rcu read lock should be held when calling and working with task_css_set.
> >>
> >>This patch also fixes a related lockdep warning.
> >
> >Hmmm... PF_EXITING should be visible at that point and cset can't
> >change anymore.  We prolly need to update lockdep annotation rather
> >than adding spurious rcu locking around it.  Against which branch is
> >it?  Can you please post the lockdep warning?
> 
> I see it on -next.

I think the right thing to do is using task_css_set_check() with
PF_EXITING check and add comment explaining that cset can no longer
change.  Can you please write up a patch?

Thanks.

-- 
tejun
