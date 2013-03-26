Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965505Ab3CZPYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:24:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410Ab3CZPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 149/150] signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer
Date: Tue, 26 Mar 2013 15:20:48 +0000
Message-Id: <1364311249-14454-150-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

flush_signal_handlers() needs to know whether sigaction::sa_restorer
is defined, not whether SA_RESTORER is defined.  Define the
__ARCH_HAS_SA_RESTORER macro to indicate this.

Vaguely based on upstream commit 574c4866e33d 'consolidate kernel-side
struct sigaction declarations'.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/signal.h     | 1 +
 arch/avr32/include/asm/signal.h   | 1 +
 arch/cris/include/asm/signal.h    | 1 +
 arch/h8300/include/asm/signal.h   | 1 +
 arch/m32r/include/asm/signal.h    | 1 +
 arch/m68k/include/asm/signal.h    | 1 +
 arch/mn10300/include/asm/signal.h | 1 +
 arch/powerpc/include/asm/signal.h | 1 +
 arch/s390/include/asm/signal.h    | 1 +
 arch/sparc/include/asm/signal.h   | 1 +
 arch/x86/include/asm/signal.h     | 2 ++
 arch/xtensa/include/asm/signal.h  | 1 +
 include/asm-generic/signal.h      | 4 ++++
 13 files changed, 17 insertions(+)

diff --git a/arch/arm/include/asm/signal.h b/arch/arm/include/asm/signal.h
index 43ba0fb..559ee24 100644
--- a/arch/arm/include/asm/signal.h
+++ b/arch/arm/include/asm/signal.h
@@ -127,6 +127,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/avr32/include/asm/signal.h b/arch/avr32/include/asm/signal.h
index ae56849..116a2b4 100644
--- a/arch/avr32/include/asm/signal.h
+++ b/arch/avr32/include/asm/signal.h
@@ -121,6 +121,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/cris/include/asm/signal.h b/arch/cris/include/asm/signal.h
index ea6af9a..057fea2 100644
--- a/arch/cris/include/asm/signal.h
+++ b/arch/cris/include/asm/signal.h
@@ -122,6 +122,7 @@ struct sigaction {
 	void (*sa_restorer)(void);
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/h8300/include/asm/signal.h b/arch/h8300/include/asm/signal.h
index fd8b66e..8695707 100644
--- a/arch/h8300/include/asm/signal.h
+++ b/arch/h8300/include/asm/signal.h
@@ -121,6 +121,7 @@ struct sigaction {
 	void (*sa_restorer)(void);
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/m32r/include/asm/signal.h b/arch/m32r/include/asm/signal.h
index ea5f95e..4d420ad 100644
--- a/arch/m32r/include/asm/signal.h
+++ b/arch/m32r/include/asm/signal.h
@@ -116,6 +116,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
index 93fe83e..a20ae63 100644
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -119,6 +119,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/mn10300/include/asm/signal.h b/arch/mn10300/include/asm/signal.h
index 1865d72..eecaa76 100644
--- a/arch/mn10300/include/asm/signal.h
+++ b/arch/mn10300/include/asm/signal.h
@@ -131,6 +131,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/powerpc/include/asm/signal.h b/arch/powerpc/include/asm/signal.h
index 3eb13be..ec63a0a 100644
--- a/arch/powerpc/include/asm/signal.h
+++ b/arch/powerpc/include/asm/signal.h
@@ -109,6 +109,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/s390/include/asm/signal.h b/arch/s390/include/asm/signal.h
index cdf5cb2..c872626 100644
--- a/arch/s390/include/asm/signal.h
+++ b/arch/s390/include/asm/signal.h
@@ -131,6 +131,7 @@ struct sigaction {
         void (*sa_restorer)(void);
         sigset_t sa_mask;               /* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
         struct sigaction sa;
diff --git a/arch/sparc/include/asm/signal.h b/arch/sparc/include/asm/signal.h
index aa42fe3..d07beb3 100644
--- a/arch/sparc/include/asm/signal.h
+++ b/arch/sparc/include/asm/signal.h
@@ -192,6 +192,7 @@ struct __old_sigaction {
 	unsigned long		sa_flags;
 	void			(*sa_restorer)(void);  /* not used by Linux/SPARC yet */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 typedef struct sigaltstack {
 	void			__user *ss_sp;
diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 598457c..6cbc795 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -125,6 +125,8 @@ typedef unsigned long sigset_t;
 extern void do_notify_resume(struct pt_regs *, void *, __u32);
 # endif /* __KERNEL__ */
 
+#define __ARCH_HAS_SA_RESTORER
+
 #ifdef __i386__
 # ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/xtensa/include/asm/signal.h b/arch/xtensa/include/asm/signal.h
index 7f201b9..696d28a 100644
--- a/arch/xtensa/include/asm/signal.h
+++ b/arch/xtensa/include/asm/signal.h
@@ -126,6 +126,7 @@ struct sigaction {
 	void (*sa_restorer)(void);
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/include/asm-generic/signal.h b/include/asm-generic/signal.h
index 555c0ae..743f7a5 100644
--- a/include/asm-generic/signal.h
+++ b/include/asm-generic/signal.h
@@ -99,6 +99,10 @@ typedef unsigned long old_sigset_t;
 
 #include <asm-generic/signal-defs.h>
 
+#ifdef SA_RESTORER
+#define __ARCH_HAS_SA_RESTORER
+#endif
+
 struct sigaction {
 	__sighandler_t sa_handler;
 	unsigned long sa_flags;
-- 
1.8.1.2

