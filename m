Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaFAHCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 03:02:12 -0400
Received: from si-002-i32.relay.mailchannels.net ([184.154.112.197]:29417 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751351AbaFAHCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 03:02:09 -0400
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
From: Eli Billauer <eli.billauer@gmail.com>
To: tj@kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, shuah.kh@samsung.com,
        iommu@lists.linux-foundation.org, discuss@x86-64.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH v2 3/4] dma-mapping: pci: Add devm_ interface for pci_map_single
Date: Sun,  1 Jun 2014 10:01:16 +0300
Message-Id: <1401606077-1739-4-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 Documentation/driver-model/devres.txt |    2 ++
 include/asm-generic/pci-dma-compat.h  |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 2112a00..fea2c69 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -274,6 +274,8 @@ DMA
 PCI
   pcim_enable_device()	: after success, all PCI ops become managed
   pcim_pin_device()	: keep PCI device enabled after release
+  pcim_map_single()
+  pcim_unmap_single()
 
 IOMAP
   devm_ioport_map()
diff --git a/include/asm-generic/pci-dma-compat.h b/include/asm-generic/pci-dma-compat.h
index 1437b7d..796a892 100644
--- a/include/asm-generic/pci-dma-compat.h
+++ b/include/asm-generic/pci-dma-compat.h
@@ -113,4 +113,22 @@ static inline int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 }
 #endif
 
+/*
+ * Managed DMA API
+ */
+
+static inline int
+pcim_map_single(struct pci_dev *hwdev, void *ptr, size_t size, int direction,
+		dma_addr_t *ret_dma_handle)
+{
+	return dmam_map_single(hwdev == NULL ? NULL : &hwdev->dev, ptr, size, (enum dma_data_direction)direction, ret_dma_handle);
+}
+
+static inline void
+pcim_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr,
+		 size_t size, int direction)
+{
+	dmam_unmap_single(hwdev == NULL ? NULL : &hwdev->dev, dma_addr, size, (enum dma_data_direction)direction);
+}
+
 #endif
-- 
1.7.2.3

