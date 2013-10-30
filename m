Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3J3Q1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:27:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab3J3Q1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:33 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        Bjorn Helgaas <bhelgaas@google.com> (supporter:PCI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list),
        linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
Subject: [PATCH 01/12] sb_edac: move PCI IDs to pci_ids.h
Date: Wed, 30 Oct 2013 12:26:55 -0400
Message-Id: <1383150426-24730-2-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comment, it should be done before submitting upstream.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c  |   21 ++-------------------
 include/linux/pci_ids.h |   11 +++++++++++
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index e04462b..4cdd948 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -57,26 +57,9 @@ static int probed;
  */
 
 /*
- * FIXME: For now, let's order by device function, as it makes
- * easier for driver's development process. This table should be
- * moved to pci_id.h when submitted upstream
+ * Currently, unused, but will be needed in the future
+ * implementations, as they hold the error counters
  */
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
 #define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR0	0x3c72	/* 16.2 */
 #define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR1	0x3c73	/* 16.3 */
 #define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR2	0x3c76	/* 16.6 */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 97fbecd..d7d4757 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2812,7 +2812,18 @@
 #define PCI_DEVICE_ID_INTEL_UNC_R2PCIE	0x3c43
 #define PCI_DEVICE_ID_INTEL_UNC_R3QPI0	0x3c44
 #define PCI_DEVICE_ID_INTEL_UNC_R3QPI1	0x3c45
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_RAS	0x3c71
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_HA0	0x3ca0
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA	0x3ca8
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD0	0x3caa
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD1	0x3cab
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD2	0x3cac
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD3	0x3cad
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_DDRIO	0x3cb8
 #define PCI_DEVICE_ID_INTEL_JAKETOWN_UBOX	0x3ce0
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD0	0x3cf4
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_BR		0x3cf5
+#define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD1	0x3cf6
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
 #define PCI_DEVICE_ID_INTEL_5100_19	0x65f3
-- 
1.7.1

