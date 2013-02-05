Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3BEPCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:02:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab3BEPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:02:45 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dma-mapping: Fix non-MMU builds
Date: Tue,  5 Feb 2013 16:02:25 +0100
Message-Id: <1360076545-1943-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:XY91g/2Bt15DD4jv9lLtwOg3OtEyPVm2tyrkYEr8sWl
 N9UCqyKjBXMxpg2iLHmQ1lglHs+Od7+VzknwDWpt/x9ppF9S8a
 1UaxeocC0Fdk2dKnIOLOAguMXZNRwKdNwrRFfVlYCeqZju1lDn
 aCUrYIKp0FfvEkTSljo2dUTFkvm8dBWgJdH35zTNhHF4b1AoWm
 h/oCaHet+TQZsbEdO9ka9mDpYkEZUR0K5I2zQLuvvX0jVF1sLL
 jzlVCalrSJoBnBbzixyXixPGq9CTnXvbYG4Bm0vEEbz1Wu0Ex1
 3CcLGOgeOh7KqTzPjCgsOU82q8Q0AayCflkuUEKqdOqjdtyJ4c
 f/EhBdoOfWqu1/tbLsxsyiKMrQRW3SgPbSrXs83yQUs40vjKtG
 EJJvLUbxJebWLyu0xylVrsdEgN/GNVBf1RTSOYGSBOymNlZAKc
 i14H8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8cdf82d (ARM: dma-mapping: add support for CMA regions placed in
highmem zone) changed the signature of the__alloc_from_contiguous() and
__free_from_contiguous() functions but forgot to update the dummy macro
equivalents for non-MMU.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/mm/dma-mapping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index a064e9d..2163af4 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -610,9 +610,9 @@ static inline pgprot_t __get_dma_pgprot(struct dma_attrs *attrs, pgprot_t prot)
 #define __get_dma_pgprot(attrs, prot)	__pgprot(0)
 #define __alloc_remap_buffer(dev, size, gfp, prot, ret, c)	NULL
 #define __alloc_from_pool(size, ret_page)			NULL
-#define __alloc_from_contiguous(dev, size, prot, ret)		NULL
+#define __alloc_from_contiguous(dev, size, prot, ret, c)	NULL
 #define __free_from_pool(cpu_addr, size)			0
-#define __free_from_contiguous(dev, page, size)			do { } while (0)
+#define __free_from_contiguous(dev, page, cpu_addr, size)	do { } while (0)
 #define __dma_free_remap(cpu_addr, size)			do { } while (0)
 
 #endif	/* CONFIG_MMU */
-- 
1.8.1.2

