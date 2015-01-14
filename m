Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbbANTsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:48:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60370 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbANTsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:48:02 -0500
From: Vitaly Andrianov <vitalya@ti.com>
To: <linux@arm.linux.org.uk>, <thomas.petazzoni@free-electrons.com>,
        <catalin.marinas@arm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH] arm: mm: remove unused ioremap_page()
Date: Wed, 14 Jan 2015 14:48:56 -0500
Message-ID: <1421264936-9495-1-git-send-email-vitalya@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unused ioremap_page().

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/mach/map.h | 5 -----
 arch/arm/mm/ioremap.c           | 8 --------
 2 files changed, 13 deletions(-)

diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index f98c7f3..be2b68e 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -52,11 +52,6 @@ static inline void debug_ll_io_init(void) {}
 
 struct mem_type;
 extern const struct mem_type *get_mem_type(unsigned int type);
-/*
- * external interface to remap single page with appropriate type
- */
-extern int ioremap_page(unsigned long virt, unsigned long phys,
-			const struct mem_type *mtype);
 #else
 #define iotable_init(map,num)	do { } while (0)
 #define vm_reserve_area_early(a,s,c)	do { } while (0)
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index d1e5ad7..c91633f 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -103,14 +103,6 @@ void __init add_static_vm_early(struct static_vm *svm)
 	list_add_tail(&svm->list, &curr_svm->list);
 }
 
-int ioremap_page(unsigned long virt, unsigned long phys,
-		 const struct mem_type *mtype)
-{
-	return ioremap_page_range(virt, virt + PAGE_SIZE, phys,
-				  __pgprot(mtype->prot_pte));
-}
-EXPORT_SYMBOL(ioremap_page);
-
 void __check_vmalloc_seq(struct mm_struct *mm)
 {
 	unsigned int seq;
-- 
1.9.1

