Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3AaV74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:59:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44507 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab3AaV7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:59:07 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <sboyd@codeaurora.org>, <will.deacon@arm.com>,
        <paulmck@linux.vnet.ibm.com>, <nico@linaro.org>,
        <catalin.marinas@arm.com>, <marc.zyngier@arm.com>,
        <linus.walleij@linaro.org>, Vitaly Andrianov <vitalya@ti.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v4 02/13] ARM: LPAE: use phys_addr_t in alloc_init_pud()
Date: Thu, 31 Jan 2013 16:58:21 -0500
Message-ID: <1359669512-31276-3-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359669512-31276-1-git-send-email-cyril@ti.com>
References: <1359669512-31276-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Andrianov <vitalya@ti.com>

This patch fixes the alloc_init_pud() function to use phys_addr_t instead of
unsigned long when passing in the phys argument.

This is an extension to commit 97092e0c56830457af0639f6bd904537a150ea4a (ARM:
pgtable: use phys_addr_t for physical addresses), which applied similar changes
elsewhere in the ARM memory management code.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 9f06102..ef43689 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -612,7 +612,8 @@ static void __init alloc_init_section(pud_t *pud, unsigned long addr,
 }
 
 static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
-	unsigned long end, unsigned long phys, const struct mem_type *type)
+				  unsigned long end, phys_addr_t phys,
+				  const struct mem_type *type)
 {
 	pud_t *pud = pud_offset(pgd, addr);
 	unsigned long next;
-- 
1.7.9.5

