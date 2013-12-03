Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3LCO2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:28:48 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:57720 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3LCO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:28:44 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 6/6] GenWQE Enable driver
Date: Tue,  3 Dec 2013 15:28:23 +0100
Message-Id: <1386080903-27160-7-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120314-8372-0000-0000-000007F7046B
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
 drivers/misc/genwqe/Makefile |    7 +++++++
 4 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/genwqe/Kconfig
 create mode 100644 drivers/misc/genwqe/Makefile

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a3e291d..6cb388e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -525,4 +525,5 @@ source "drivers/misc/altera-stapl/Kconfig"
 source "drivers/misc/mei/Kconfig"
 source "drivers/misc/vmw_vmci/Kconfig"
 source "drivers/misc/mic/Kconfig"
+source "drivers/misc/genwqe/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f45473e..99b9424 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
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
index 0000000..98a2b4f
--- /dev/null
+++ b/drivers/misc/genwqe/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for GenWQE driver
+#
+
+obj-$(CONFIG_GENWQE) := genwqe_card.o
+genwqe_card-objs := card_base.o card_dev.o card_ddcb.o card_sysfs.o \
+	card_debugfs.o card_utils.o
-- 
1.7.1

