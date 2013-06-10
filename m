Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3FJJXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:23:19 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:54538 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012Ab3FJJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:23:15 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH v2 00/11] ARM:STixxxx: Add STixxxx platform and board support
Date: Mon, 10 Jun 2013 10:17:08 +0100
Message-Id: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Here is new patch-set incorporating all the review comments.

This patch-set adds basic support for STMicroelectronics STixxxx SOCs
which includes STiH415 and STiH416 with B2000 and B2020 board support.

STiH415 and STiH416 are dual-core ARM Cortex-A9 CPU, designed for use in
Set-top-boxes. The SOC support is available in mach-stixxxx which contains
support code for STiH415, STiH416 SOCs including the generic board support.

Only device drivers included in this patch set are UART and pinctrl, other
drivers will be added in future.

The reason for adding two SOCs at this patch set is to show that no new
C code is required for second SOC(STiH416) support.

Thankyou all for reviewing the first set of RFC patches.
I would appreciate any feedback on these patches.

Changes since RFC:
 - st-asc Serial driver:
	- modified kconfig to remove default y
	- removed all the forward declaration.
	- use dynamic major numbering.
	- merge header-file in to driver.

 - ARM Global timer:
	- moved to drivers/clocksource.
	- added revision check in driver.
	- removed unused header file.
	- moved to u64 from union gt_counter
	- comments added in get_counter
	- removed leftover debug code.
	- moved code to use __raw_readl/writel.
	- used DIV_ROUND_CLOSEST
	- added check in interrupt handler.
	- expanded CE and CS acronyms usage.
	- Fixed minimum clock ticks value.
	- move to use clocksource_register_hz
	- added arch sched_clock support.
	- added ERRATA 740657 workaround.

 - ST-System Configuration Registers:
	- moved from syscon usage to st specific driver.

 - ST Pinctrl support:
	- fixed few typos in the documentation.
	- moved some of the retime offset information to driver.
	
 - STixxxx Support:
	- all the SOC support code is moved to mach-stixxxx
	- seperated DEBUG_LL code to new patch.
	- removed unnecessary #interrupt-cells
	- renamed uart to serial
	- moved to multi_v7_defconfig
	- used menuconfig in mach-stixxx/Kconfig
	- removed of_platform_populate as generic code does it for you.
	- scu address is ioremaped.

Thanks,
srini

Srinivas Kandagatla (10):
  serial:st-asc: Add ST ASC driver.
  regmap: Add regmap_field APIs
  mfd:stixxxx-syscfg: Add ST System Configuration support.
  pinctrl:stixxxx: Add pinctrl and pinconf support.
  ARM:stixxxx: Add STiH415 SOC support
  ARM:stixxxx: Add STiH416 SOC support
  ARM:stixxxx: Add DEBUG_LL console support
  ARM:stixxxx: Add stixxxx options to multi_v7_defconfig
  ARM:stih41x: Add B2000 board support
  ARM:stih41x: Add B2020 board support

