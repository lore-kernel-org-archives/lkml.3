Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaJMHX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:23:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60601 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJMHXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:23:24 -0400
Date: Mon, 13 Oct 2014 09:23:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build change for v3.18
Message-ID: <20141013072319.GA14106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   # HEAD: 5c630089442c2e3482855c0849fea53abded81e2 x86/kbuild: Eliminate duplicate command line options

Includes a single commit that simplifies the no-FPU-ops build 
options.

 Thanks,

	Ingo

------------------>
Rasmus Villemoes (1):
      x86/kbuild: Eliminate duplicate command line options


 arch/x86/Makefile | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 60087ca37679..efea9112bbfe 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -50,9 +50,6 @@ ifeq ($(CONFIG_X86_32),y)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
-        # Don't autogenerate MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse
-
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
         # with nonstandard options
         KBUILD_CFLAGS += -fno-pic
@@ -80,8 +77,7 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
-        # Don't autogenerate traditional x87, MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse
+        # Don't autogenerate traditional x87 instructions
         KBUILD_CFLAGS += $(call cc-option,-mno-80387)
         KBUILD_CFLAGS += $(call cc-option,-mno-fp-ret-in-387)
 
@@ -168,7 +164,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 #
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # prevent gcc from generating any FP code by mistake
-KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
+KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
 KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
 KBUILD_CFLAGS += $(mflags-y)
