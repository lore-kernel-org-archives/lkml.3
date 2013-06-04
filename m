Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3FDXZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:25:14 -0400
Received: from 1wt.eu ([62.212.114.60]:35194 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3FDWlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:03 -0400
Message-Id: <20130604172131.219618934@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 022/184] signal: Define __ARCH_HAS_SA_RESTORER so we know
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 whether to clear sa_restorer

From: Ben Hutchings <ben@decadent.org.uk>

Vaguely based on upstream commit 574c4866e33d 'consolidate kernel-side
struct sigaction declarations'.

flush_signal_handlers() needs to know whether sigaction::sa_restorer
is defined, not whether SA_RESTORER is defined.  Define the
__ARCH_HAS_SA_RESTORER macro to indicate this.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
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
index 8790dfc..e6952a0 100644
--- a/arch/avr32/include/asm/signal.h
+++ b/arch/avr32/include/asm/signal.h
@@ -128,6 +128,7 @@ struct sigaction {
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
index 9c1acb2..a96a9f4 100644
--- a/arch/m32r/include/asm/signal.h
+++ b/arch/m32r/include/asm/signal.h
@@ -123,6 +123,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
index 5bc09c7..01a492a 100644
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
index 7e891fc..045d6a2 100644
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
index e49b828..4929431 100644
--- a/arch/sparc/include/asm/signal.h
+++ b/arch/sparc/include/asm/signal.h
@@ -191,6 +191,7 @@ struct __old_sigaction {
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
index 633ba73..75edf8a 100644
--- a/arch/xtensa/include/asm/signal.h
+++ b/arch/xtensa/include/asm/signal.h
@@ -133,6 +133,7 @@ struct sigaction {
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
1.7.12.2.21.g234cd45.dirty



