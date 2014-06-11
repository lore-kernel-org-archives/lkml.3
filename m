Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaFKLSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:18:45 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.175]:48394 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932214AbaFKLSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:18:42 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-5.tower-38.messagelabs.com!1402485077!7231481!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 11 Jun 2014 12:11:04 +0100
Subject: [PATCH 0/8] Add initial support for DA9150 Charger & Fuel-Gauge IC
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds initial support for the Dialog DA9150 Integrated Charger &
Fuel-Gauge IC. The device also provides GPIO and GPADC functionality.

In this patch set the following is provided:
 - MFD Core support and DT bindings documentation.
 - Fix to IIO framework (inkern.c, of_iio_channel_get_by_name()) to correctly
   return NULL for failure cases.
 - IIO GPADC support and DT bindings documentation.
 - Power Supply Charger support and DT bindings documentation.
 - Add Dialog vendor prefix for DT.

 To keep patch submission from being too large, support for GPIO and Fuel-Gauge
 will come after initial support patches are accepted.

 This patch set is baselined against the v3.15 kernel version.

Adam Thomson (8):
  mfd: Add support for DA9150 combined charger & fuel-gauge device
  mfd: da9150: Add DT binding documentation for core
  iio: of_iio_channel_get_by_name() returns non-null pointers for error
    legs
  iio: Add support for DA9150 GPADC
  iio: da9150: Add DT binding documentation for GPADC
  power: Add support for DA9150 Charger
  power: da9150: Add DT binding documentation for charger
  DT: Add vendor prefix for Dialog Semiconductor Ltd.

 .../devicetree/bindings/iio/da9150-gpadc.txt       |   16 +
 Documentation/devicetree/bindings/mfd/da9150.txt   |   53 +
 .../devicetree/bindings/power/da9150-charger.txt   |   29 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/iio/adc/Kconfig                            |    9 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/da9150-gpadc.c                     |  396 +++++++
 drivers/iio/inkern.c                               |    6 +-
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/da9150-core.c                          |  398 +++++++
 drivers/mfd/da9150-i2c.c                           |  268 +++++
 drivers/power/Kconfig                              |   23 +
 drivers/power/Makefile                             |    1 +
 drivers/power/da9150-charger.c                     |  790 +++++++++++++
 include/linux/mfd/da9150/charger.h                 |   58 +
 include/linux/mfd/da9150/core.h                    |  125 +++
 include/linux/mfd/da9150/gpadc.h                   |   71 ++
 include/linux/mfd/da9150/pdata.h                   |  148 +++
 include/linux/mfd/da9150/registers.h               | 1160 ++++++++++++++++++++
 20 files changed, 3565 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/da9150-gpadc.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt
 create mode 100644 Documentation/devicetree/bindings/power/da9150-charger.txt
 create mode 100644 drivers/iio/adc/da9150-gpadc.c
 create mode 100644 drivers/mfd/da9150-core.c
 create mode 100644 drivers/mfd/da9150-i2c.c
 create mode 100644 drivers/power/da9150-charger.c
 create mode 100644 include/linux/mfd/da9150/charger.h
 create mode 100644 include/linux/mfd/da9150/core.h
 create mode 100644 include/linux/mfd/da9150/gpadc.h
 create mode 100644 include/linux/mfd/da9150/pdata.h
 create mode 100644 include/linux/mfd/da9150/registers.h

--
1.9.3

