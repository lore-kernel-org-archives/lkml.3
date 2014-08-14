Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaHNVp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:45:57 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49951 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaHNVpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:45:52 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: [PATCH 1/2] Move Intel SNB device ids from sb_edac to pci_ids.h
Date: Thu, 14 Aug 2014 14:45:40 -0700
Message-Id: <9b0cfe601627a19901d40053daadbaea025a9a70.1408051536.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1408051536.git.luto@amacapital.net>
References: <cover.1408051536.git.luto@amacapital.net>
In-Reply-To: <cover.1408051536.git.luto@amacapital.net>
References: <cover.1408051536.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_imc driver will use two of them, and moving only part of
the list seems messier.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rui Wang <ruiv.wang@gmail.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/edac/sb_edac.c  | 30 ------------------------------
 include/linux/pci_ids.h | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index deea0dc9999b..a2597e9313c6 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -52,36 +52,6 @@ static int probed;
 #define GET_BITFIELD(v, lo, hi)	\
 	(((v) & GENMASK_ULL(hi, lo)) >> (lo))
 
-/*
- * sbridge Memory Controller Registers
- */
-
-/*
- * FIXME: For now, let's order by device function, as it makes
- * easier for driver's development process. This table should be
- * moved to pci_id.h when submitted upstream
- */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD0	0x3cf4	/* 12.6 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD1	0x3cf6	/* 12.7 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_BR		0x3cf5	/* 13.6 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_HA0	0x3ca0	/* 14.0 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA	0x3ca8	/* 15.0 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_RAS	0x3c71	/* 15.1 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD0	0x3caa	/* 15.2 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD1	0x3cab	/* 15.3 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD2	0x3cac	/* 15.4 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD3	0x3cad	/* 15.5 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_DDRIO	0x3cb8	/* 17.0 */
-
-	/*
-	 * Currently, unused, but will be needed in the future
-	 * implementations, as they hold the error counters
-	 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR0	0x3c72	/* 16.2 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR1	0x3c73	/* 16.3 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR2	0x3c76	/* 16.6 */
-#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR3	0x3c77	/* 16.7 */
-
 /* Devices 12 Function 6, Offsets 0x80 to 0xcc */
 static const u32 sbridge_dram_rule[] = {
 	0x80, 0x88, 0x90, 0x98, 0xa0,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 7fa31731c854..e0e6801c3d80 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2816,7 +2816,22 @@
 #define PCI_DEVICE_ID_INTEL_UNC_R2PCIE	0x3c43
 #define PCI_DEVICE_ID_INTEL_UNC_R3QPI0	0x3c44
 #define PCI_DEVICE_ID_INTEL_UNC_R3QPI1	0x3c45
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_RAS	0x3c71	/* 15.1 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR0	0x3c72	/* 16.2 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR1	0x3c73	/* 16.3 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR2	0x3c76	/* 16.6 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR3	0x3c77	/* 16.7 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_HA0	0x3ca0	/* 14.0 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA	0x3ca8	/* 15.0 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD0	0x3caa	/* 15.2 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD1	0x3cab	/* 15.3 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD2	0x3cac	/* 15.4 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD3	0x3cad	/* 15.5 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_DDRIO	0x3cb8	/* 17.0 */
 #define PCI_DEVICE_ID_INTEL_JAKETOWN_UBOX	0x3ce0
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD0	0x3cf4	/* 12.6 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_BR		0x3cf5	/* 13.6 */
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD1	0x3cf6	/* 12.7 */
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
 #define PCI_DEVICE_ID_INTEL_5100_19	0x65f3
-- 
1.9.3

