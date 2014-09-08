Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaIHHuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:50:04 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:60533 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbaIHHuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:50:02 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2] sparc32, leon: Make leon_dma_ops avaiable when !CONFIG_PCI
Date: Mon,  8 Sep 2014 09:48:52 +0200
Message-Id: <1410162532-25159-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409657655-17846-1-git-send-email-andreas@gaisler.com>
References: <1409657655-17846-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The leon_dma_ops struct is needed for leon regardless of PCI configuration.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
Changes from v1: Fixed typo in commit message

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

