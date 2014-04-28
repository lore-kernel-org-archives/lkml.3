Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaD1WF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:05:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:58602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbaD1WFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="502535828"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "David E. Box" <david.e.box@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 4/5] x86/iosf: kconfig and used by other drivers
Date: Mon, 28 Apr 2014 07:04:39 -0700
Message-Id: <1398693880-13428-5-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow Kconfig selection for IOSF driver. Fix warning condition
when MBI interface dummy functions are called at runtime.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/Kconfig                | 2 +-
 arch/x86/include/asm/iosf_mbi.h | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..cda587b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2375,7 +2375,7 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config IOSF_MBI
-	bool
+	bool "Intel OnChip System Fabric mailbox"
 	depends on PCI
 	---help---
 	  To be selected by modules requiring access to the Intel OnChip System
diff --git a/arch/x86/include/asm/iosf_mbi.h b/arch/x86/include/asm/iosf_mbi.h
index 9fc5402..74336f0 100644
--- a/arch/x86/include/asm/iosf_mbi.h
+++ b/arch/x86/include/asm/iosf_mbi.h
@@ -5,7 +5,6 @@
 #ifndef IOSF_MBI_SYMS_H
 #define IOSF_MBI_SYMS_H
 
-#ifdef CONFIG_IOSF_MBI
 
 #define MBI_MCR_OFFSET		0xD0
 #define MBI_MDR_OFFSET		0xD4
@@ -52,6 +51,8 @@
 #define BT_MBI_PCIE_READ	0x00
 #define BT_MBI_PCIE_WRITE	0x01
 
+#ifdef CONFIG_IOSF_MBI
+
 bool iosf_mbi_available(void);
 
 /**
@@ -101,21 +102,21 @@ bool iosf_mbi_available(void)
 static inline
 int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr)
 {
-	WARN();
+	WARN(1, "MBI driver not available");
 	return -EPERM;
 }
 
 static inline
 int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
 {
-	WARN();
+	WARN(1, "MBI driver not available");
 	return -EPERM;
 }
 
 static inline
 int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
 {
-	WARN();
+	WARN(1, "MBI driver not available");
 	return -EPERM;
 }
 #endif /* CONFIG_IOSF_MBI */
-- 
1.8.1.2

