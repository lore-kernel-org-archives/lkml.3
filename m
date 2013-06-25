Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab3FYLTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:19:47 -0400
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:45949 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab3FYLTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:19:46 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v5 0/7] ARM:sti: Add STiH415/STiH416 platform and board support
Date: Tue, 25 Jun 2013 12:13:42 +0100
Message-Id: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch-set adds basic support for STMicroelectronics STi series SOCs
which includes STiH415 and STiH416 with B2000 and B2020 board support.

STiH415 and STiH416 are dual-core ARM Cortex-A9 CPU, designed for use in
Set-top-boxes. The SOC support is available in mach-sti which contains
support code for STiH415, STiH416 SOCs including the generic board support.

The reason for adding two SOCs at this patch set is to show that no new
C code is required for second SOC(STiH416) support.

This patch-set only contains the SOC support, all the driver support for
this platform are submitted to respective mailing lists.

Changes since v4:
	- Renamed mach-stixxxx to mach-sti as suggested by Olof J.

Changes since v3:
	- removed debug_ll_io_init callback from mach desc as suggested by Arnd.
	- moved serial/pinctrl/clocksource driver patches out of this series as
	prefered by Arnd.

Changes since v2:
	- Fixed few plat-* specfic references in comments pointed by Michal S.
	- Removed un-used variables in mach code as pointed by Michal S.
	- Split adding SOC to multi_v7_defconfig in to two patches as discussed
	with Mark R.
	
Changes since RFC:
	- all the SOC support code is moved to mach-stixxxx
	- seperated DEBUG_LL code to new patch.
	- removed unnecessary #interrupt-cells
	- renamed uart to serial
	- moved to multi_v7_defconfig
	- used menuconfig in mach-stixxx/Kconfig
	- removed of_platform_populate as generic code does it for you.
	- scu address is ioremaped.

Srinivas Kandagatla (7):
  ARM:sti: Add STiH415 SOC support
  ARM:sti: Add STiH416 SOC support
  ARM:sti: Add DEBUG_LL console support
  ARM:multi_v7_defconfig: rerun savedefconfig
  ARM:sti: Add sti options to multi_v7_defconfig
  ARM:stih41x: Add B2000 board support
  ARM:stih41x: Add B2020 board support

 Documentation/arm/sti/overview.txt         |   33 +++
 Documentation/arm/sti/stih415-overview.txt |   12 ++
 Documentation/arm/sti/stih416-overview.txt |   12 ++
 MAINTAINERS                                |    9 +
 arch/arm/Kconfig                           |    2 +
 arch/arm/Kconfig.debug                     |   35 ++++
 arch/arm/Makefile                          |    1 +
 arch/arm/boot/dts/Makefile                 |    4 +
 arch/arm/boot/dts/st-pincfg.h              |   71 +++++++
 arch/arm/boot/dts/stih415-b2000.dts        |   15 ++
 arch/arm/boot/dts/stih415-b2020.dts        |   15 ++
 arch/arm/boot/dts/stih415-clock.dtsi       |   38 ++++
 arch/arm/boot/dts/stih415-pinctrl.dtsi     |  268 +++++++++++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi             |   87 ++++++++
 arch/arm/boot/dts/stih416-b2000.dts        |   16 ++
 arch/arm/boot/dts/stih416-b2020.dts        |   16 ++
 arch/arm/boot/dts/stih416-clock.dtsi       |   41 ++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi     |  295 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih416.dtsi             |   96 +++++++++
 arch/arm/boot/dts/stih41x-b2000.dtsi       |   41 ++++
 arch/arm/boot/dts/stih41x-b2020.dtsi       |   42 ++++
 arch/arm/boot/dts/stih41x.dtsi             |   38 ++++
 arch/arm/configs/multi_v7_defconfig        |   31 ++--
 arch/arm/include/debug/sti.S               |   61 ++++++
 arch/arm/mach-sti/Kconfig                  |   45 +++++
 arch/arm/mach-sti/Makefile                 |    2 +
 arch/arm/mach-sti/board-dt.c               |   48 +++++
 arch/arm/mach-sti/headsmp.S                |   44 ++++
 arch/arm/mach-sti/platsmp.c                |  117 +++++++++++
 arch/arm/mach-sti/smp.h                    |   17 ++
 30 files changed, 1535 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/arm/sti/overview.txt
 create mode 100644 Documentation/arm/sti/stih415-overview.txt
 create mode 100644 Documentation/arm/sti/stih416-overview.txt
 create mode 100644 arch/arm/boot/dts/st-pincfg.h
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
 create mode 100644 arch/arm/include/debug/sti.S
 create mode 100644 arch/arm/mach-sti/Kconfig
 create mode 100644 arch/arm/mach-sti/Makefile
 create mode 100644 arch/arm/mach-sti/board-dt.c
 create mode 100644 arch/arm/mach-sti/headsmp.S
 create mode 100644 arch/arm/mach-sti/platsmp.c
 create mode 100644 arch/arm/mach-sti/smp.h

-- 
1.7.6.5

