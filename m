Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaFLMh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:37:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60539 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaFLMh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:37:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 12 Jun 2014 14:35:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch 08/13] firewire: Use ktime_get_ts()
Message-ID: <20140612143549.4c00c1ed@kant>
In-Reply-To: <20140611234607.351283464@linutronix.de>
References: <20140611234024.103571777@linutronix.de>
	<20140611234607.351283464@linutronix.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 11 Thomas Gleixner wrote:
> do_posix_clock_monotonic_gettime() is a leftover from the initial
> posix timer implementation which maps to ktime_get_ts()
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

(Though I am noticing increasing entropy WRT whitespace.)

> ---
>  drivers/firewire/core-cdev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/firewire/core-cdev.c
> ===================================================================
> --- linux.orig/drivers/firewire/core-cdev.c
> +++ linux/drivers/firewire/core-cdev.c
> @@ -1215,7 +1215,7 @@ static int ioctl_get_cycle_timer2(struct
>  
>  	switch (a->clk_id) {
>  	case CLOCK_REALTIME:      getnstimeofday(&ts);                   break;
> -	case CLOCK_MONOTONIC:     do_posix_clock_monotonic_gettime(&ts); break;
> +	case CLOCK_MONOTONIC:     ktime_get_ts(&ts); break;
>  	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);                  break;
>  	default:
>  		ret = -EINVAL;
> 
> 

-- 
Stefan Richter
-=====-====- -==- -==--
http://arcgraph.de/sr/
