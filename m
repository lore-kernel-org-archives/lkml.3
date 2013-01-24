Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3AXRAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:00:03 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57871 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3AXRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:00:00 -0500
Date: Thu, 24 Jan 2013 17:59:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched: add a tuning knob to allow changing RR tmeslice
Message-ID: <20130124165955.GA9324@gmail.com>
References: <20121108195113.2dd51d43@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108195113.2dd51d43@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> This version stores the user-input value in a separate 
> location from the jiffies values used by the scheduler, to 
> prevent a race condition.
> 
> Subject: [PATCH v2] sched: add a tuning knob to allow changing 
> RR timeslice

looks useful.

> @@ -2010,7 +2010,7 @@ static void task_tick_rt(struct rq *rq, struct
> task_struct *p, int queued) if (--p->rt.time_slice)
>  		return;
>  
> -	p->rt.time_slice = RR_TIMESLICE;
> +	p->rt.time_slice = sched_rr_timeslice;
>  
>  	/*
>  	 * Requeue to the end of queue if we (and all of our
> ancestors) are the @@ -2041,7 +2041,7 @@ static unsigned int
> get_rr_interval_rt(struct rq *rq, struct task_struct *task)
>  	 * Time slice is 0 for SCHED_FIFO tasks

Patch wont apply due to patch corruption, alas.

Thanks,

	Ingo
