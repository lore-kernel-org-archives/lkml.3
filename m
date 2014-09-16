Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaIPK6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:58:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaIPK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:58:37 -0400
Date: Tue, 16 Sep 2014 03:58:22 -0700
From: tip-bot for Rasmus Villemoes <tipbot@zytor.com>
Message-ID: <tip-5c630089442c2e3482855c0849fea53abded81e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pefoley2@pefoley.com,
        linux@rasmusvillemoes.dk, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux@rasmusvillemoes.dk,
        pefoley2@pefoley.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1410365139-24440-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410365139-24440-1-git-send-email-linux@rasmusvillemoes.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86/kbuild:
  Eliminate duplicate command line options
Git-Commit-ID: 5c630089442c2e3482855c0849fea53abded81e2
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

Commit-ID:  5c630089442c2e3482855c0849fea53abded81e2
Gitweb:     http://git.kernel.org/tip/5c630089442c2e3482855c0849fea53abded81e2
Author:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
AuthorDate: Wed, 10 Sep 2014 18:05:39 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 10:33:02 +0200

x86/kbuild: Eliminate duplicate command line options

The options -mno-mmx and -mno-sse are unconditionally added to
KBUILD_CFLAGS in both branches of an ifeq and through a
$(cc-option) further down. We can safely remove the first
instances.

In fact, since the -mno-mmx and -mno-sse options were introduced
simultaneous with the other two options in the $(cc-option)
[according to http://www.gnu.org/software/gcc/gcc-3.1/changes.html],
and since the former were unconditionally used, one can deduce that
only gcc versions knowing about all four are supported. So also
eliminate the $(cc-option) wrap.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Peter Foley <pefoley2@pefoley.com>
Link: http://lkml.kernel.org/r/1410365139-24440-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Makefile | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 60087ca..efea911 100644
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
