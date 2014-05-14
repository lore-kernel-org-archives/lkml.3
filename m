Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaEOHO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:14:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:53114 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbaEOHOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:14:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="540766126"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, bin.yang@intel.com,
        lejun.zhu@linux.intel.com
Subject: [PATCH 4/4] mfd: intel_soc_pmic: Build files
Date: Wed, 14 May 2014 22:59:38 +0800
Message-Id: <1400079578-32329-5-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices based on Intel SoC products such as Baytrail have a Power
Management IC. This patch adds Intel SoC PMIC support to the build files.

Signed-off-by: Yang, Bin <bin.yang@intel.com>
Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
---
 drivers/mfd/Kconfig  | 10 ++++++++++
 drivers/mfd/Makefile |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3383412..075572f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -241,6 +241,16 @@ config LPC_SCH
 	  LPC bridge function of the Intel SCH provides support for
 	  System Management Bus and General Purpose I/O.
 
+config INTEL_SOC_PMIC
+	bool "Support for Intel Atom SoC PMIC"
+	depends on I2C=y
+	select MFD_CORE
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

