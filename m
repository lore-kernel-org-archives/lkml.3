Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaFCMsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:48:21 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:40490 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaFCMsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:48:19 -0400
Message-ID: <538DC422.2010702@linaro.org>
Date: Tue, 03 Jun 2014 14:48:34 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        arnd@arndb.de, robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/6] arm: Add basic support for Mediatek Cortex-A7
 SoCs
References: <1401468964-5307-1-git-send-email-matthias.bgg@gmail.com>
In-Reply-To: <1401468964-5307-1-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 06:55 PM, Matthias Brugger wrote:
> Sixth round for the Mediatek basic support patches.
>
> I encapsulated the setup of the timer and the interrupt in seperate
> functions.
> Apart I fixed the compatibily string to be consisten throughout the
> whole system (from mediatek,mtk6577 to mediatek,mt6577) and added
> the address to the bindings documentation.


Hi,

through which tree should this patchset to be merged ?

Thanks

   -- Daniel

> ---
> This patch set adds basic support for the Mediatek Cortex-A7 SoCs.
> Support is quite basic, as the only component working up to now are the
> timers.
>
> The patch series is build against torvalds/master tree.
>
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>
> Changes for v6:
> - fix compatible string of the timer
> - encapsulate timer setup in function
> - add more information to the timer commit message
> - add address in timer DTS bindings documentation
>
>
> Changes for v5:
> 1. Clocksource timer
> - Change the compatible string to mt6577
>
> 2. Timer DT bindings
> - Change compatible string to mt6577
>
>
> Changes for v4:
> 1. Clocksource timer
> - use cpu_possible_mask
>
> 2. Timer DT bindings
> - Delete comments about the frequency of the clocks
> - Add clock-names for the input clocks
>
> 3. Basic SoC support
> - add clock-names for the timer
> - rename the label of the clocks nodes
>
>
> Changes for v3:
> 1. Clocksource timer
> - Set cpu_mask_all and irq in clock_event_device
> - Use device private structure for driver specific values
>
> 2. Timer DT bindings
> - Define order of the clock phandles
> - Fix typos
>
> 3. Basic SoC support
> - DTS: set gic to a15-gic
> - DTS: order by physical address
> - Remove call to dt_init function
>
>
> Changes for v2:
> 1. Clocksource timer
> - Delete unused parts for sched_clock_source
> - Use irq_request instead of setup_irq
> - Remove unused SMP parts
> - Fix some style issues
> - use of_address_to resource and request_mem_region
> - delete use of named clock
> - select CLKSRC_MMIO in driver Kconfig
>
> 2. DT bindings
> - delete named clock bindings
>
> 3. Basic SoC support
> - Clean-up Kconfig
> - Add documentation of the SoC compatible property
> - DTS: rename SoC file to mt6589.dts
> - DTS: Delete not present cache controller
> - DTS: Add missing GICv2 properties
> - DTS: Change clock names
> - DTS: Add Aquaris5 board
>
> 4. Add earlyprintk
> - patch droped until serial driver is available
>
> 5. Add support for Aquaris5 mobile phone
>
>
>
> Matthias Brugger (6):
>    clocksource: Add support for the Mediatek SoCs
>    dt-bindings: add mtk-timer bindings
>    vendor-prefixes: add prefix for Mediaktek Inc.
>    arm: add basic support for Mediatek MT6589 boards
>    dt-bindings: add documentation for Mediatek SoC
>    arm: mediatek: add dts for Aquaris5 mobile phone
>
>   .../devicetree/bindings/arm/mediatek-mt65xx.txt    |    8 +
>   .../bindings/timer/mediatek,mtk-timer.txt          |   18 ++
>   .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>   arch/arm/Kconfig                                   |    2 +
>   arch/arm/Makefile                                  |    1 +
>   arch/arm/boot/dts/mt6589-aquaris5.dts              |   25 ++
>   arch/arm/boot/dts/mt6589.dtsi                      |   94 ++++++++
>   arch/arm/mach-mediatek/Kconfig                     |    6 +
>   arch/arm/mach-mediatek/Makefile                    |    1 +
>   arch/arm/mach-mediatek/mediatek.c                  |   27 +++
>   drivers/clocksource/Kconfig                        |    4 +
>   drivers/clocksource/Makefile                       |    1 +
>   drivers/clocksource/mtk_timer.c                    |  242 ++++++++++++++++++++
>   13 files changed, 430 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/arm/mediatek-mt65xx.txt
>   create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
>   create mode 100644 arch/arm/boot/dts/mt6589-aquaris5.dts
>   create mode 100644 arch/arm/boot/dts/mt6589.dtsi
>   create mode 100644 arch/arm/mach-mediatek/Kconfig
>   create mode 100644 arch/arm/mach-mediatek/Makefile
>   create mode 100644 arch/arm/mach-mediatek/mediatek.c
>   create mode 100644 drivers/clocksource/mtk_timer.c
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

