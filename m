Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaEZJ6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:58:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60955 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaEZJ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:58:03 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 0/5] tps65917: Add support for for TPS65917 PMIC 
Date: Mon, 26 May 2014 15:26:32 +0530
Message-ID: <1401098197-647-1-git-send-email-j-keerthy@ti.com>
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

The closest drivers are PALMAS series drivers. Hence adapted palmas mfd
driver to support the tps65917 PMIC.

The register set for SMPSs and LDOs are changed and the ramp delay support
is also changed. Bit-field defenitions are changed.
Hence based on the PALMAS drivers and created a new driver
for regulator with code changes as required.

The patches are boot tested on DRA72-EVM.

Keerthy (5):
  mfd: Add DT bindings for tps65917 PMIC
  Regulators: Add TPS65917 Bindings
  mfd: palmas: Add tps65917 specific definitions and enums 
  mfd: palmas: Add tps65917 support
  regulator: tps65917: Add Regulator driver for tps65917 PMIC

 Documentation/devicetree/bindings/mfd/palmas.txt   |    2 +
 .../bindings/regulator/tps65917-pmic.txt           |   67 ++
 drivers/mfd/palmas.c                               |  177 ++++-
 drivers/regulator/Kconfig                          |   12 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/tps65917-regulator.c             |  825 ++++++++++++++++++++
 include/linux/mfd/palmas.h                         |  793 +++++++++++++++++++
 7 files changed, 1872 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65917-pmic.txt
 create mode 100644 drivers/regulator/tps65917-regulator.c

-- 
1.7.9.5

