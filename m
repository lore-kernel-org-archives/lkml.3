Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbbAZVYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:24:03 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:49825 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:23:59 -0500
Message-ID: <54C6B06C.20907@linaro.org>
Date: Mon, 26 Jan 2015 22:23:56 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/2] clocksource: Conexant CX92755 timers support
References: <cover.1422296650.git.baruch@tkos.co.il>
In-Reply-To: <cover.1422296650.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Baruch,

applied the series for 3.20.

Thanks !
   -- Daniel


On 01/26/2015 07:35 PM, Baruch Siach wrote:
> This short series adds support for the Conexant CX92755 SoC timers. This SoC is
> part of the Conexant Digicolor series of SoCs.
>
> v6:
>     * Use a dedicated config symbol, CONFIG_DIGICOLOR_TIMER, to enable the
> 	 driver (Daniel Lezcano)
>
> v5:
>     http://thread.gmane.org/gmane.linux.kernel/1874237
>
>     * Switch back to use of_iomap (not of_io_request_and_map), as the watchdog
> 	 driver also needs access to the same registers; add a comment clarifying
> 	 this
>
>     Address more review comments by Daniel Lezcano:
>
>     * Properly encapsulate the static objects for the clock_event code
>
>     * Use dc_timer_{disable,enable,set_count} accessors to make the code clearer
>
> v4:
>     http://thread.gmane.org/gmane.linux.kernel/1874017
>
>     Address review comments by Daniel Lezcano:
>
>     * Use macros for register configuration values
>
>     * Encapsulate static objects in a struct
>
>     * Use of_io_request_and_map to exclusively map registers
>
>     * Use UINT_MAX instead of ~0
>
>     * Use request_irq instead of setup_irq, obviating the need for a separate
>       irqaction struct
>
> v3:
>     http://article.gmane.org/gmane.linux.kernel/1870628
>     http://article.gmane.org/gmane.linux.kernel/1870627
>
>     * Split into a separate clocksource series
>
> v2:
>     http://article.gmane.org/gmane.linux.kernel/1861850
>     http://article.gmane.org/gmane.linux.kernel/1861853
>
>     * Change the timer dt binding, so that the 'reg' property points to the
>       first "Agent Communication" register. This should improve the chance of
>       reusing this binding for other SoCs in this series.
>
>     * Add the CONTROL() and COUNT() macros to the timer driver to make the code
>       clearer.
>
>     * Move arch/arm Kconfig changes from the clocksource driver patch to the
>       base arch support patch to reduce dependency between them
>
> v1:
>     http://article.gmane.org/gmane.linux.kernel/1855028
>     http://article.gmane.org/gmane.linux.kernel/1855025
>
> Baruch Siach (2):
>    clocksource: devicetree: document Conexant Digicolor timer binding
>    clocksource: driver for Conexant Digicolor SoC timer
>
>   .../devicetree/bindings/timer/digicolor-timer.txt  |  18 ++
>   drivers/clocksource/Kconfig                        |   3 +
>   drivers/clocksource/Makefile                       |   1 +
>   drivers/clocksource/timer-digicolor.c              | 199 +++++++++++++++++++++
>   4 files changed, 221 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/timer/digicolor-timer.txt
>   create mode 100644 drivers/clocksource/timer-digicolor.c
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

