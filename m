Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3EVHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:09:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45165 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab3EVHJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:09:47 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 00/11] Convert GPIO Davinci to platform driver
Date: Wed, 22 May 2013 12:40:23 +0530
Message-ID: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO Davinci driver converted to platform driver to support DT booting.
In this patch series
- Cleaned gpio Davinci driver code with proper commenting style and appropriate
  variable names.
- Create platform driver for GPIO Davinci in da8xx and dm* platforms and removed
  gpio related member updation in davinci_soc_info structure.
- DT support added for da850 board and tested on da850 EVM.
- Remove soc_info reference in the gpio davinci driver and start uses
  gpiolib interface.

This sereise based on [1] and is avilable at [2].
1. http://gitorious.org/linux-davinci/linux-davinci/trees/davinci-for-v3.10/soc
2. https://github.com/avinashphilip/am335x_linux/commits/linux_davinci_v3.10_soc_gpio

KV Sujith (6):
  ARM: davinci: GPIO: Add platform data structure
  gpio: davinci: Modify to platform driver
  ARM: davinci: da8xx: creation of gpio platform device
  gpio: davinci: DT changes for driver
  ARM: davinci: da850: add GPIO DT entries
  ARM: davinci: da850 evm: add GPIO DT data

Philip Avinash (5):
  gpio: davinci: coding style correction
  ARM: davinci: creation of gpio platform device for dm platforms
  ARM: davinci: da8xx: gpio device creation
  ARM: davinci: create davinci gpio device for dm platforms
  ARM: davinci: start using gpiolib support

 .../devicetree/bindings/gpio/gpio-davinci.txt      |   26 ++
 arch/arm/Kconfig                                   |    1 -
 arch/arm/boot/dts/da850-evm.dts                    |   19 ++
 arch/arm/boot/dts/da850.dtsi                       |    9 +
 arch/arm/mach-davinci/board-da830-evm.c            |   19 +-
 arch/arm/mach-davinci/board-da850-evm.c            |   11 +
 arch/arm/mach-davinci/board-dm355-evm.c            |   27 ++
 arch/arm/mach-davinci/board-dm355-leopard.c        |    1 +
 arch/arm/mach-davinci/board-dm365-evm.c            |   28 ++
 arch/arm/mach-davinci/board-dm644x-evm.c           |   26 ++
 arch/arm/mach-davinci/board-dm646x-evm.c           |   27 ++
 arch/arm/mach-davinci/board-neuros-osd2.c          |    1 +
 arch/arm/mach-davinci/board-omapl138-hawk.c        |    2 +
 arch/arm/mach-davinci/da830.c                      |    4 -
 arch/arm/mach-davinci/da850.c                      |    4 -
 arch/arm/mach-davinci/devices-da8xx.c              |   26 ++
 arch/arm/mach-davinci/devices.c                    |   14 +
 arch/arm/mach-davinci/dm355.c                      |    4 -
 arch/arm/mach-davinci/dm365.c                      |    5 -
 arch/arm/mach-davinci/dm644x.c                     |    4 -
 arch/arm/mach-davinci/dm646x.c                     |    4 -
 arch/arm/mach-davinci/include/mach/common.h        |    4 +
 arch/arm/mach-davinci/include/mach/da8xx.h         |    1 +
 arch/arm/mach-davinci/include/mach/gpio-davinci.h  |    8 +-
 drivers/gpio/gpio-davinci.c                        |  346 +++++++++++++-------
 include/linux/platform_data/gpio-davinci.h         |   79 +++++
 26 files changed, 543 insertions(+), 157 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt
 create mode 100644 include/linux/platform_data/gpio-davinci.h

-- 
1.7.9.5

