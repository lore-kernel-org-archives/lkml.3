Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbbADKwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:52:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32892 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbADKwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:52:12 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, copy_user: Remove FIX_ALIGNMENT define
Date: Sun,  4 Jan 2015 11:52:10 +0100
Message-Id: <1420368730-25647-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It is superfluous now so remove it. No object file change before and
after.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/lib/copy_user_64.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index dee945d55594..1530ec2c1b12 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -8,9 +8,6 @@
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
-
-#define FIX_ALIGNMENT 1
-
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
@@ -45,7 +42,6 @@
 	.endm
 
 	.macro ALIGN_DESTINATION
-#ifdef FIX_ALIGNMENT
 	/* check for bad alignment of destination */
 	movl %edi,%ecx
 	andl $7,%ecx
@@ -67,7 +63,6 @@
 
 	_ASM_EXTABLE(100b,103b)
 	_ASM_EXTABLE(101b,103b)
-#endif
 	.endm
 
 /* Standard copy_to_user with segment limit checking */
-- 
2.2.0.33.gc18b867

