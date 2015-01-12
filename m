Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbbALOEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:04:04 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:22412 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbbALOEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:04:01 -0500
Message-ID: <54B3D450.7050405@atmel.com>
Date: Mon, 12 Jan 2015 15:04:00 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <daniel.lezcano@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        <sylvain.rochet@finsecur.com>
Subject: Re: [PATCH] clocksource: timer-atmel-pit: don't suspend/resume if
 unused
References: <1418911523-28492-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1418911523-28492-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/12/2014 15:05, Nicolas Ferre a écrit :
> From: Sylvain Rochet <sylvain.rochet@finsecur.com>
> 
> Waiting for PIT to stop counting takes a long time:
>   1/(Master clock/prescaler/PIVR)
> = 1/(133 MHz     /16       /2^20)
> = 126 ms
> 
> Up to 126 ms if master clock is set to 133 MHz, skipping suspend/resume
> of the unused PIT device reduce (suspend time + resume time) from ~140 ms
> to ~17 ms.
> 
> Signed-off-by: Sylvain Rochet <sylvain.rochet@finsecur.com>
> [nicolas.ferre@atmel.com: move to newer clocksource driver]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
> Hi Sylvain,
> 
> I re-worked (and "Acked") your patch so it can be applied on the newer Mainline
> kernels. Beware, I changed the "subject line" as well. The PIT driver moved
> recently (3.18).
> 
> Daniel,
> Can you take this patch in your tree?

Hi Daniel,

Anything prevents this patch from being merged (aka ping ;-))?

Bye,


> Thanks, bye.
>   Nicolas.
> 
>  drivers/clocksource/timer-atmel-pit.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/clocksource/timer-atmel-pit.c b/drivers/clocksource/timer-atmel-pit.c
> index b5b4d4585c9a..5408bc7c68d8 100644
> --- a/drivers/clocksource/timer-atmel-pit.c
> +++ b/drivers/clocksource/timer-atmel-pit.c
> @@ -123,6 +123,10 @@ static void at91sam926x_pit_suspend(struct clock_event_device *cedev)
>  {
>  	struct pit_data *data = clkevt_to_pit_data(cedev);
>  
> +	/* Don't suspend PIT if unused */
> +	if (cedev->mode == CLOCK_EVT_MODE_UNUSED)
> +		return;
> +
>  	/* Disable timer */
>  	pit_write(data->base, AT91_PIT_MR, 0);
>  }
> @@ -145,6 +149,10 @@ static void at91sam926x_pit_resume(struct clock_event_device *cedev)
>  {
>  	struct pit_data *data = clkevt_to_pit_data(cedev);
>  
> +	/* Don't resume PIT if unused */
> +	if (cedev->mode == CLOCK_EVT_MODE_UNUSED)
> +		return;
> +
>  	at91sam926x_pit_reset(data);
>  }
>  
> 


-- 
Nicolas Ferre
