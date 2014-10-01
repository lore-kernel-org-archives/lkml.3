Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaJAR5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:57:23 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:37992 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaJAR5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:57:22 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Borislav Petkov <bp@suse.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [PATCH] cmpxchg: Discard unnecessary cast to volatile
Date: Wed,  1 Oct 2014 13:57:27 -0400
Message-Id: <1412186248-18672-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generating a volatile pointer is really not necessary here. This is the only
location where a volatile pointer is being generated for use in asm.

This commit removes the unnecessary volatile pointer being created.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/x86/include/asm/cmpxchg.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 99c105d7..f0baea8 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -90,36 +90,32 @@ extern void __add_wrong_size(void)
 	switch (size) {							\
 	case __X86_CASE_B:						\
 	{								\
-		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
 		asm volatile(lock "cmpxchgb %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "=a" (__ret), "+m" (*ptr)		\
 			     : "q" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	}								\
 	case __X86_CASE_W:						\
 	{								\
-		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
 		asm volatile(lock "cmpxchgw %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "=a" (__ret), "+m" (*ptr)		\
 			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	}								\
 	case __X86_CASE_L:						\
 	{								\
-		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
 		asm volatile(lock "cmpxchgl %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "=a" (__ret), "+m" (*ptr)		\
 			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	}								\
 	case __X86_CASE_Q:						\
 	{								\
-		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
 		asm volatile(lock "cmpxchgq %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "=a" (__ret), "+m" (*ptr)		\
 			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
-- 
1.9.1

