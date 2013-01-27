Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3A0KeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:34:13 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:38166 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab3A0Kdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:33:38 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH v2 5/9] frv: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
Date: Sun, 27 Jan 2013 11:33:24 +0100
Message-Id: <1359282808-31398-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
References: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frv/allmodconfig:

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’

For architectures using dma_map_ops, dma_mmap_coherent() and
dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.

Frv does not use dma_map_ops, hence it should implement them itself.
For now, use dummy implementations that just return -EINVAL, until the API
has been finalized.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: David Howells <dhowells@redhat.com>
---
v2: Dummy implementations that just return -EINVAL
---
 arch/frv/include/asm/dma-mapping.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index dfb8110..1746a2b 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -132,4 +132,19 @@ void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	flush_write_buffers();
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
 #endif  /* _ASM_DMA_MAPPING_H */
-- 
1.7.0.4

