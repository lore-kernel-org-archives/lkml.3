Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161066Ab3FGXJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:09:46 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63073 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab3FGXDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:51 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 14/31] mips/kvm: Add thread_info flag to indicate operation in MIPS VZ Guest Mode.
Date: Fri,  7 Jun 2013 16:03:18 -0700
Message-Id: <1370646215-6543-15-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/thread_info.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 895320e..a7a894a 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -109,6 +109,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
+#define TIF_GUESTMODE		19	/* If set, running in VZ Guest mode. */
 #define TIF_FIXADE		20	/* Fix address errors in software */
 #define TIF_LOGADE		21	/* Log address errors to syslog */
 #define TIF_32BIT_REGS		22	/* also implies 16/32 fprs */
@@ -124,6 +125,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
+#define _TIF_GUESTMODE		(1<<TIF_GUESTMODE)
 #define _TIF_FIXADE		(1<<TIF_FIXADE)
 #define _TIF_LOGADE		(1<<TIF_LOGADE)
 #define _TIF_32BIT_REGS		(1<<TIF_32BIT_REGS)
-- 
1.7.11.7

