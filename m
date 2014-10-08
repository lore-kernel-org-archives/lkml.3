Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaJHI7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:59:46 -0400
Received: from ozlabs.org ([103.22.144.67]:45169 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbaJHIzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:55:35 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v4 15/16] cxl: Add driver to Kbuild and Makefiles
Date: Wed,  8 Oct 2014 19:55:04 +1100
Message-Id: <1412758505-23495-16-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412758505-23495-1-git-send-email-mikey@neuling.org>
References: <1412758505-23495-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 drivers/misc/cxl/Kconfig  | 17 +++++++++++++++++
 drivers/misc/cxl/Makefile |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/misc/cxl/Kconfig b/drivers/misc/cxl/Kconfig
index 5cdd319..a990b39 100644
--- a/drivers/misc/cxl/Kconfig
+++ b/drivers/misc/cxl/Kconfig
@@ -6,3 +6,20 @@ config CXL_BASE
 	bool
 	default n
 	select PPC_COPRO_BASE
+
+config CXL
+	tristate "Support for IBM Coherent Accelerators (CXL)"
+	depends on PPC_POWERNV && PCI_MSI
+	select CXL_BASE
+	default m
+	help
+	  Select this option to enable driver support for IBM Coherent
+	  Accelerators (CXL).  CXL is otherwise known as Coherent Accelerator
+	  Processor Interface (CAPI).  CAPI allows accelerators in FPGAs to be
+	  coherently attached to a CPU via an MMU.  This driver enables
+	  userspace programs to access these accelerators via /dev/cxl/afuM.N
+	  devices.
+
+	  CAPI adapters are found in POWER8 based systems.
+
+	  If unsure, say N.
diff --git a/drivers/misc/cxl/Makefile b/drivers/misc/cxl/Makefile
index e30ad0a..165e98f 100644
--- a/drivers/misc/cxl/Makefile
+++ b/drivers/misc/cxl/Makefile
@@ -1 +1,3 @@
+cxl-y				+= main.o file.o irq.o fault.o native.o context.o sysfs.o debugfs.o pci.o
+obj-$(CONFIG_CXL)		+= cxl.o
 obj-$(CONFIG_CXL_BASE)		+= base.o
-- 
1.9.1

