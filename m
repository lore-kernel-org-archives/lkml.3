Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3ILBbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:31:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46890 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab3ILBbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:31:21 -0400
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Milo Kim <milo.kim@ti.com>
Subject: [PATCH v3 0/4] LP3943 MFD driver for a GPIO expander and a PWM generator
Date: Thu, 12 Sep 2013 10:30:41 +0900
Message-ID: <1378949441-6073-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP3943 is an integrated device capable of driving 16 output channels.
It can be used for GPIO expander and PWM generators.
LP3493 registers are controlled via the I2C interface.

This patch-set consists of four parts - MFD, GPIO, PWM and documents.

Major updates in v3:

* MFD
  Lee Jones pointed confusing pin number notation.
  Now, each output pin number is exactly matched to each enum value.

  LP3943 has a static configuration from platform data or the device tree,
  So, I keep the driver structure instead of using the pin control subsystem.
  (https://lkml.org/lkml/2013/8/14/490)

* PWM
  Do not emulate 'set_polarity' function in case of unsupported feature by
  the chip.
  Code fixes based on Thierry Reding's comments.
  (https://lkml.org/lkml/2013/8/14/188)

* Documentation
  From Thierry's suggestion, detailed driver description was moved to
  'Documentation/lp3943.txt'.
  Fix device tree bindings from maintainers' comments.
  (https://lkml.org/lkml/2013/7/31/226)
  (https://lkml.org/lkml/2013/8/14/569)

Milo Kim (4):
  mfd: add LP3943 MFD driver
  gpio: add LP3943 I2C GPIO expander driver
  pwm: add LP3943 PWM driver
  Documentation: add LP3943 DT bindings and document

 Documentation/00-INDEX                             |    2 +
 .../devicetree/bindings/gpio/gpio-lp3943.txt       |   37 +++
 Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 ++
 .../devicetree/bindings/pwm/pwm-lp3943.txt         |   58 ++++
 Documentation/lp3943.txt                           |   62 ++++
 drivers/gpio/Kconfig                               |    8 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-lp3943.c                         |  242 +++++++++++++++
 drivers/mfd/Kconfig                                |   11 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/lp3943.c                               |  148 +++++++++
 drivers/pwm/Kconfig                                |   10 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-lp3943.c                           |  314 ++++++++++++++++++++
 include/linux/mfd/lp3943.h                         |  114 +++++++
 15 files changed, 1042 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
 create mode 100644 Documentation/lp3943.txt
 create mode 100644 drivers/gpio/gpio-lp3943.c
 create mode 100644 drivers/mfd/lp3943.c
 create mode 100644 drivers/pwm/pwm-lp3943.c
 create mode 100644 include/linux/mfd/lp3943.h

-- 
1.7.9.5

