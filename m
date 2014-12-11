Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbaLKP4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:56:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:62349 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240AbaLKP4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:56:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,558,1413270000"; 
   d="scan'208";a="646116068"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/4] mfd: intel/lpc/sch: move driver to dedicated folder
Date: Thu, 11 Dec 2014 17:53:54 +0200
Message-Id: <1418313236-10764-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the lpc_sch.c module to the dedicated folder.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/mfd/Kconfig                        | 8 --------
 drivers/mfd/Makefile                       | 1 -
 drivers/mfd/intel/Kconfig                  | 2 ++
 drivers/mfd/intel/Makefile                 | 1 +
 drivers/mfd/intel/lpc/Kconfig              | 7 +++++++
 drivers/mfd/intel/lpc/Makefile             | 1 +
 drivers/mfd/{lpc_sch.c => intel/lpc/sch.c} | 2 +-
 7 files changed, 12 insertions(+), 10 deletions(-)
 create mode 100644 drivers/mfd/intel/lpc/Kconfig
 create mode 100644 drivers/mfd/intel/lpc/Makefile
 rename drivers/mfd/{lpc_sch.c => intel/lpc/sch.c} (99%)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 729e9cd..e78450f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -281,14 +281,6 @@ config LPC_ICH
 	  other drivers to control these functions, currently GPIO and
 	  watchdog.
 
-config LPC_SCH
-	tristate "Intel SCH LPC"
-	depends on PCI
-	select MFD_CORE
-	help
-	  LPC bridge function of the Intel SCH provides support for
-	  System Management Bus and General Purpose I/O.
-
 config INTEL_SOC_PMIC
 	bool "Support for Intel Atom SoC PMIC"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 11e1945e..fa2fa72 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -138,7 +138,6 @@ obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_MFD_KEMPLD)	+= kempld-core.o
-obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
 obj-$(CONFIG_LPC_ICH)		+= lpc_ich.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
diff --git a/drivers/mfd/intel/Kconfig b/drivers/mfd/intel/Kconfig
index 9e376b0..5d2341f 100644
--- a/drivers/mfd/intel/Kconfig
+++ b/drivers/mfd/intel/Kconfig
@@ -3,3 +3,5 @@
 #
 
 source "drivers/mfd/intel/mid/Kconfig"
+
+source "drivers/mfd/intel/lpc/Kconfig"
diff --git a/drivers/mfd/intel/Makefile b/drivers/mfd/intel/Makefile
index 8d6b43b..8264a26 100644
--- a/drivers/mfd/intel/Makefile
+++ b/drivers/mfd/intel/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-y	+= mid/
+obj-y	+= lpc/
diff --git a/drivers/mfd/intel/lpc/Kconfig b/drivers/mfd/intel/lpc/Kconfig
new file mode 100644
index 0000000..f131f96
--- /dev/null
+++ b/drivers/mfd/intel/lpc/Kconfig
@@ -0,0 +1,7 @@
+config LPC_SCH
+	tristate "Intel SCH LPC"
+	depends on PCI
+	select MFD_CORE
+	help
+	  LPC bridge function of the Intel SCH provides support for
+	  System Management Bus and General Purpose I/O.
diff --git a/drivers/mfd/intel/lpc/Makefile b/drivers/mfd/intel/lpc/Makefile
new file mode 100644
index 0000000..7503137
--- /dev/null
+++ b/drivers/mfd/intel/lpc/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_LPC_SCH)		+= sch.o
diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/intel/lpc/sch.c
similarity index 99%
rename from drivers/mfd/lpc_sch.c
rename to drivers/mfd/intel/lpc/sch.c
index 5c38df3..1829959 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/intel/lpc/sch.c
@@ -1,5 +1,5 @@
 /*
- *  lpc_sch.c - LPC interface for Intel Poulsbo SCH
+ *  sch.c - LPC interface for Intel Poulsbo SCH
  *
  *  LPC bridge function of the Intel SCH contains many other
  *  functional units, such as Interrupt controllers, Timers,
-- 
2.1.3

