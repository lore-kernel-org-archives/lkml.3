Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab3DBWdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:33:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3DBWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 01/68] signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer
Date: Tue,  2 Apr 2013 15:12:50 -0700
Message-Id: <20130402221330.090187415@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Vaguely based on upstream commit 574c4866e33d 'consolidate kernel-side
struct sigaction declarations'.

flush_signal_handlers() needs to know whether sigaction::sa_restorer
is defined, not whether SA_RESTORER is defined.  Define the
__ARCH_HAS_SA_RESTORER macro to indicate this.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/signal.h     |    1 +
 arch/avr32/include/asm/signal.h   |    1 +
 arch/cris/include/asm/signal.h    |    1 +
 arch/h8300/include/asm/signal.h   |    1 +
 arch/m32r/include/asm/signal.h    |    1 +
 arch/m68k/include/asm/signal.h    |    1 +
 arch/mn10300/include/asm/signal.h |    1 +
 arch/powerpc/include/asm/signal.h |    1 +
 arch/s390/include/asm/signal.h    |    1 +
 arch/sparc/include/asm/signal.h   |    1 +
 arch/x86/include/asm/signal.h     |    2 ++
 arch/xtensa/include/asm/signal.h  |    1 +
 include/asm-generic/signal.h      |    4 ++++
 13 files changed, 17 insertions(+)

--- a/arch/arm/include/asm/signal.h
+++ b/arch/arm/include/asm/signal.h
@@ -127,6 +127,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
--- a/arch/avr32/include/asm/signal.h
+++ b/arch/avr32/include/asm/signal.h
@@ -128,6 +128,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
--- a/arch/cris/include/asm/signal.h
+++ b/arch/cris/include/asm/signal.h
@@ -122,6 +122,7 @@ struct sigaction {
 	void (*sa_restorer)(void);
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
--- a/arch/h8300/include/asm/signal.h
+++ b/arch/h8300/include/asm/signal.h
@@ -121,6 +121,7 @@ struct sigaction {
 	void (*sa_restorer)(void);
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
--- a/arch/m32r/include/asm/signal.h
+++ b/arch/m32r/include/asm/signal.h
@@ -123,6 +123,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -119,6 +119,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
--- a/arch/mn10300/include/asm/signal.h
+++ b/arch/mn10300/include/asm/signal.h
@@ -131,6 +131,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
--- a/arch/powerpc/include/asm/signal.h
+++ b/arch/powerpc/include/asm/signal.h
@@ -109,6 +109,7 @@ struct sigaction {
 	__sigrestore_t sa_restorer;
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
--- a/arch/s390/include/asm/signal.h
+++ b/arch/s390/include/asm/signal.h
@@ -131,6 +131,7 @@ struct sigaction {
         void (*sa_restorer)(void);
         sigset_t sa_mask;               /* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
         struct sigaction sa;
--- a/arch/sparc/include/asm/signal.h
+++ b/arch/sparc/include/asm/signal.h
@@ -192,6 +192,7 @@ struct __old_sigaction {
 	unsigned long		sa_flags;
 	void			(*sa_restorer)(void);  /* not used by Linux/SPARC yet */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 typedef struct sigaltstack {
 	void			__user *ss_sp;
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
--- a/arch/xtensa/include/asm/signal.h
+++ b/arch/xtensa/include/asm/signal.h
@@ -133,6 +133,7 @@ struct sigaction {
 	void (*sa_restorer)(void);
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
+#define __ARCH_HAS_SA_RESTORER
 
 struct k_sigaction {
 	struct sigaction sa;
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


