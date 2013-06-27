Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3F0VxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 17:53:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45259 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3F0VxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 17:53:20 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, ioremap: Correct function name output
Date: Thu, 27 Jun 2013 23:53:16 +0200
Message-Id: <1372369996-20556-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Infact, let the compiler enter the function name so that there are no
discrepancies.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/ioremap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 9a1e6583910c..0215e2c563ef 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -501,15 +501,15 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	}
 
 	if (slot < 0) {
-		printk(KERN_INFO "early_iomap(%08llx, %08lx) not found slot\n",
-			 (u64)phys_addr, size);
+		printk(KERN_INFO "%s(%08llx, %08lx) not found slot\n",
+		       __func__, (u64)phys_addr, size);
 		WARN_ON(1);
 		return NULL;
 	}
 
 	if (early_ioremap_debug) {
-		printk(KERN_INFO "early_ioremap(%08llx, %08lx) [%d] => ",
-		       (u64)phys_addr, size, slot);
+		printk(KERN_INFO "%s(%08llx, %08lx) [%d] => ",
+		       __func__, (u64)phys_addr, size, slot);
 		dump_stack();
 	}
 
-- 
1.8.3

