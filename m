Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaFMRKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:10:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17268 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753559AbaFMRKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:10:49 -0400
Date: Fri, 13 Jun 2014 13:10:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch V4 08/10] rtmutex: Confine deadlock logic to futex
Message-ID: <20140613131047.6578fdf7@gandalf.local.home>
In-Reply-To: <20140611183853.553977348@linutronix.de>
References: <20140611182944.108526809@linutronix.de>
	<20140611183853.553977348@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 18:44:08 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:
  
> +/*
> + * Futex variant with full deadlock detection.
> + */
> +int __rt_mutex_timed_lock(struct rt_mutex *lock,
> +			  struct hrtimer_sleeper *timeout)

I hate underscores. Although it's commented, it's still rather awkward.

What about calling it rt_mutex_timed_futex_lock() or something else
with futex in its name?

Rest looks good.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> +{
> +	might_sleep();
> +
> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 1,
> +				       rt_mutex_slowlock);
> +}
> +

