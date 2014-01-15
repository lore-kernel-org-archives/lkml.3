Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaAOXAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:00:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:17579 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbaAOW7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:59:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,665,1384329600"; 
   d="scan'208";a="465794011"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/5] mei: txe: add Kbuild for TXE device
Date: Thu, 16 Jan 2014 00:58:36 +0200
Message-Id: <1389826716-16956-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389826716-16956-1-git-send-email-tomas.winkler@intel.com>
References: <1389826716-16956-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Kconfig  | 9 +++++++++
 drivers/misc/mei/Makefile | 6 +++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/Kconfig b/drivers/misc/mei/Kconfig
index c76fa31..5881679 100644
--- a/drivers/misc/mei/Kconfig
+++ b/drivers/misc/mei/Kconfig
@@ -34,3 +34,12 @@ config INTEL_MEI_ME
 	  82Q33 Express
 	  82X38/X48 Express
 
+config INTEL_MEI_TXE
+	tristate "Intel Trusted Execution Environment with ME Interface"
+	select INTEL_MEI
+	depends on X86 && PCI
+	help
+	  MEI Support for Trusted Execution Environment device on Intel SoCs
+
+	  Supported SoCs:
+	  Intel Bay Trail
diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 08698a4..8ebc6cd 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -1,6 +1,6 @@
 #
 # Makefile - Intel Management Engine Interface (Intel MEI) Linux driver
-# Copyright (c) 2010-2011, Intel Corporation.
+# Copyright (c) 2010-2014, Intel Corporation.
 #
 obj-$(CONFIG_INTEL_MEI) += mei.o
 mei-objs := init.o
@@ -17,3 +17,7 @@ mei-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_INTEL_MEI_ME) += mei-me.o
 mei-me-objs := pci-me.o
 mei-me-objs += hw-me.o
+
+obj-$(CONFIG_INTEL_MEI_TXE) += mei-txe.o
+mei-txe-objs := pci-txe.o
+mei-txe-objs += hw-txe.o
-- 
1.8.4.2

