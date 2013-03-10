Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3CJNW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:22:57 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55342 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CJNWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:22:54 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: benh@kernel.crashing.org
Cc: paulus@samba.org, akpm@linux-foundation.org, agraf@suse.de,
        suzuki@in.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH] powerpc: place EXPORT_SYMBOL macro right after declaration
Date: Sun, 10 Mar 2013 15:22:39 +0200
Message-Id: <1362921759-23498-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following checkpatch.pl warnings:

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(kmap_prot);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(kmap_pte);

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 arch/powerpc/mm/mem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index f1f7409..056732e 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -66,10 +66,9 @@ unsigned long long memory_limit;
 
 #ifdef CONFIG_HIGHMEM
 pte_t *kmap_pte;
+EXPORT_SYMBOL(kmap_pte);
 pgprot_t kmap_prot;
-
 EXPORT_SYMBOL(kmap_prot);
-EXPORT_SYMBOL(kmap_pte);
 
 static inline pte_t *virt_to_kpte(unsigned long vaddr)
 {
-- 
1.7.9.5

