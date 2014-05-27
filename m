Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaE0EHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:07:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:31198 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbaE0EHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:07:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,916,1392192000"; 
   d="scan'208";a="545297465"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH v3 4/4] mfd: intel_soc_pmic: Build files
Date: Tue, 27 May 2014 12:06:16 +0800
Message-Id: <1401163576-14872-5-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices based on Intel SoC products such as Baytrail have a Power Management IC. This patch adds Intel SoC PMIC support to the build files.

v2:
- Add select REGMAP_I2C.
v3:
- Add select REGMAP_IRQ.

Signed-off-by: Yang, Bin <bin.yang@intel.com>
Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
---
 drivers/mfd/Kconfig  | 12 ++++++++++++
 drivers/mfd/Makefile |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3383412..d987b71 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -241,6 +241,18 @@ config LPC_SCH
 	  LPC bridge function of the Intel SCH provides support for
 	  System Management Bus and General Purpose I/O.
 
+config INTEL_SOC_PMIC
+	bool "Support for Intel Atom SoC PMIC"
+	depends on I2C=y
+	select MFD_CORE
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	help
+	  Select this option to enable support for the PMIC device
+	  on some Intel SoC systems. The PMIC provides ADC, GPIO,
+	  thermal, charger and related power management functions
+	  on these systems.
+
 config MFD_INTEL_MSIC
 	bool "Intel MSIC"
 	depends on INTEL_SCU_IPC
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 2851275..1a18d8b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -166,3 +166,6 @@ obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
+
+intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o intel_soc_pmic_i2c.o
+obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
-- 
1.8.3.2

