Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaEQMXC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 08:23:02 -0400
Received: from ar-005-i185.relay.mailchannels.net ([162.253.144.7]:11527 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932389AbaEQMW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 08:22:59 -0400
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
From: Eli Billauer <eli.billauer@gmail.com>
To: tj@kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 3/3] dma-mapping: pci: Add devm_ interface for pci_map_single
Date: Sat, 17 May 2014 15:22:25 +0300
Message-Id: <1400329345-15556-3-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1400329345-15556-1-git-send-email-eli.billauer@gmail.com>
References: <1400329345-15556-1-git-send-email-eli.billauer@gmail.com>
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

