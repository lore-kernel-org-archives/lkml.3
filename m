Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaEVGjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:39:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:51623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaEVGi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,885,1392192000"; 
   d="scan'208";a="535859869"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH v2 0/4] mfd: Intel SoC Power Management IC
Date: Thu, 22 May 2014 14:38:38 +0800
Message-Id: <1400740722-8320-1-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices based on Intel SoC products such as Baytrail have a Power
Management IC. In the PMIC there are subsystems for voltage regulation,
A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
Crystal Cove.

This series contains common code for these PMICs, and device specific
support for Crystal Cove.

v2:
- Use regmap instead of creating our own I2C read/write callbacks.
- Add one missing EXPORT_SYMBOL.
- Remove some duplicate code and put them into pmic_regmap_load_from_hw.

Zhu, Lejun (4):
  mfd: intel_soc_pmic: Core driver
  mfd: intel_soc_pmic: I2C interface
  mfd: intel_soc_pmic: Crystal Cove support
  mfd: intel_soc_pmic: Build files

 drivers/mfd/Kconfig                |  11 +
 drivers/mfd/Makefile               |   3 +
 drivers/mfd/intel_soc_pmic_core.c  | 521 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/intel_soc_pmic_core.h  |  83 ++++++
 drivers/mfd/intel_soc_pmic_crc.c   | 165 ++++++++++++
 drivers/mfd/intel_soc_pmic_i2c.c   | 148 +++++++++++
 include/linux/mfd/intel_soc_pmic.h |  29 +++
 7 files changed, 960 insertions(+)
 create mode 100644 drivers/mfd/intel_soc_pmic_core.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.h
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
 create mode 100644 drivers/mfd/intel_soc_pmic_i2c.c
 create mode 100644 include/linux/mfd/intel_soc_pmic.h

-- 
1.8.3.2

