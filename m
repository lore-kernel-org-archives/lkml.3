Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3A0KfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:35:13 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:59713 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab3A0Kde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:33:34 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-am33-list@redhat.com
Subject: [PATCH v2 7/9] mn10300: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
Date: Sun, 27 Jan 2013 11:33:26 +0100
Message-Id: <1359282808-31398-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
References: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mn10300/allmodconfig:

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’

For architectures using dma_map_ops, dma_mmap_coherent() and
dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.

Mn10300 does not use dma_map_ops, hence it should implement them itself.
For now, use dummy implementations that just return -EINVAL, until the API
has been finalized.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-am33-list@redhat.com
---
v2: Dummy implementations that just return -EINVAL
---
 arch/mn10300/include/asm/dma-mapping.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
index c1be439..a18abfc 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -168,4 +168,19 @@ void dma_cache_sync(void *vaddr, size_t size,
 	mn10300_dcache_flush_inv();
 }
 
+/* Not supported for now */
+static inline int dma_mmap_coherent(struct device *dev,
+				    struct vm_area_struct *vma, void *cpu_addr,
+				    dma_addr_t dma_addr, size_t size)
+{
+	return -EINVAL;
+}
+
+static inline int dma_get_sgtable(struct device *dev, struct sg_table *sgt,
+				  void *cpu_addr, dma_addr_t dma_addr,
+				  size_t size)
+{
+	return -EINVAL;
+}
+
 #endif
-- 
1.7.0.4

