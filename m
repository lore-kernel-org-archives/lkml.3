Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3A0Kdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:33:44 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:59661 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3A0Kdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:33:35 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-cris-kernel@axis.com
Subject: [PATCH v2 4/9] cris: Provide dma_mmap_coherent() and dma_get_sgtable()
Date: Sun, 27 Jan 2013 11:33:23 +0100
Message-Id: <1359282808-31398-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
References: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cris/allmodconfig:

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’

For architectures using dma_map_ops, dma_mmap_coherent() and
dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.

Cris does not use dma_map_ops, hence it should implement them as inline
stubs using dma_common_mmap() and dma_common_get_sgtable().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-cris-kernel@axis.com
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
v2: No changes
---
 arch/cris/include/asm/dma-mapping.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/cris/include/asm/dma-mapping.h b/arch/cris/include/asm/dma-mapping.h
index 8588b2c..2f0f654 100644
--- a/arch/cris/include/asm/dma-mapping.h
+++ b/arch/cris/include/asm/dma-mapping.h
@@ -158,5 +158,15 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 {
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
 
 #endif
-- 
1.7.0.4

