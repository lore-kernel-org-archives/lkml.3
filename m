Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbaEPIdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:33:23 -0400
Received: from ar-005-i191.relay.mailchannels.net ([162.253.144.73]:46984 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752616AbaEPIdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:33:20 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2014 04:33:19 EDT
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
X-MC-Relay: Neutral
From: Eli Billauer <eli.billauer@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tj@kernel.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 3/5] dma-mapping: pci: Add devm_ interface for pci_map_single
Date: Fri, 16 May 2014 11:26:37 +0300
Message-Id: <1400228799-8832-4-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 Documentation/driver-model/devres.txt |    2 ++
 include/asm-generic/pci-dma-compat.h  |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 13b8be0..09b03c9 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -272,6 +272,8 @@ DMA
 PCI
   pcim_enable_device()	: after success, all PCI ops become managed
   pcim_pin_device()	: keep PCI device enabled after release
+  pcim_map_single()
+  pcim_unmap_single()
 
 IOMAP
   devm_ioport_map()
diff --git a/include/asm-generic/pci-dma-compat.h b/include/asm-generic/pci-dma-compat.h
index 1437b7d..444e598 100644
--- a/include/asm-generic/pci-dma-compat.h
+++ b/include/asm-generic/pci-dma-compat.h
@@ -113,4 +113,21 @@ static inline int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 }
 #endif
 
+/*
+ * Managed DMA API
+ */
+
+static inline dma_addr_t
+pcim_map_single(struct pci_dev *hwdev, void *ptr, size_t size, int direction)
+{
+	return dmam_map_single(hwdev == NULL ? NULL : &hwdev->dev, ptr, size, (enum dma_data_direction)direction);
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

