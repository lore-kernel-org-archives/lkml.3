Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaBTUtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:49:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:34468 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaBTUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:49:09 -0500
Date: Thu, 20 Feb 2014 21:49:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, anton@enomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v4 1/6] Replace ternary operator to macro
In-Reply-To: <1392913425-29369-2-git-send-email-a.perevalov@samsung.com>
Message-ID: <alpine.DEB.2.02.1402202148180.4468@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com> <1392913425-29369-2-git-send-email-a.perevalov@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Alexey Perevalov wrote:

The subject line lacks any information in which part of the kernel you
are doing this.

> For extensibility purpose it's better to have _switch_ type mechanism
> for representing human readable CLOCKID* and HRMODE.
> 
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  include/trace/events/timer.h |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
> index 68c2c20..185b2c6 100644
> --- a/include/trace/events/timer.h
> +++ b/include/trace/events/timer.h
> @@ -8,6 +8,16 @@
>  #include <linux/hrtimer.h>
>  #include <linux/timer.h>
>  
> +#define clockid_to_string(clockid)						\
> +	__print_symbolic(clockid,						\
> +			 { CLOCK_MONOTONIC,		"CLOCK_MONOTONIC" },	\
> +			 { CLOCK_REALTIME,		"CLOCK_REALTIME" })
> +
> +#define hrmode_to_string(hrmode)						\
> +	__print_symbolic(hrmode,						\
> +			 { HRTIMER_MODE_ABS,		"HRTIMER_MODE_ABS" },	\
> +			 { HRTIMER_MODE_REL,		"HRTIMER_MODE_REL" })
> +
>  DECLARE_EVENT_CLASS(timer_class,
>  
>  	TP_PROTO(struct timer_list *timer),
> @@ -147,10 +157,8 @@ TRACE_EVENT(hrtimer_init,
>  	),
>  
>  	TP_printk("hrtimer=%p clockid=%s mode=%s", __entry->hrtimer,
> -		  __entry->clockid == CLOCK_REALTIME ?
> -			"CLOCK_REALTIME" : "CLOCK_MONOTONIC",
> -		  __entry->mode == HRTIMER_MODE_ABS ?
> -			"HRTIMER_MODE_ABS" : "HRTIMER_MODE_REL")
> +		  clockid_to_string(__entry->clockid),
> +		  hrmode_to_string(__entry->mode))
>  );
>  
>  /**
> -- 
> 1.7.9.5
> 
> 
