Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbbA0Its (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:49:48 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50556 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648AbbA0Itp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:49:45 -0500
Message-ID: <54C75126.5070905@linaro.org>
Date: Tue, 27 Jan 2015 09:49:42 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH] ARM: clocksource: fix compile of asm9260_timer driver
 on ARCH=parisc
References: <54BE5E9A.8070502@linaro.org> <1422343624-9764-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1422343624-9764-1-git-send-email-linux@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 08:27 AM, Oleksij Rempel wrote:
> make sure this driver depends on GENERIC_CLOCKEVENTS
>
> compiler error was found by kbuild test robot:
>
>>> drivers/clocksource/asm9260_timer.c:114:14: warning: its scope is only this definition or declaration, which is probably not what you want
>>> drivers/clocksource/asm9260_timer.c:124:16: warning: 'struct clock_event_device' declared inside parameter list
>              struct clock_event_device *evt)
>
>>> drivers/clocksource/asm9260_timer.c:124:16: warning: 'enum clock_event_mode' declared inside parameter list
>>> drivers/clocksource/asm9260_timer.c:123:58: error: parameter 1 ('mode') has incomplete type
>      static void asm9260_timer_set_mode(enum clock_event_mode mode,
>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

I would like to fold this patch with the asm9260 timer patch in order to 
prevent git bisecting breakage. Ok for you ?

> ---
>   drivers/clocksource/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 13b8152..bfaaae4 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -231,6 +231,7 @@ config CLKSRC_MIPS_GIC
>
>   config ASM9260_TIMER
>   	bool "Alphascale ASM9260 timer driver"
> +	depends on GENERIC_CLOCKEVENTS
>   	select CLKSRC_MMIO
>   	select CLKSRC_OF
>   	default y if MACH_ASM9260
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