Stuart Menefy (1):
  clocksource:global_timer: Add ARM global timer support.

 Documentation/arm/stixxxx/overview.txt             |   33 +
 Documentation/arm/stixxxx/stih415-overview.txt     |   12 +
 Documentation/arm/stixxxx/stih416-overview.txt     |   12 +
 .../devicetree/bindings/arm/global_timer.txt       |   21 +
 .../devicetree/bindings/mfd/stixxxx-syscfg.txt     |   18 +
 .../bindings/pinctrl/pinctrl-stixxxx.txt           |  116 ++
 .../devicetree/bindings/tty/serial/st-asc.txt      |   18 +
 MAINTAINERS                                        |   11 +
 arch/arm/Kconfig                                   |    2 +
 arch/arm/Kconfig.debug                             |   38 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/Makefile                         |    4 +
 arch/arm/boot/dts/stih415-b2000.dts                |   15 +
 arch/arm/boot/dts/stih415-b2020.dts                |   15 +
 arch/arm/boot/dts/stih415-clock.dtsi               |   38 +
 arch/arm/boot/dts/stih415-pinctrl.dtsi             |  326 ++++++
 arch/arm/boot/dts/stih415.dtsi                     |  102 ++
 arch/arm/boot/dts/stih416-b2000.dts                |   16 +
 arch/arm/boot/dts/stih416-b2020.dts                |   16 +
 arch/arm/boot/dts/stih416-clock.dtsi               |   41 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi             |  377 ++++++
 arch/arm/boot/dts/stih416.dtsi                     |  111 ++
 arch/arm/boot/dts/stih41x-b2000.dtsi               |   41 +
 arch/arm/boot/dts/stih41x-b2020.dtsi               |   42 +
 arch/arm/boot/dts/stih41x.dtsi                     |   38 +
 arch/arm/boot/dts/stixxxx-pincfg.h                 |   94 ++
 arch/arm/configs/multi_v7_defconfig                |   32 +-
 arch/arm/include/debug/stixxxx.S                   |   61 +
 arch/arm/mach-stixxxx/Kconfig                      |   45 +
 arch/arm/mach-stixxxx/Makefile                     |    2 +
 arch/arm/mach-stixxxx/board-dt.c                   |   50 +
 arch/arm/mach-stixxxx/headsmp.S                    |   44 +
 arch/arm/mach-stixxxx/platsmp.c                    |  117 ++
 arch/arm/mach-stixxxx/smp.h                        |   19 +
 drivers/base/regmap/internal.h                     |    8 +
 drivers/base/regmap/regmap.c                       |  104 ++
 drivers/clocksource/Kconfig                        |   13 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/arm_global_timer.c             |  368 ++++++
 drivers/mfd/Kconfig                                |   10 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/stixxxx-syscfg.c                       |  168 +++
 drivers/pinctrl/Kconfig                            |   11 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-stixxxx.c                  | 1212 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-stixxxx.h                  |  197 ++++
 drivers/tty/serial/Kconfig                         |   16 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/st-asc.c                        |  911 +++++++++++++++
 include/linux/mfd/stixxxx-syscfg.h                 |   15 +
 include/linux/regmap.h                             |   42 +
 include/uapi/linux/serial_core.h                   |    3 +
 52 files changed, 4993 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/arm/stixxxx/overview.txt
 create mode 100644 Documentation/arm/stixxxx/stih415-overview.txt
 create mode 100644 Documentation/arm/stixxxx/stih416-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/global_timer.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/stixxxx-syscfg.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-stixxxx.txt
 create mode 100644 Documentation/devicetree/bindings/tty/serial/st-asc.txt
 create mode 100644 arch/arm/boot/dts/stih415-b2000.dts
 create mode 100644 arch/arm/boot/dts/stih415-b2020.dts
 create mode 100644 arch/arm/boot/dts/stih415-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih415.dtsi
 create mode 100644 arch/arm/boot/dts/stih416-b2000.dts
 create mode 100644 arch/arm/boot/dts/stih416-b2020.dts
 create mode 100644 arch/arm/boot/dts/stih416-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih416-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih416.dtsi
 create mode 100644 arch/arm/boot/dts/stih41x-b2000.dtsi
 create mode 100644 arch/arm/boot/dts/stih41x-b2020.dtsi
 create mode 100644 arch/arm/boot/dts/stih41x.dtsi
 create mode 100644 arch/arm/boot/dts/stixxxx-pincfg.h
 create mode 100644 arch/arm/include/debug/stixxxx.S
 create mode 100644 arch/arm/mach-stixxxx/Kconfig
 create mode 100644 arch/arm/mach-stixxxx/Makefile
 create mode 100644 arch/arm/mach-stixxxx/board-dt.c
 create mode 100644 arch/arm/mach-stixxxx/headsmp.S
 create mode 100644 arch/arm/mach-stixxxx/platsmp.c
 create mode 100644 arch/arm/mach-stixxxx/smp.h
 create mode 100644 drivers/clocksource/arm_global_timer.c
 create mode 100644 drivers/mfd/stixxxx-syscfg.c
 create mode 100644 drivers/pinctrl/pinctrl-stixxxx.c
 create mode 100644 drivers/pinctrl/pinctrl-stixxxx.h
 create mode 100644 drivers/tty/serial/st-asc.c
 create mode 100644 include/linux/mfd/stixxxx-syscfg.h

-- 
1.7.6.5

