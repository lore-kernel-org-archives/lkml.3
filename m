Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaE0EGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:06:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:9131 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaE0EGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,916,1392192000"; 
   d="scan'208";a="437158833"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH v3 0/4] mfd: Intel SoC Power Management IC
Date: Tue, 27 May 2014 12:06:12 +0800
Message-Id: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices based on Intel SoC products such as Baytrail have a Power Management IC. In the PMIC there are subsystems for voltage regulation, A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called Crystal Cove.

This series contains common code for these PMICs, and device specific support for Crystal Cove.

v2:
- Use regmap instead of creating our own I2C read/write callbacks.
- Add one missing EXPORT_SYMBOL.
- Remove some duplicate code and put them into pmic_regmap_load_from_hw.
v3:
- Use regmap-irq and remove lots of duplicate code.
- Remove 2 unused APIs.
- Some other cleanup.

Zhu, Lejun (4):
  mfd: intel_soc_pmic: Core driver
  mfd: intel_soc_pmic: I2C interface
  mfd: intel_soc_pmic: Crystal Cove support
  mfd: intel_soc_pmic: Build files

 drivers/mfd/Kconfig                |  12 +++
 drivers/mfd/Makefile               |   3 +
 drivers/mfd/intel_soc_pmic_core.c  | 212 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/intel_soc_pmic_core.h  |  44 ++++++++
 drivers/mfd/intel_soc_pmic_crc.c   | 175 ++++++++++++++++++++++++++++++
 drivers/mfd/intel_soc_pmic_i2c.c   | 150 ++++++++++++++++++++++++++
 include/linux/mfd/intel_soc_pmic.h |  27 +++++
 7 files changed, 623 insertions(+)
 create mode 100644 drivers/mfd/intel_soc_pmic_core.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.h
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
 create mode 100644 drivers/mfd/intel_soc_pmic_i2c.c
 create mode 100644 include/linux/mfd/intel_soc_pmic.h

-- 
1.8.3.2

