Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbbANRVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:21:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37788 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbbANRVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:21:46 -0500
From: Vitaly Andrianov <vitalya@ti.com>
To: <linux@arm.linux.org.uk>, <thomas.petazzoni@free-electrons.com>,
        <catalin.marinas@arm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH] ARM: mm: use phys_addr_t in __arm_ioremap functions
Date: Wed, 14 Jan 2015 12:22:34 -0500
Message-ID: <1421256154-18514-1-git-send-email-vitalya@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 32 bit ARM architecture with LPAE extension physical addresses
cannot fit into unsigned long variable.

This patch fixes the ioremap_page, __map_ioremap_pfn_caller,
__arm_ioremap and __arm_ioremap_exec functions.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Acked-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/include/asm/mach/map.h | 2 +-
 arch/arm/mm/ioremap.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index 2fe141f..836f006 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -52,7 +52,7 @@ extern const struct mem_type *get_mem_type(unsigned int type);
 /*
  * external interface to remap single page with appropriate type
  */
-extern int ioremap_page(unsigned long virt, unsigned long phys,
+extern int ioremap_page(unsigned long virt, phys_addr_t phys,
 			const struct mem_type *mtype);
 #else
 #define iotable_init(map,num)	do { } while (0)
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index f123d6e..e0fe50f 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -103,7 +103,7 @@ void __init add_static_vm_early(struct static_vm *svm)
 	list_add_tail(&svm->list, &curr_svm->list);
 }
 
-int ioremap_page(unsigned long virt, unsigned long phys,
+int ioremap_page(unsigned long virt, phys_addr_t phys,
 		 const struct mem_type *mtype)
 {
 	return ioremap_page_range(virt, virt + PAGE_SIZE, phys,
-- 
1.9.1

