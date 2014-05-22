Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaEVECK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:02:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41254 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaEVECH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:02:07 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>
CC: <robh+dt@kernel.org>, <mark.rutland@arm.com>, <sameo@linux.intel.com>,
        <grant.likely@linaro.org>, <ian@slimlogic.co.uk>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <broonie@linaro.org>, <lee.jones@linaro.org>,
        <linux-omap@vger.kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v3 0/4] tps65917: Drivers for TPS65917 PMIC
Date: Thu, 22 May 2014 09:30:35 +0530
Message-ID: <1400731239-3180-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS65917 chip is a power management IC for Portable Navigation Systems
and Tablet Computing devices. It contains the following components:

 - Regulators.
 - GPADC.
 - Over Temperature warning and Shut down.

This patch series adds support for TPS65917 mfd device. At this time only
the regulator functionality is made available.

The closest drivers are PALMAS series drivers.
The register set is changed. Bit-field defenitions are changed.
Hence based on the PALMAS drivers and created a new set of drivers
with code changes as required.

The patches are boot tested on DRA72-EVM.

Keerthy (4):
  MFD: DT bindings for the TPS65917 family MFD
  Regulators: Add TPS65917 Bindings
  mfd: tps65917: Add driver for the TPS65917 PMIC
  regulator: tps65917: Add Regulator driver for TPS65917 PMIC

 Documentation/devicetree/bindings/mfd/tps65917.txt |   35 +
 .../bindings/regulator/tps65917-pmic.txt           |   67 +
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/tps65917.c                             |  594 ++++++++
 drivers/regulator/Kconfig                          |   12 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/tps65917-regulator.c             |  809 +++++++++++
 include/linux/mfd/tps65917.h                       | 1485 ++++++++++++++++++++
 9 files changed, 3016 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65917.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65917-pmic.txt
 create mode 100644 drivers/mfd/tps65917.c
 create mode 100644 drivers/regulator/tps65917-regulator.c
 create mode 100644 include/linux/mfd/tps65917.h

-- 
1.7.9.5

