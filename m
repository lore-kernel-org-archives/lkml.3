Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbaEIUqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:46:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:19657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505AbaEIUq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:46:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1020,1389772800"; 
   d="scan'208";a="537854900"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
        david.e.box@linux.intel.com, jacob.jun.pan@linux.intel.com
Subject: [PATCH v4 2/4] arch: x86: added Quark MBI support
Date: Fri,  9 May 2014 13:44:06 -0700
Message-Id: <1399668248-24199-3-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399668248-24199-1-git-send-email-david.e.box@linux.intel.com>
References: <1399668248-24199-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
References: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

Added all the MBI units below and their associated read/write
opcodes:
 - Host Bridge Arbiter
 - Host Bridge
 - Remote Management Unit
 - Memory Manager & eSRAM
 - SoC Unit

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/include/asm/iosf_mbi.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/iosf_mbi.h b/arch/x86/include/asm/iosf_mbi.h
index 1a91a36..57995f0 100644
--- a/arch/x86/include/asm/iosf_mbi.h
+++ b/arch/x86/include/asm/iosf_mbi.h
@@ -50,6 +50,28 @@
 #define BT_MBI_PCIE_READ	0x00
 #define BT_MBI_PCIE_WRITE	0x01
 
+/* Quark available units */
+#define QRK_MBI_UNIT_HBA	0x00
+#define QRK_MBI_UNIT_HB	0x03
+#define QRK_MBI_UNIT_RMU	0x04
+#define QRK_MBI_UNIT_MM	0x05
+#define QRK_MBI_UNIT_MMESRAM	0x05
+#define QRK_MBI_UNIT_SOC	0x31
+
+/* Quark read/write opcodes */
+#define QRK_MBI_HBA_READ	0x10
+#define QRK_MBI_HBA_WRITE	0x11
+#define QRK_MBI_HB_READ	0x10
+#define QRK_MBI_HB_WRITE	0x11
+#define QRK_MBI_RMU_READ	0x10
+#define QRK_MBI_RMU_WRITE	0x11
+#define QRK_MBI_MM_READ	0x10
+#define QRK_MBI_MM_WRITE	0x11
+#define QRK_MBI_MMESRAM_READ	0x12
+#define QRK_MBI_MMESRAM_WRITE	0x13
+#define QRK_MBI_SOC_READ	0x06
+#define QRK_MBI_SOC_WRITE	0x07
+
 #if IS_ENABLED(CONFIG_IOSF_MBI)
 
 bool iosf_mbi_available(void);
-- 
1.7.10.4

