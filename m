Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaJHPqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:46:01 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:60601 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaJHPqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:46:00 -0400
MIME-Version: 1.0
Date: Wed, 8 Oct 2014 23:45:59 +0800
Message-ID: <CAHkaATRt4eNfBbwjMLt4g_c+mZ+NHt=tFWgap-31ZvtwH0VGuQ@mail.gmail.com>
Subject: [PATCH] arm64: Fix data type for physical address
From: Min-Hua Chen <orca.chen@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use phys_addr_t for physical address in alloc_init_pud. Although
phys_addr_t and unsigned long are 64 bit in arm64, it is better
to use phys_addr_t to describe physical addresses.

Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
---
 arch/arm64/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6894ef3..c649ba5 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -202,7 +202,7 @@ static void __init alloc_init_pmd(pud_t *pud,
unsigned long addr,
 }

 static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
-                  unsigned long end, unsigned long phys,
+                  unsigned long end, phys_addr_t phys,
                   int map_io)
 {
     pud_t *pud;
-- 
1.7.10.4
