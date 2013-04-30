Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3D3Ac4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:32:56 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:52431 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab3D3Acw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:32:52 -0400
Message-ID: <517F1131.4080109@linaro.org>
Date: Mon, 29 Apr 2013 17:32:49 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>, Jamie Iles <jamie@jamieiles.com>
Subject: Re: [patch 01/15] clocksource: apb_timer: Remove unsused function
References: <20130425142452.908423538@linutronix.de> <20130425143435.558006195@linutronix.de>
In-Reply-To: <20130425143435.558006195@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> Cc: Jamie Iles<jamie@jamieiles.com>

Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john


> ---
>   drivers/clocksource/dw_apb_timer.c |   12 ------------
>   include/linux/dw_apb_timer.h       |    1 -
>   2 files changed, 13 deletions(-)
>
> Index: tip/drivers/clocksource/dw_apb_timer.c
> ===================================================================
> --- tip.orig/drivers/clocksource/dw_apb_timer.c
> +++ tip/drivers/clocksource/dw_apb_timer.c
> @@ -387,15 +387,3 @@ cycle_t dw_apb_clocksource_read(struct d
>   {
>   	return (cycle_t)~apbt_readl(&dw_cs->timer, APBTMR_N_CURRENT_VALUE);
>   }
> -
> -/**
> - * dw_apb_clocksource_unregister() - unregister and free a clocksource.
> - *
> - * @dw_cs:	The clocksource to unregister/free.
> - */
> -void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs)
> -{
> -	clocksource_unregister(&dw_cs->cs);
> -
> -	kfree(dw_cs);
> -}
> Index: tip/include/linux/dw_apb_timer.h
> ===================================================================
> --- tip.orig/include/linux/dw_apb_timer.h
> +++ tip/include/linux/dw_apb_timer.h
> @@ -51,7 +51,6 @@ dw_apb_clocksource_init(unsigned rating,
>   void dw_apb_clocksource_register(struct dw_apb_clocksource *dw_cs);
>   void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
>   cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
> -void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs);
>   
>   extern void dw_apb_timer_init(void);
>   #endif /* __DW_APB_TIMER_H__ */
>
>

