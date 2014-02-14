Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaBNGae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:30:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51867 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaBNGac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:30:32 -0500
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Milo Kim <milo.kim@ti.com>
Subject: [PATCH 00/10] Support TI Light Management Unit devices
Date: Fri, 14 Feb 2014 15:30:10 +0900
Message-ID: <1392359410-6852-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI LMU (Lighting Management Unit) driver supports lighting devices such like
LM3532, LM3631, LM3633, LM3695 and LM3697.

         Enable pin  Backlights  PWM control  Light effects  Others
         ----------  ----------  -----------  -------------  ------
LM3532       Yes         Yes         Yes      ramp up/down
LM3631       Yes         Yes         Yes      slope          5 regulators
LM3633       Yes         Yes         Yes      ramp up/down   LEDs
                                              /pattern
LM3695       Yes         Yes         No
LM3697       Yes         Yes         Yes      ramp up/down

This patch-set consists of several parts below.

  TI LMU                : HW enable pin control. I2C register access
  TI LMU effect         : Light effect support for backlight and LED
  TI LMU backlight      : Backlight subsystem, PWM, control bank assignment
  Each backlight driver : Chip dependent code
  LM3633 LED            : LED subsystem, pattern generation
  LM3631 regulator      : Regulator drivers for the display bias

Device tree documentation is also included.

Milo Kim (10):
  mfd: Add TI LMU driver
  backlight: Add TI LMU backlight common driver
  backlight: ti-lmu-backlight: Add LM3532 driver
  backlight: ti-lmu-backlight: Add LM3631 driver
  backlight: ti-lmu-backlight: Add LM3633 driver
  backlight: ti-lmu-backlight: Add LM3695 driver
  backlight: ti-lmu-backlight: Add LM3697 driver
  leds: Add LM3633 driver
  regulator: Add LM3631 driver
  Documentation: Add device tree bindings for TI LMU devices

 .../devicetree/bindings/leds/leds-lm3633.txt       |   39 ++
 Documentation/devicetree/bindings/mfd/ti-lmu.txt   |  182 ++++++
 .../bindings/regulator/lm3631-regulator.txt        |   49 ++
 .../bindings/video/backlight/ti-lmu-backlight.txt  |  127 ++++
 Documentation/leds/leds-lm3633.txt                 |   38 ++
 drivers/leds/Kconfig                               |   10 +
 drivers/leds/Makefile                              |    1 +
 drivers/leds/leds-lm3633.c                         |  661 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/ti-lmu-effect.c                        |  328 ++++++++++
 drivers/mfd/ti-lmu.c                               |  464 ++++++++++++++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/lm3631-regulator.c               |  285 +++++++++
 drivers/video/backlight/Kconfig                    |   51 ++
 drivers/video/backlight/Makefile                   |    6 +
 drivers/video/backlight/lm3532_bl.c                |  240 +++++++
 drivers/video/backlight/lm3631_bl.c                |  186 ++++++
 drivers/video/backlight/lm3633_bl.c                |  244 ++++++++
 drivers/video/backlight/lm3695_bl.c                |  143 +++++
 drivers/video/backlight/lm3697_bl.c                |  224 +++++++
 drivers/video/backlight/ti-lmu-backlight.c         |  369 +++++++++++
 drivers/video/backlight/ti-lmu-backlight.h         |   78 +++
 include/linux/mfd/ti-lmu-effect.h                  |  109 ++++
 include/linux/mfd/ti-lmu-register.h                |  269 ++++++++
 include/linux/mfd/ti-lmu.h                         |  150 +++++
 27 files changed, 4275 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-lm3633.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/ti-lmu.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
 create mode 100644 Documentation/leds/leds-lm3633.txt
 create mode 100644 drivers/leds/leds-lm3633.c
 create mode 100644 drivers/mfd/ti-lmu-effect.c
 create mode 100644 drivers/mfd/ti-lmu.c
 create mode 100644 drivers/regulator/lm3631-regulator.c
 create mode 100644 drivers/video/backlight/lm3532_bl.c
 create mode 100644 drivers/video/backlight/lm3631_bl.c
 create mode 100644 drivers/video/backlight/lm3633_bl.c
 create mode 100644 drivers/video/backlight/lm3695_bl.c
 create mode 100644 drivers/video/backlight/lm3697_bl.c
 create mode 100644 drivers/video/backlight/ti-lmu-backlight.c
 create mode 100644 drivers/video/backlight/ti-lmu-backlight.h
 create mode 100644 include/linux/mfd/ti-lmu-effect.h
 create mode 100644 include/linux/mfd/ti-lmu-register.h
 create mode 100644 include/linux/mfd/ti-lmu.h

-- 
1.7.9.5

