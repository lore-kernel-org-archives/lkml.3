Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3AOIM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:12:56 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:1183
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758Ab3AOIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:12:53 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz9371Ic89bhzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
From: "Jiang, Scott" <Scott.Jiang@analog.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Tue, 15 Jan 2013 03:12:41 -0500
Subject: RE: [uclinux-dist-devel] [PATCH 2/9] blackfin: Provide
	dma_mmap_coherent() and dma_get_sgtable()
Thread-Topic: [uclinux-dist-devel] [PATCH 2/9] blackfin: Provide
	dma_mmap_coherent() and dma_get_sgtable()
Thread-Index: Ac3xey1a7+C438N+SNC1CMGeg+7etwBfEgwg
Message-ID: <E43657A3F2E26048BB0EBCA7C4CB6941DD86B7AE3D@NWD2CMBX1.ad.analog.com>
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
 <1358073890-3610-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1358073890-3610-2-git-send-email-geert@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0F8Cu5G006815


From: uclinux-dist-devel-bounces@blackfin.uclinux.org [mailto:uclinux-dist-devel-bounces@blackfin.uclinux.org] On Behalf Of Geert Uytterhoeven
Sent: Sunday, January 13, 2013 6:45 PM
To: linux-arch@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org; Geert Uytterhoeven; linux-kernel@vger.kernel.org; Marek Szyprowski
Subject: [uclinux-dist-devel] [PATCH 2/9] blackfin: Provide dma_mmap_coherent() and dma_get_sgtable()

blackfin/allmodconfig:

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function â€˜vb2_dc_mmapâ€™:
drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function â€˜dma_mmap_coherentâ€™
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function â€˜vb2_dc_get_base_sgtâ€™:
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function â€˜dma_get_sgtableâ€™

For architectures using dma_map_ops, dma_mmap_coherent() and
dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.

Blackfin does not use dma_map_ops, hence it should implement them as inline stubs using dma_common_mmap() and dma_common_get_sgtable().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>

---
 arch/blackfin/include/asm/dma-mapping.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index bbf4610..054d9ec 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -154,4 +154,14 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
        _dma_sync((dma_addr_t)vaddr, size, dir);  }

+/* drivers/base/dma-mapping.c */
+extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
+                          void *cpu_addr, dma_addr_t dma_addr, size_t size); extern int
+dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
+                                 void *cpu_addr, dma_addr_t dma_addr,
+                                 size_t size);
+
+#define dma_mmap_coherent(d, v, c, h, s) dma_common_mmap(d, v, c, h, s)
+#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v,
+h, s)
+
 #endif                         /* _BLACKFIN_DMA_MAPPING_H */
--
1.7.0.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
