Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbbAGSsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:48:52 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46665 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbbAGSsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:48:50 -0500
Date: Wed, 7 Jan 2015 19:48:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v2 5/5] OOM, PM: make OOM detection in the freezer path
 raceless
Message-ID: <20150107184847.GH16553@dhcp22.suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
 <1417797707-31699-6-git-send-email-mhocko@suse.cz>
 <20150107184124.GI4395@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107184124.GI4395@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-01-15 13:41:24, Tejun Heo wrote:
> Hello, Michal.  Sorry about the long delay.
> 
> On Fri, Dec 05, 2014 at 05:41:47PM +0100, Michal Hocko wrote:
> ...
> > @@ -252,6 +220,8 @@ void thaw_kernel_threads(void)
> >  {
> >  	struct task_struct *g, *p;
> >  
> > +	oom_killer_enable();
> > +
> 
> Wouldn't it be more symmetrical and make more sense to enable oom
> killer after kernel threads are thawed?  Until kernel threads are
> thawed, it isn't guaranteed that oom killer would be able to make
> forward progress, right?

Makes sense, fixed.

> Other than that, looks good to me.

Thanks! Btw. I plan to repost after Andrew releases new mmotm as there
are some dependencies in oom area.
-- 
Michal Hocko
SUSE Labs
