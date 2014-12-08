Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaLHWht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:37:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54132 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaLHWhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:37:48 -0500
Message-ID: <5486282F.3040909@gmail.com>
Date: Mon, 08 Dec 2014 14:37:35 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, daniel.lezcano@linaro.org,
        tglx@linutronix.de
CC: bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: kona: fix __iomem annotation
References: <1418074922-671-1-git-send-email-olof@lixom.net>
In-Reply-To: <1418074922-671-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 13:42, Olof Johansson wrote:
> It makes no sense to hide the __iomem annotation from the function
> that uses it, especially since it causes a sparse warning:
> 
> drivers/clocksource/bcm_kona_timer.c:118:38: warning: incorrect type in argument 1 (different address spaces)
> drivers/clocksource/bcm_kona_timer.c:118:38:    expected void *timer_base
> drivers/clocksource/bcm_kona_timer.c:118:38:    got void [noderef] <asn:2>*static [toplevel] tmr_regs
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  drivers/clocksource/bcm_kona_timer.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
> index 0595dc6..f1e33d0 100644
> --- a/drivers/clocksource/bcm_kona_timer.c
> +++ b/drivers/clocksource/bcm_kona_timer.c
> @@ -68,9 +68,8 @@ static void kona_timer_disable_and_clear(void __iomem *base)
>  }
>  
>  static void
> -kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
> +kona_timer_get_counter(void __iomem *timer_base, uint32_t *msw, uint32_t *lsw)
>  {
> -	void __iomem *base = IOMEM(timer_base);
>  	int loop_limit = 4;
>  
>  	/*
> @@ -86,9 +85,9 @@ kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
>  	 */
>  
>  	while (--loop_limit) {
> -		*msw = readl(base + KONA_GPTIMER_STCHI_OFFSET);
> -		*lsw = readl(base + KONA_GPTIMER_STCLO_OFFSET);
> -		if (*msw == readl(base + KONA_GPTIMER_STCHI_OFFSET))
> +		*msw = readl(timer_base + KONA_GPTIMER_STCHI_OFFSET);
> +		*lsw = readl(timer_base + KONA_GPTIMER_STCLO_OFFSET);
> +		if (*msw == readl(timer_base + KONA_GPTIMER_STCHI_OFFSET))
>  			break;
>  	}
>  	if (!loop_limit) {
> 

