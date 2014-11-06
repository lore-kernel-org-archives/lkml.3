Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaKFRrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:47:08 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56079 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaKFRrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:47:03 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: namit@cs.technion.ac.il
Subject: [PATCH] KVM: x86: save a bit in the decoding flags
Date: Thu,  6 Nov 2014 18:46:51 +0100
Message-Id: <1415296011-15062-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AVX instructions are just tweaks of the operand length and the alignment
restrictions of SSE instructions, and in fact the Avx bit is just a
duplicate of Unaligned.  Drop it.

Suggested-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9cc476f..87c9431 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -157,7 +157,7 @@
 #define Mmx         ((u64)1 << 40)  /* MMX Vector instruction */
 #define Aligned     ((u64)1 << 41)  /* Explicitly aligned (e.g. MOVDQA) */
 #define Unaligned   ((u64)1 << 42)  /* Explicitly unaligned (e.g. MOVDQU) */
-#define Avx         ((u64)1 << 43)  /* Advanced Vector Extensions */
+#define No16        ((u64)1 << 43)  /* No 16 bit operand */
 #define Fastop      ((u64)1 << 44)  /* Use opcode::u.fastop */
 #define NoWrite     ((u64)1 << 45)  /* No writeback */
 #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
@@ -167,7 +167,6 @@
 #define NoBigReal   ((u64)1 << 50)  /* No big real mode */
 #define PrivUD      ((u64)1 << 51)  /* #UD instead of #GP on CPL > 0 */
 #define NearBranch  ((u64)1 << 52)  /* Near branches */
-#define No16	    ((u64)1 << 53)  /* No 16 bit operand */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -646,8 +645,6 @@ static bool insn_aligned(struct x86_emulate_ctxt *ctxt, unsigned size)
 		return true;
 	else if (ctxt->d & Unaligned)
 		return false;
-	else if (ctxt->d & Avx)
-		return false;
 	else
 		return true;
 }
-- 
1.7.1

