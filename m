Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab3KWGdw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 01:33:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:33109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3KWGdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 01:33:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,757,1378882800"; 
   d="scan'208";a="413442630"
Message-ID: <1385188428.29354.191.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH 2/5] futex: Check for pi futex_q only once
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Fri, 22 Nov 2013 22:33:48 -0800
In-Reply-To: <1385168197-8612-3-git-send-email-davidlohr@hp.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-3-git-send-email-davidlohr@hp.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 16:56 -0800, Davidlohr Bueso wrote:
> All wake_futex() callers already verify that the we are not dealing with
> a pi futex_q, so we can remove the redundant WARN() check, as this is never
> triggered anyway.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Scott Norton <scott.norton@hp.com>
> Cc: Tom Vaden <tom.vaden@hp.com>
> Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> Cc: Waiman Long <Waiman.Long@hp.com>
> Cc: Jason Low <jason.low2@hp.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  kernel/futex.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index e6ffe73..0768c68 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -844,9 +844,6 @@ static void wake_futex(struct futex_q *q)
>  {
>  	struct task_struct *p = q->task;
>  
> -	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
> -		return;
> -

This was added deliberately after adding said checks to the callers...
admittedly after a very long debug session I didn't ever want to repeat.
Sometimes warnings are added to make sure we caught everything and later
removed.... sometimes they are added to make sure nothing new ever
breaks this again. Since the failure scenario is non-obvious, unless
this is causing some significant performance issues for you, I'd prefer
this stays.

See commit aa10990e028cac3d5e255711fb9fb47e00700e35 for details.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


