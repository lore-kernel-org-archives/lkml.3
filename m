Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaIEJqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:46:11 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60295 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbaIEJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:46:00 -0400
Date: Fri, 5 Sep 2014 11:45:56 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 2/2] freezer: remove obsolete comments in __thaw_task()
Message-ID: <20140905094556.GE26243@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <1409869842-10807-2-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409869842-10807-2-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-09-14 15:30:42, Cong Wang wrote:
> __thaw_task() no longer clears frozen flag since commit a3201227f803
> (freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE).
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks for extending the description.
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  kernel/freezer.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index dbcb87c..438ecca 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -161,12 +161,6 @@ void __thaw_task(struct task_struct *p)
>  {
>  	unsigned long flags;
>  
> -	/*
> -	 * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
> -	 * be visible to @p as waking up implies wmb.  Waking up inside
> -	 * freezer_lock also prevents wakeups from leaking outside
> -	 * refrigerator.
> -	 */
>  	spin_lock_irqsave(&freezer_lock, flags);
>  	if (frozen(p))
>  		wake_up_process(p);
> -- 
> 1.8.3.1
> 

-- 
Michal Hocko
SUSE Labs
