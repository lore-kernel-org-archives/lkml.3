Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaETXj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:39:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:53328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaETXjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,877,1392192000"; 
   d="scan'208";a="542425533"
Message-ID: <537BE7C9.9060508@linux.intel.com>
Date: Wed, 21 May 2014 07:39:53 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [Resend][PATCH 4/4] mfd: intel_soc_pmic: Build files
References: <1400079578-32329-5-git-send-email-lejun.zhu@linux.intel.com>
In-Reply-To: <1400079578-32329-5-git-send-email-lejun.zhu@linux.intel.com>
X-Forwarded-Message-Id: <1400079578-32329-5-git-send-email-lejun.zhu@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
+intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
intel_soc_pmic_i2c.o
+obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
-- 
1.8.3.2


