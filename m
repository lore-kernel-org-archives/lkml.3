Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaG1Fj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:39:57 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60308 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaG1Fjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:39:53 -0400
Message-ID: <53D5E227.6090900@linaro.org>
Date: Mon, 28 Jul 2014 07:39:51 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Robert Jarzmik <robert.jarzmik@free.fr>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH ] ARM: pxa: fix section mismatch warning for pxa_timer_nodt_init
References: <1405356724-32207-1-git-send-email-robert.jarzmik@free.fr> <53CD25A4.7030606@linaro.org> <87oawivarv.fsf@free.fr> <12220413.BdRleC0Xf5@wuerfel>
In-Reply-To: <12220413.BdRleC0Xf5@wuerfel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2014 08:50 PM, Arnd Bergmann wrote:
> commit a38b1f60b5245a3 ("ARM: pxa: Add non device-tree timer link to
> clocksource") introduced a harmless section mismatch warning for
> all pxa platforms, by introducing a new pxa_timer_init() function
> that is not marked __init but that calls pxa_timer_nodt_init(),
> which is. The function is only called at init time, so it is safe
> to also annotate it this way.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Daniel, please apply on top of Robert's patch series.

Applied thanks!

   -- Daniel

>
> diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
> index 630fa916bbc6..04b013fbc98f 100644
> --- a/arch/arm/mach-pxa/generic.c
> +++ b/arch/arm/mach-pxa/generic.c
> @@ -61,7 +61,7 @@ EXPORT_SYMBOL(get_clock_tick_rate);
>   /*
>    * For non device-tree builds, keep legacy timer init
>    */
> -void pxa_timer_init(void)
> +void __init pxa_timer_init(void)
>   {
>   	pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x40a00000),
>   			    get_clock_tick_rate());
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

