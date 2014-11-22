Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaKVUzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 15:55:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaKVUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 15:55:49 -0500
Date: Sat, 22 Nov 2014 12:54:27 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-9f7789f845cc100dd0d94fa1aa083e3373dc03db@git.kernel.org>
Cc: dave@sr71.net, mingo@kernel.org, dave.hansen@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com
Reply-To: dave@sr71.net, mingo@kernel.org, dave.hansen@linux.intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <20141122163711.0F037EE6@viggo.jf.intel.com>
References: <20141122163711.0F037EE6@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] asm-generic: Remove asm-generic arch_bprm_mm_init()
Git-Commit-ID: 9f7789f845cc100dd0d94fa1aa083e3373dc03db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f7789f845cc100dd0d94fa1aa083e3373dc03db
Gitweb:     http://git.kernel.org/tip/9f7789f845cc100dd0d94fa1aa083e3373dc03db
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Sat, 22 Nov 2014 08:37:11 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 22 Nov 2014 21:52:08 +0100

asm-generic: Remove asm-generic arch_bprm_mm_init()

This is a follow-on to commit 62e88b1c00de 'mm: Make
arch_unmap()/bprm_mm_init() available to all architectures'

I removed the asm-generic version of arch_unmap() in that patch,
but missed arch_bprm_mm_init().  So this broke the build for
architectures using asm-generic/mmu_context.h who actually have
an MMU.

Fixes: 62e88b1c00de 'mm: Make arch_unmap()/bprm_mm_init() available to all architectures'
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141122163711.0F037EE6@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/asm-generic/mmu_context.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/asm-generic/mmu_context.h b/include/asm-generic/mmu_context.h
index 1f2a8f9..a7eec91 100644
--- a/include/asm-generic/mmu_context.h
+++ b/include/asm-generic/mmu_context.h
@@ -42,9 +42,4 @@ static inline void activate_mm(struct mm_struct *prev_mm,
 {
 }
 
-static inline void arch_bprm_mm_init(struct mm_struct *mm,
-			struct vm_area_struct *vma)
-{
-}
-
 #endif /* __ASM_GENERIC_MMU_CONTEXT_H */
