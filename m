Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3KGL1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:27:14 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52999 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3KGL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:27:10 -0500
Message-ID: <527B790B.4040200@linaro.org>
Date: Thu, 07 Nov 2013 12:27:07 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
CC: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        horms@verge.net.au, olof@lixom.net, tglx@linutronix.de,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
References: <20131106110508.6806.48070.sendpatchset@w520> <20131106110518.6806.79333.sendpatchset@w520>
In-Reply-To: <20131106110518.6806.79333.sendpatchset@w520>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 12:05 PM, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
>
> Add Kconfig entries for CMT, MTU2, TMU and STI to
> drivers/clocksource/Kconfig. This will allow us to
> get rid of duplicated entires in architecture code
> such as arch/sh and arch/arm/mach-shmobile.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

Hi Magnus,

we are preventing to have selectable timer from this Kconfig.

You should select the timers from the arch Kconfig option.

Regards
   -- Daniel

> ---
>
>   drivers/clocksource/Kconfig |   30 ++++++++++++++++++++++++++++++
>   1 file changed, 30 insertions(+)
>
> --- 0001/drivers/clocksource/Kconfig
> +++ work/drivers/clocksource/Kconfig	2013-11-05 19:49:47.000000000 +0900
> @@ -110,3 +110,33 @@ config VF_PIT_TIMER
>   	bool
>   	help
>   	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> +
> +if COMPILE_TEST || ARM || SUPERH
> +menu "Timer drivers"
> +
> +config SH_TIMER_CMT
> +	bool "CMT timer driver"
> +	default y if ARM || (SUPERH && SYS_SUPPORTS_CMT)
> +	help
> +	  This enables build of the CMT timer driver.
> +
> +config SH_TIMER_MTU2
> +	bool "MTU2 timer driver"
> +	default y if ARM || (SUPERH && SYS_SUPPORTS_MTU2)
> +	help
> +	  This enables build of the MTU2 timer driver.
> +
> +config SH_TIMER_TMU
> +	bool "TMU timer driver"
> +	default y if ARM || (SUPERH && SYS_SUPPORTS_TMU)
> +	help
> +	  This enables build of the TMU timer driver.
> +
> +config EM_TIMER_STI
> +	bool "STI timer driver"
> +	default y if ARM
> +	help
> +	  This enables build of the STI timer driver.
> +
> +endmenu
> +endif
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

