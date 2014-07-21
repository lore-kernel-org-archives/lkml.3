Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaGUOpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:45:40 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44642 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaGUOpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:45:38 -0400
Message-ID: <53CD278E.3080300@linaro.org>
Date: Mon, 21 Jul 2014 16:45:34 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, tglx@linutronix.de
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] drivers: clocksource: Kconfig: Let EM_TIMER_STI depend
 on HAS_IOMEM
References: <53BBE68C.3010000@gmail.com>
In-Reply-To: <53BBE68C.3010000@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 02:39 PM, Chen Gang wrote:
> In 'em_sti.c', it will call devm_ioremap_resource() which need
> HAS_IOMEM. So need let EM_TIMER_STI depend on HAS_IOMEM, too.
>
> The related error (with allmodconfig under score):
>
>    LD      init/built-in.o
> em_sti.c:(.text.em_sti_probe+0x84): undefined reference to `devm_ioremap_resource'
> make: *** [vmlinux] Error 1
>
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>   drivers/clocksource/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 8ad1eac..ce372d6 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -190,7 +190,7 @@ config SH_TIMER_TMU
>
>   config EM_TIMER_STI
>   	bool "Renesas STI timer driver" if COMPILE_TEST
> -	depends on GENERIC_CLOCKEVENTS
> +	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
>   	default SYS_SUPPORTS_EM_STI
>   	help
>   	  This enables build of a clocksource and clockevent driver for


Applied to my tree for 3.17

Thanks

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

