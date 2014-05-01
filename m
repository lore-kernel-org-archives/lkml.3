Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaEATR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:17:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaEATR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:17:26 -0400
Date: Thu, 1 May 2014 15:17:20 -0400
From: Don Zickus <dzickus@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Ben Zhang <benzh@chromium.org>
Subject: Re: [PATCH] watchdog: print all locks on a softlock
Message-ID: <20140501191720.GA198341@redhat.com>
References: <1398970535-6880-1-git-send-email-eparis@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398970535-6880-1-git-send-email-eparis@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 02:55:35PM -0400, Eric Paris wrote:
> If the CPU hits a softlockup this patch will also have it print the
> information about all locks being held on the system.  This might help
> determine if a lock is being held too long leading to this problem.

I am not sure this helps you.  A softlockup is the result of pre-emption
disabled, ie the scheduler not being called after 60 seconds.  Holding a
lock does not disable pre-emption usually.  So I don't think this is going
to add anything.

Are you trying to debug a hung task?  The the hung_task thread checks to
see if a task hasn't scheduled in 2 minutes or so.  That could be the
result of long lock (but that output already dumps the lockdep stuff).

Cheers,
Don

> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Ben Zhang <benzh@chromium.org>
> ---
>  kernel/watchdog.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 516203e..a027240 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -322,6 +322,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  			current->comm, task_pid_nr(current));
>  		print_modules();
>  		print_irqtrace_events(current);
> +		debug_show_all_locks();
>  		if (regs)
>  			show_regs(regs);
>  		else
> -- 
> 1.9.0
> 
