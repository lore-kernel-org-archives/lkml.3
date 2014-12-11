Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbaLKPyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:54:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:55475 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117AbaLKPyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:54:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,558,1413270000"; 
   d="scan'208";a="622248248"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/4] mfd: intel/lpc/ich: move driver to dedicated folder
Date: Thu, 11 Dec 2014 17:53:55 +0200
Message-Id: <1418313236-10764-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the lpc_ich.c module to the dedicated folder. While here, remove the FSF
address since it's subject to change from time to time.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-ich.c                      |  2 +-
 drivers/mfd/Kconfig                          | 10 ----------
 drivers/mfd/Makefile                         |  1 -
 drivers/mfd/intel/lpc/Kconfig                | 10 ++++++++++
 drivers/mfd/intel/lpc/Makefile               |  1 +
 drivers/mfd/{lpc_ich.c => intel/lpc/ich.c}   | 10 +++-------
 drivers/watchdog/iTCO_wdt.c                  |  2 +-
 include/linux/mfd/{lpc_ich.h => intel/ich.h} |  6 +-----
 8 files changed, 17 insertions(+), 25 deletions(-)
 rename drivers/mfd/{lpc_ich.c => intel/lpc/ich.c} (98%)
 rename include/linux/mfd/{lpc_ich.h => intel/ich.h} (81%)

diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
index 7818cd1..0e8532e 100644
--- a/drivers/gpio/gpio-ich.c
+++ b/drivers/gpio/gpio-ich.c
@@ -24,7 +24,7 @@
 #include <linux/pci.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/lpc_ich.h>
+#include <linux/mfd/intel/ich.h>
 
 #define DRV_NAME "gpio_ich"
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e78450f..c8dd9bf 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -271,16 +271,6 @@ config HTC_I2CPLD
 	  This device provides input and output GPIOs through an I2C
 	  interface to one or more sub-chips.
 
-config LPC_ICH
-	tristate "Intel ICH LPC"
-	depends on PCI
-	select MFD_CORE
-	help
-	  The LPC bridge function of the Intel ICH provides support for
-	  many functional units. This driver provides needed support for
-	  other drivers to control these functions, currently GPIO and
-	  watchdog.
-
 config INTEL_SOC_PMIC
 	bool "Support for Intel Atom SoC PMIC"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index fa2fa72..63f43ec 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -138,7 +138,6 @@ obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_MFD_KEMPLD)	+= kempld-core.o
-obj-$(CONFIG_LPC_ICH)		+= lpc_ich.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
 obj-$(CONFIG_MFD_JZ4740_ADC)	+= jz4740-adc.o
diff --git a/drivers/mfd/intel/lpc/Kconfig b/drivers/mfd/intel/lpc/Kconfig
index f131f96..0949f4a 100644
--- a/drivers/mfd/intel/lpc/Kconfig
+++ b/drivers/mfd/intel/lpc/Kconfig
@@ -5,3 +5,13 @@ config LPC_SCH
 	help
 	  LPC bridge function of the Intel SCH provides support for
 	  System Management Bus and General Purpose I/O.
+
+config LPC_ICH
+	tristate "Intel ICH LPC"
+	depends on PCI
+	select MFD_CORE
+	help
+	  The LPC bridge function of the Intel ICH provides support for
+	  many functional units. This driver provides needed support for
+	  other drivers to control these functions, currently GPIO and
+	  watchdog.
diff --git a/drivers/mfd/intel/lpc/Makefile b/drivers/mfd/intel/lpc/Makefile
index 7503137..710cd7d 100644
--- a/drivers/mfd/intel/lpc/Makefile
+++ b/drivers/mfd/intel/lpc/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_LPC_SCH)		+= sch.o
+obj-$(CONFIG_LPC_ICH)		+= ich.o
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/intel/lpc/ich.c
similarity index 98%
rename from drivers/mfd/lpc_ich.c
rename to drivers/mfd/intel/lpc/ich.c
index f35d428..2b47dbc 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/intel/lpc/ich.c
@@ -1,12 +1,12 @@
 /*
- *  lpc_ich.c - LPC interface for Intel ICH
+ *  ich.c - LPC interface for Intel ICH
  *
  *  LPC bridge function of the Intel ICH contains many other
  *  functional units, such as Interrupt controllers, Timers,
  *  Power Management, System Management, GPIO, RTC, and LPC
  *  Configuration Registers.
  *
- *  This driver is derived from lpc_sch.
+ *  This driver is derived from sch.
 
  *  Copyright (c) 2011 Extreme Engineering Solution, Inc.
  *  Author: Aaron Sierra <asierra@xes-inc.com>
@@ -20,10 +20,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
  *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; see the file COPYING.  If not, write to
- *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  *  This driver supports the following I/O Controller hubs:
  *	(See the intel documentation on http://developer.intel.com.)
  *	document number 290655-003, 290677-014: 82801AA (ICH), 82801AB (ICHO)
@@ -65,7 +61,7 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/lpc_ich.h>
+#include <linux/mfd/intel/ich.h>
 
 #define ACPIBASE		0x40
 #define ACPIBASE_GPE_OFF	0x28
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 05ee0bf..250843b 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -66,7 +66,7 @@
 #include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
 #include <linux/io.h>			/* For inb/outb/... */
 #include <linux/mfd/core.h>
-#include <linux/mfd/lpc_ich.h>
+#include <linux/mfd/intel/ich.h>
 
 #include "iTCO_vendor.h"
 
diff --git a/include/linux/mfd/lpc_ich.h b/include/linux/mfd/intel/ich.h
similarity index 81%
rename from include/linux/mfd/lpc_ich.h
rename to include/linux/mfd/intel/ich.h
index 8feac78..0d09695 100644
--- a/include/linux/mfd/lpc_ich.h
+++ b/include/linux/mfd/intel/ich.h
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/mfd/lpc_ich.h
+ *  linux/drivers/mfd/intel/ich.h
  *
  *  Copyright (c) 2012 Extreme Engineering Solution, Inc.
  *  Author: Aaron Sierra <asierra@xes-inc.com>
@@ -12,10 +12,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; see the file COPYING.  If not, write to
- *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #ifndef LPC_ICH_H
 #define LPC_ICH_H
-- 
2.1.3

