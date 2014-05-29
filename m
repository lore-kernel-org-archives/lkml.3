Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaE2HUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:20:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:58358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbaE2HUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:20:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,932,1392192000"; 
   d="scan'208";a="539376601"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH v4 0/3] mfd: Intel SoC Power Management IC
Date: Thu, 29 May 2014 15:19:25 +0800
Message-Id: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com>
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
v3:
- Use regmap-irq and remove lots of duplicate code.
- Remove 2 unused APIs.
- Some other cleanup.
v4:
- Remove all exported APIs which are wrappers of regmap API, export
  the regmap in data structure instead.
- Combine intel_soc_pmic_core.c and intel_soc_pmic_i2c.c
- Clean up include files.
- Remove useless members of struct intel_soc_pmic_config.
- Fix various coding style issues.

Zhu, Lejun (3):
  mfd: intel_soc_pmic: Core driver
  mfd: intel_soc_pmic: Crystal Cove support
  mfd: intel_soc_pmic: Build files

 drivers/mfd/Kconfig                |  12 +++
 drivers/mfd/Makefile               |   3 +
 drivers/mfd/intel_soc_pmic_core.c  | 164 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/intel_soc_pmic_core.h  |  32 ++++++++
 drivers/mfd/intel_soc_pmic_crc.c   | 160 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/intel_soc_pmic.h |  30 +++++++
 6 files changed, 401 insertions(+)
 create mode 100644 drivers/mfd/intel_soc_pmic_core.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.h
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
 create mode 100644 include/linux/mfd/intel_soc_pmic.h

-- 
1.8.3.2

