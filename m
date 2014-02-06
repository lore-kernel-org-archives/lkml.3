Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaBFFut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:50:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46510 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBFFur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:50:47 -0500
From: Keerthy <j-keerthy@ti.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <grant.likely@linaro.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 0/4] [PATCH v2 0/4] MFD: TPS65218: Drivers for TPS65218 PMIC.
Date: Thu, 6 Feb 2014 11:20:10 +0530
Message-ID: <1391665814-18814-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS65218 chip is a power management IC for Portable Navigation Systems
and Tablet Computing devices. It contains the following components:

 - Regulators.
 - Over Temperature warning and Shut down.

This patch adds support for TPS65218 mfd device. At this time only
the regulator functionality is made available.

The series is boot tested on am43x-epos-evm board.

Changes in v2:

* Introduced register cache for interrupt mask register. 
* regulator_map_voltage_linear_range instead of custom functions.
* Fixed couple of more minor comments.

Keerthy (4):
  mfd: DT bindings for TPS65218 PMIC
  MFD: TPS65218: Add driver for the TPS65218 PMIC
  Regulators: TPS65218: Add Regulator driver for TPS65218 PMIC
  ARM: dts: TPS65218: Add dts nodes of TPS65218 PMIC

 Documentation/devicetree/bindings/mfd/tps65218.txt |   58 ++++
 .../devicetree/bindings/regulator/tps65218.txt     |   22 ++
 arch/arm/boot/dts/am43x-epos-evm.dts               |   40 +++
 drivers/mfd/Kconfig                                |   15 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/tps65218.c                             |  281 ++++++++++++++++++
 drivers/regulator/Kconfig                          |    9 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/tps65218-regulator.c             |  304 ++++++++++++++++++++
 include/linux/mfd/tps65218.h                       |  284 ++++++++++++++++++
 10 files changed, 1015 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65218.txt
 create mode 100644 drivers/mfd/tps65218.c
 create mode 100644 drivers/regulator/tps65218-regulator.c
 create mode 100644 include/linux/mfd/tps65218.h

-- 
1.7.9.5

