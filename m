Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaFCF1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:27:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:18281 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbaFCF13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:27:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,962,1392192000"; 
   d="scan'208";a="521819082"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, linus.walleij@linaro.org, broonie@kernel.org
Cc: sameo@linux.intel.com, mika.westerberg@linux.intel.com, gnurou@gmail.com,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH v5 0/3] mfd: Intel SoC Power Management IC
Date: Tue,  3 Jun 2014 13:26:01 +0800
Message-Id: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
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
v5:
- Add comment to describe what is done in _find_gpio_irq().
- Remove i2c id. Only keep ACPI id and match it in _probe().
- Further fix of coding style issues.
- Add the GPIO patch, to merge it along with the MFD changes.

Zhu, Lejun (3):
  mfd: intel_soc_pmic: Core driver
  mfd: intel_soc_pmic: Crystal Cove support
  gpio: Add support for Intel Crystal Cove PMIC

 drivers/gpio/Kconfig               |  13 ++
 drivers/gpio/Makefile              |   1 +
 drivers/gpio/gpio-crystalcove.c    | 379 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |  12 ++
 drivers/mfd/Makefile               |   3 +
 drivers/mfd/intel_soc_pmic_core.c  | 168 ++++++++++++++++
 drivers/mfd/intel_soc_pmic_core.h  |  32 ++++
 drivers/mfd/intel_soc_pmic_crc.c   | 158 ++++++++++++++++
 include/linux/mfd/intel_soc_pmic.h |  30 +++
 9 files changed, 796 insertions(+)
 create mode 100644 drivers/gpio/gpio-crystalcove.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.h
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
 create mode 100644 include/linux/mfd/intel_soc_pmic.h

-- 
1.8.3.2

