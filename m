Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbaIRI2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:28:16 -0400
Received: from ozlabs.org ([103.22.144.67]:37151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074AbaIRI13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:27:29 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 14/15] cxl: Add driver to Kbuild and Makefiles
Date: Thu, 18 Sep 2014 18:26:59 +1000
Message-Id: <1411028820-29933-15-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411028820-29933-1-git-send-email-mikey@neuling.org>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 drivers/misc/cxl/Kconfig  | 18 ++++++++++++++++++
 drivers/misc/cxl/Makefile |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/misc/cxl/Kconfig b/drivers/misc/cxl/Kconfig
index 48533e1..d413e90 100644
--- a/drivers/misc/cxl/Kconfig
+++ b/drivers/misc/cxl/Kconfig
@@ -5,3 +5,21 @@
 config CXL_BASE
 	bool
 	default n
+
+config CXL
+	tristate "Support for IBM Coherent Accelerators (CXL)"
+	depends on PPC_POWERNV && PCI_MSI
+	select CXL_BASE
+	default m
+	help
+	  Select this option to enable userspace driver support for IBM
+	  Coherent Accelerators (CXL).  CXL is otherwise known as Coherent
+	  Accelerator Processor Interface (CAPI).
+
+config CXL_PCI
+	tristate "Support for CXL devices via PCI"
+	depends on CXL && PPC_POWERNV
+	default y
+	help
+	  Select this option to support CXL devices detected via PCI, e.g.
+	  when running under powernv/OPAL.
diff --git a/drivers/misc/cxl/Makefile b/drivers/misc/cxl/Makefile
index e30ad0a..96f292b 100644
--- a/drivers/misc/cxl/Makefile
+++ b/drivers/misc/cxl/Makefile
@@ -1 +1,4 @@
+cxl-y				+= main.o file.o irq.o fault.o native.o context.o sysfs.o debugfs.o
+obj-$(CONFIG_CXL)		+= cxl.o
+obj-$(CONFIG_CXL_PCI)		+= cxl-pci.o
 obj-$(CONFIG_CXL_BASE)		+= base.o
-- 
1.9.1

