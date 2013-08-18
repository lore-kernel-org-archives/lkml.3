Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab3HRFT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 01:19:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33941 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3HRFT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 01:19:27 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v3 0/7] Convert GPIO Davinci to platform driver
Date: Sun, 18 Aug 2013 10:48:56 +0530
Message-Id: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Avinash <avinashphilip@ti.com>

To support DT booting of da850 EVM, davinci gpio driver converted to platform
driver. Also when here, start using gpiolib API for gpio get/set functionalities.
Hence removing gpio inline functionalities. However usage of gpiolib API will
cause an additional software latencies.

In this patch series
- Cleaned gpio Davinci driver code with proper commenting style.
- Create platform driver for GPIO Davinci in da8xx and dmxxx platforms and
  removed gpio related member updation in davinci_soc_info structure.
- Remove soc_info reference in the gpio davinci driver and start uses
  gpiolib interface.
- gpio-tnetv107x driver also modified to use gpiolib API interface.

This series has been tested on da850 EVM for gpio interrupt generation.
This patch series is based on Linux 3.11-rc2 and is availabel at [1].

[1] http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git/shortlog/refs/heads/davinci_gpio

Changes for v3:
1: Moved the resources to Soc file.
2: Sorted the header file inclusions alphabetically.
3: included Ack from Linus.

KV Sujith (2):
  gpio: davinci: move to platform device
  ARM: davinci: da8xx: support gpio platform device

Philip Avinash (5):
  gpio: davinci: coding style correction
  ARM: davinci: devices.c: support gpio platform device
  ARM: davinci: da8xx: gpio device creation
  ARM: davinci: dmxxx: gpio device creation
  ARM: davinci: Start using gpiolib API inplace of inline functions

 arch/arm/Kconfig                                  |    1 -
 arch/arm/mach-davinci/board-da830-evm.c           |   28 ++--
 arch/arm/mach-davinci/board-da850-evm.c           |   16 ++-
 arch/arm/mach-davinci/board-dm355-evm.c           |   33 +++--
 arch/arm/mach-davinci/board-dm355-leopard.c       |   30 +++--
 arch/arm/mach-davinci/board-dm365-evm.c           |   30 +++--
 arch/arm/mach-davinci/board-dm644x-evm.c          |   40 +++---
 arch/arm/mach-davinci/board-dm646x-evm.c          |   37 +++---
 arch/arm/mach-davinci/board-neuros-osd2.c         |   18 ++-
 arch/arm/mach-davinci/board-omapl138-hawk.c       |   10 +-
 arch/arm/mach-davinci/da830.c                     |   26 ++--
 arch/arm/mach-davinci/da850.c                     |   30 +++--
 arch/arm/mach-davinci/davinci.h                   |   19 ++-
 arch/arm/mach-davinci/devices-da8xx.c             |   26 ++++
 arch/arm/mach-davinci/devices.c                   |   13 ++
 arch/arm/mach-davinci/dm355.c                     |   53 +++++---
 arch/arm/mach-davinci/dm365.c                     |   57 +++++---
 arch/arm/mach-davinci/dm644x.c                    |   46 +++++--
 arch/arm/mach-davinci/dm646x.c                    |   46 +++++--
 arch/arm/mach-davinci/include/mach/common.h       |    2 +
 arch/arm/mach-davinci/include/mach/da8xx.h        |   23 ++--
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |   91 -------------
 arch/arm/mach-davinci/include/mach/gpio.h         |   88 -------------
 arch/arm/mach-davinci/tnetv107x.c                 |   14 +-
 drivers/gpio/gpio-davinci.c                       |  143 ++++++++++++++-------
 drivers/gpio/gpio-tnetv107x.c                     |    5 +-
 include/linux/platform_data/gpio-davinci.h        |   59 +++++++++
 27 files changed, 558 insertions(+), 426 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/include/mach/gpio-davinci.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/gpio.h
 create mode 100644 include/linux/platform_data/gpio-davinci.h

-- 
1.7.9.5

