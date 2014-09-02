Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaIBLfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:35:10 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:7789 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbaIBLfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:35:07 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH] sparc32, leon: Make leom_dma_ops avaiable when !CONFIG_PCI
Date: Tue,  2 Sep 2014 13:34:15 +0200
Message-Id: <1409657655-17846-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The leon_dma_ops struct is needed for leon regardless of PCI configuration.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 arch/sparc/include/asm/dma-mapping.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 1ee0271..5b1b52a 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -20,10 +20,12 @@ extern struct bus_type pci_bus_type;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-#if defined(CONFIG_SPARC32) && defined(CONFIG_PCI)
+#ifdef CONFIG_SPARC_LEON
 	if (sparc_cpu_model == sparc_leon)
 		return leon_dma_ops;
-	else if (dev->bus == &pci_bus_type)
+#endif
+#if defined(CONFIG_SPARC32) && defined(CONFIG_PCI)
+	if (dev->bus == &pci_bus_type)
 		return &pci32_dma_ops;
 #endif
 	return dma_ops;
-- 
1.7.10.4

