Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3AMKq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 05:46:26 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:51173 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab3AMKpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 05:45:03 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-m68k@vger.kernel.org
Subject: [PATCH 6/9] m68k: Provide dma_mmap_coherent() and dma_get_sgtable()
Date: Sun, 13 Jan 2013 11:44:47 +0100
Message-Id: <1358073890-3610-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k/allmodconfig:

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’

For architectures using dma_map_ops, dma_mmap_coherent() and
dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.

M68k does not use dma_map_ops, hence it should implement them as inline
stubs using dma_common_mmap() and dma_common_get_sgtable().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/include/asm/dma-mapping.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/include/asm/dma-mapping.h b/arch/m68k/include/asm/dma-mapping.h
index c68cdb4..05aa535 100644
--- a/arch/m68k/include/asm/dma-mapping.h
+++ b/arch/m68k/include/asm/dma-mapping.h
@@ -110,4 +110,14 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t handle)
 	return 0;
 }
 
+/* drivers/base/dma-mapping.c */
+extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
+			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
+extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
+				  void *cpu_addr, dma_addr_t dma_addr,
+				  size_t size);
+
+#define dma_mmap_coherent(d, v, c, h, s) dma_common_mmap(d, v, c, h, s)
+#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
+
 #endif  /* _M68K_DMA_MAPPING_H */
-- 
1.7.0.4

