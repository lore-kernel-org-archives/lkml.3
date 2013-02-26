Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3BZLEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:04:11 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58354 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab3BZLEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:04:08 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/5] metag: Provide dma_get_sgtable()
Date: Tue, 26 Feb 2013 11:03:58 +0000
Message-ID: <1361876642-10247-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
References: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_26_11_04_08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

metag/allmodconfig:

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function 'vb2_dc_get_base_sgt':
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function 'dma_get_sgtable'

For architectures using dma_map_ops, dma_get_sgtable() is provided in
<asm-generic/dma-mapping-common.h>.

Metag does not use dma_map_ops yet, hence it should implement it as an
inline stub using dma_common_get_sgtable().

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/metag/include/asm/dma-mapping.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/metag/include/asm/dma-mapping.h b/arch/metag/include/asm/dma-mapping.h
index b5f80a6..14b23ef 100644
--- a/arch/metag/include/asm/dma-mapping.h
+++ b/arch/metag/include/asm/dma-mapping.h
@@ -180,4 +180,11 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 {
 }
 
+/* drivers/base/dma-mapping.c */
+extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
+				  void *cpu_addr, dma_addr_t dma_addr,
+				  size_t size);
+
+#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
+
 #endif
-- 
1.8.1.2


