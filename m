Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaCKWQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:16:00 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63251 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbaCKWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:15:57 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 2/2] x86_32: Remove user bit from identity map PDE
Date: Tue, 11 Mar 2014 15:15:22 -0700
Message-Id: <7e195f444b07eacc67d62ab37919f88940717d40.1394575968.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1394575968.git.luto@amacapital.net>
References: <cover.1394575968.git.luto@amacapital.net>
In-Reply-To: <cover.1394575968.git.luto@amacapital.net>
References: <cover.1394575968.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason that the user bit was set was to support userspace
access to the compat vDSO in the fixmap.  The compat vDSO now lives
in an ordinary vma, so the user bit can be removed.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/pgtable_types.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 1aa9ccd..757f9c4 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -214,13 +214,8 @@
 #ifdef CONFIG_X86_64
 #define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
 #else
-/*
- * For PDE_IDENT_ATTR include USER bit. As the PDE and PTE protection
- * bits are combined, this will alow user to access the high address mapped
- * VDSO in the presence of CONFIG_COMPAT_VDSO
- */
 #define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
-#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
+#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+DIRTY+ACCESSED */
 #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
 #endif
 
-- 
1.8.5.3

