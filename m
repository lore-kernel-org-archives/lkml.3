Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaDOK2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:28:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39014 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754442AbaDOK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:28:15 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 00/15] iio: adc: at91 cleanups and atmel_tsadcc removal
Date: Tue, 15 Apr 2014 12:27:55 +0200
Message-Id: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a followup of my previous series: iio: adc: at91 fixes

1-3) The first 3 patches are cleaning up the patform_data used for at91_adc.

4-5) Then touchscreen support for older ADCs is added, this allows to use that
     for the sam9m10g45ek.

6) Following those modifications, the mach/at91_adc.h is not used anywhere but
   in the at91_adc driver so it is remove and its content (register definitions)
   placed directly in the driver.

7-9) at91sam9rl support is added to at91_adc and is used for the at91sam9rl
     based boards.

10-11) Prepare the atmel_tsadcc removal by switching sam9rl and sam9g45 to use
       only at91_adc instead of atmel_tsadcc.

12-15) atmel_tsadcc removal

This patch set depends on a few patches that should be included soon in 3.15.

Changes in v3:
 - rebased on v3.15-rc1
 - reordered patch 12
 - collected acks

Changes in v2:
 - reworked the IRQ handlers in patch 4 as suggested by Dmitry and Thomas
 - ts_bufferedmeasure is now a bool
 - the multiline comment is now correctly formatted
 - improved commit log for patch 5

Alexandre Belloni (15):
  ARM: at91: sam9g45: remove unused platform_data
  ARM: at91: sam9260: remove unused platform_data
  iio: adc: at91: cleanup platform_data
  iio: adc: at91_adc: Add support for touchscreens without TSMR
  ARM: at91: sam9m10g45ek: Add touchscreen support through at91_adc
  iio: adc: at91: remove unused include from include/mach
  iio: adc: at91: add sam9rl support
  ARM: at91: sam9rl: add at91_adc to support adc and touchscreen
  ARM: at91: sam9rlek add touchscreen support through at91_adc
  ARM: at91: sam9g45: switch from atmel_tsadcc to at91_adc
  ARM: at91: sam9rl: switch from atmel_tsadcc to at91_adc
  ARM: at91: remove atmel_tsadcc from sama5_defconfig
  Input: atmel_tsadcc: remove driver
  ARM: at91: remove atmel_tsadcc platform_data
  ARM: at91/dt: at91-cosino_mega2560 remove useless tsadcc node

 MAINTAINERS                                |   6 -
 arch/arm/boot/dts/at91-cosino_mega2560.dts |   5 -
 arch/arm/configs/at91sam9g45_defconfig     |   3 +-
 arch/arm/configs/at91sam9rl_defconfig      |   3 +-
 arch/arm/configs/sama5_defconfig           |   1 -
 arch/arm/mach-at91/at91sam9260_devices.c   |  10 -
 arch/arm/mach-at91/at91sam9g45.c           |   2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c   |  63 +----
 arch/arm/mach-at91/at91sam9rl.c            |   7 +
 arch/arm/mach-at91/at91sam9rl_devices.c    |  83 +++++--
 arch/arm/mach-at91/board-sam9m10g45ek.c    |  16 +-
 arch/arm/mach-at91/board-sam9rlek.c        |  16 +-
 arch/arm/mach-at91/board.h                 |   3 -
 arch/arm/mach-at91/include/mach/at91_adc.h | 107 ---------
 drivers/iio/adc/at91_adc.c                 | 340 +++++++++++++++++++++++----
 drivers/input/touchscreen/Kconfig          |  12 -
 drivers/input/touchscreen/Makefile         |   1 -
 drivers/input/touchscreen/atmel_tsadcc.c   | 358 -----------------------------
 include/linux/platform_data/at91_adc.h     |  27 +--
 include/linux/platform_data/atmel.h        |   7 -
 20 files changed, 382 insertions(+), 688 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_adc.h
 delete mode 100644 drivers/input/touchscreen/atmel_tsadcc.c

-- 
1.8.3.2

