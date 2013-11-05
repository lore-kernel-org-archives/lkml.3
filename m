Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3KEIot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:44:49 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:37329 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3KEIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:44:48 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 6/6] GenWQE Enable driver
Date: Tue,  5 Nov 2013 09:44:34 +0100
Message-Id: <1383641074-13710-7-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383641074-13710-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383641074-13710-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110508-3548-0000-0000-0000070C13F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable possiblity to configure and build this driver.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
            Michael Jung <MIJUNG@de.ibm.com>,
            Michael Ruettger <michael@ibmra.de>
---
 drivers/misc/Kconfig         |    1 +
 drivers/misc/Makefile        |    1 +
 drivers/misc/genwqe/Kconfig  |   13 +++++++++++++
 drivers/misc/genwqe/Makefile |    8 ++++++++
 4 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/genwqe/Kconfig
 create mode 100644 drivers/misc/genwqe/Makefile

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8dacd4c..92142cf 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -537,4 +537,5 @@ source "drivers/misc/carma/Kconfig"
 source "drivers/misc/altera-stapl/Kconfig"
 source "drivers/misc/mei/Kconfig"
 source "drivers/misc/vmw_vmci/Kconfig"
+source "drivers/misc/genwqe/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..62a3dfb 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
+obj-$(CONFIG_GENWQE)		+= genwqe/
diff --git a/drivers/misc/genwqe/Kconfig b/drivers/misc/genwqe/Kconfig
new file mode 100644
index 0000000..6069d8c
--- /dev/null
+++ b/drivers/misc/genwqe/Kconfig
@@ -0,0 +1,13 @@
+#
+# IBM Accelerator Family 'GenWQE'
+#
+
+menuconfig GENWQE
+	tristate "GenWQE PCIe Accelerator"
+	depends on PCI && 64BIT
+	select CRC_ITU_T
+	default n
+	help
+	  Enables PCIe card driver for IBM GenWQE accelerators.
+	  The user-space interface is described in
+	  include/linux/genwqe/genwqe_card.h.
diff --git a/drivers/misc/genwqe/Makefile b/drivers/misc/genwqe/Makefile
new file mode 100644
index 0000000..b6af308
--- /dev/null
+++ b/drivers/misc/genwqe/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for GenWQE driver
+#
+
+# card driver
+obj-$(CONFIG_GENWQE) := genwqe_card.o
+genwqe_card-objs := card_base.o card_dev.o card_ddcb.o card_sysfs.o \
+	card_debugfs.o card_utils.o
-- 
1.7.1

