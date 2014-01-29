Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaA2VAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:00:14 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:49653 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaA2VAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:00:10 -0500
From: Matt Porter <mporter@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        linux-pwm@vger.kernel.org,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 0/5] IIO pulse capture support for TI ECAP
Date: Wed, 29 Jan 2014 15:59:54 -0500
Message-Id: <1391029199-3670-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for PWM capture devices within IIO and
adds a TI ECAP IIO driver.

PWM capture devices are supported using a new IIO "pulse" channel type.

The IIO ECAP driver implements interrupt driven triggered buffer capture
only as raw sample reads are not applicable to this hardware.
Initially, the driver supports a single pulse width measurement with
configurable polarity. The ECAP hardware can support measurement of a
complete period and duty cycle but this is not yet implemented.

Matt Porter (5):
  iio: add support for pulse width capture devices
  iio: pulse: add TI ECAP driver
  iio: enable selection and build of pulse drivers
  pwm: enable TI PWMSS if the IIO tiecap driver is selected
  ARM: dts: AM33XX: Add ecap interrupt properties

 arch/arm/boot/dts/am33xx.dtsi   |   6 +
 drivers/iio/Kconfig             |   1 +
 drivers/iio/Makefile            |   1 +
 drivers/iio/industrialio-core.c |   1 +
 drivers/iio/pulse/Kconfig       |  20 ++
 drivers/iio/pulse/Makefile      |   6 +
 drivers/iio/pulse/tiecap.c      | 493 ++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/Kconfig             |   2 +-
 include/linux/iio/types.h       |   1 +
 9 files changed, 530 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iio/pulse/Kconfig
 create mode 100644 drivers/iio/pulse/Makefile
 create mode 100644 drivers/iio/pulse/tiecap.c

-- 
1.8.4

