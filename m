Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966120AbaFRKDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:03:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41731 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965516AbaFRKAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:00:47 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 0/9] mfd: tps65917: Add support for for TPS65917 PMIC 
Date: Wed, 18 Jun 2014 15:28:51 +0530
Message-ID: <1403085540-20014-1-git-send-email-j-keerthy@ti.com>
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
Hence added driver data structures for mfd and regulator drivers
for palmas and added support for tps65917.

The patches are boot tested on DRA72-EVM.
The patches are boot tested on OMAP5-UEVM board.

Keerthy (9):
  mfd: Add DT bindings for tps65917 PMIC
  regulator: palmas: Add tps65917 compatible string
  mfd: palmas: Add tps65917 specific definitions and enums
  mfd: palmas: Add tps65917 support
  regulator: palmas: Shift the reg_info structure definition to the
    header file
  mfd: palmas: shift the palmas_sleep_requestor_info structure
    definition to the header file
  regulator: palmas: Add palmas_pmic_driver_data structure
  regulator: palmas: add driver data and modularize the probe
  regulator: palmas: Add tps65917 PMIC support

 Documentation/devicetree/bindings/mfd/palmas.txt   |    2 +
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    1 +
 drivers/mfd/palmas.c                               |  233 +++--
 drivers/regulator/palmas-regulator.c               | 1010 +++++++++++++++-----
 include/linux/mfd/palmas.h                         |  837 ++++++++++++++++
 5 files changed, 1774 insertions(+), 309 deletions(-)

-- 
1.7.9.5

