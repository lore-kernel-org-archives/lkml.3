Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaKVQhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 11:37:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:22703 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaKVQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 11:37:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,437,1413270000"; 
   d="scan'208";a="626704702"
Subject: [PATCH] remove asm-generic arch_bprm_mm_init()
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        linux-arch@vger.kernel.org, x86@kernel.org, tglx@linutronix.de
From: Dave Hansen <dave@sr71.net>
Date: Sat, 22 Nov 2014 08:37:11 -0800
Message-Id: <20141122163711.0F037EE6@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This is a follow-on to commit:

https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=x86/mpx&id=62e88b1c00de9cb30d937841ed5debed871070b8

I removed the asm-generic version of arch_unmap() in that patch,
but missed arch_bprm_mm_init().  So this broke the build for
architectures using asm-generic/mmu_context.h who actually have
an MMU.

This has been cross compiled for:
	s390
	arm
	cris
	microblaze

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>

---

 b/include/asm-generic/mmu_context.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/asm-generic/mmu_context.h~remove-generic-arch_bprm_mm_init include/asm-generic/mmu_context.h
--- a/include/asm-generic/mmu_context.h~remove-generic-arch_bprm_mm_init	2014-11-20 14:39:38.191036388 -0800
+++ b/include/asm-generic/mmu_context.h	2014-11-20 14:39:38.194036524 -0800
@@ -42,9 +42,4 @@ static inline void activate_mm(struct mm
 {
 }
 
-static inline void arch_bprm_mm_init(struct mm_struct *mm,
-			struct vm_area_struct *vma)
-{
-}
-
 #endif /* __ASM_GENERIC_MMU_CONTEXT_H */
_
