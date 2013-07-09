Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3GIGn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:43:27 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:47717 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141Ab3GIGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:43:25 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <grant.likely@linaro.org>, <haojian.zhuang@gmail.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH V3 0/3] bring up pxa988 with DT
Date: Tue, 9 Jul 2013 14:42:43 +0800
Message-ID: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is supposed to bring up pxa988 SMP.

ChangeLog
V3:
1. change all Marvell prefix to 'marvell'
2. Support CLOCKSOURCE for mmp timer
3. Modify the bring up patch according to Arnd's comments.

V2:
1. use early_init call for handler init.
2. Add sanity check for maximum core count.

Neil Zhang (3):
  dts: change Marvell prefix to 'marvell'
  clocksource: mmp: support CLOCKSOURCE OF DECLARE
  ARM: mmp: bring up pxa988 with device tree support

 .../devicetree/bindings/arm/mrvl/intc.txt          |   16 +-
 .../devicetree/bindings/arm/mrvl/mrvl.txt          |    6 +-
 .../devicetree/bindings/arm/mrvl/timer.txt         |    4 +-
 Documentation/devicetree/bindings/i2c/i2c-pxa.txt  |   14 +-
 .../devicetree/bindings/mmc/sdhci-pxa.txt          |    8 +-
 .../devicetree/bindings/rtc/sa1100-rtc.txt         |    4 +-
 .../devicetree/bindings/serial/mrvl-serial.txt     |    2 +-
 arch/arm/boot/dts/mmp2-brownstone.dts              |    2 +-
 arch/arm/boot/dts/mmp2.dtsi                        |   56 +++---
 arch/arm/boot/dts/pxa168-aspenite.dts              |    2 +-
 arch/arm/boot/dts/pxa168.dtsi                      |   24 ++--
 arch/arm/boot/dts/pxa2xx.dtsi                      |   16 +-
 arch/arm/boot/dts/pxa3xx.dtsi                      |    2 +-
 arch/arm/boot/dts/pxa910-dkb.dts                   |    2 +-
 arch/arm/boot/dts/pxa910.dtsi                      |   27 ++--
 .../dts/{pxa168-aspenite.dts => pxa988-dkb.dts}    |   12 +-
 arch/arm/boot/dts/pxa988.dtsi                      |  190 ++++++++++++++++++++
 arch/arm/mach-mmp/Kconfig                          |   18 ++
 arch/arm/mach-mmp/Makefile                         |    1 +
 arch/arm/mach-mmp/common.c                         |   11 +-
 arch/arm/mach-mmp/common.h                         |    2 +
 arch/arm/mach-mmp/headsmp.S                        |  104 +++++++++++
 arch/arm/mach-mmp/include/mach/addr-map.h          |    6 +
 arch/arm/mach-mmp/irq.c                            |   16 +-
 arch/arm/mach-mmp/mmp-dt.c                         |   33 ++--
 arch/arm/mach-mmp/mmp2-dt.c                        |   60 +++++-
 arch/arm/mach-mmp/platsmp.c                        |  167 +++++++++++++++++
 arch/arm/mach-mmp/reset.c                          |   66 +++++++
 arch/arm/mach-mmp/reset.h                          |   29 +++
 arch/arm/mach-mmp/time.c                           |   15 +--
 arch/arm/mach-pxa/pxa-dt.c                         |   14 +-
 drivers/clk/mmp/Makefile                           |    1 +
 drivers/i2c/busses/i2c-pxa.c                       |   10 +-
 drivers/mmc/host/sdhci-pxav2.c                     |    4 +-
 drivers/mmc/host/sdhci-pxav3.c                     |    4 +-
 drivers/rtc/rtc-sa1100.c                           |    4 +-
 drivers/tty/serial/pxa.c                           |    4 +-
 37 files changed, 788 insertions(+), 168 deletions(-)
 copy arch/arm/boot/dts/{pxa168-aspenite.dts => pxa988-dkb.dts} (74%)
 create mode 100644 arch/arm/boot/dts/pxa988.dtsi
 create mode 100644 arch/arm/mach-mmp/headsmp.S
 create mode 100644 arch/arm/mach-mmp/platsmp.c
 create mode 100644 arch/arm/mach-mmp/reset.c
 create mode 100644 arch/arm/mach-mmp/reset.h

-- 
1.7.4.1

