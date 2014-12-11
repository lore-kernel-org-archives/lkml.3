Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbaLKM1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:27:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaLKM1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:27:14 -0500
Date: Thu, 11 Dec 2014 04:27:01 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-5de2b61a63f0982641eb00b9a6a9650f23487eaa@git.kernel.org>
Cc: bp@suse.de, mingo@kernel.org, matz@suse.de, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        hpa@zytor.com, tglx@linutronix.de
Reply-To: torvalds@linux-foundation.org, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, bp@suse.de, matz@suse.de,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <1418139917-12722-1-git-send-email-bp@alien8.de>
References: <1418139917-12722-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/asm: Guard against building the 32/
 64-bit versions of the asm-offsets*.c file directly
Git-Commit-ID: 5de2b61a63f0982641eb00b9a6a9650f23487eaa
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

Commit-ID:  5de2b61a63f0982641eb00b9a6a9650f23487eaa
Gitweb:     http://git.kernel.org/tip/5de2b61a63f0982641eb00b9a6a9650f23487eaa
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 9 Dec 2014 16:45:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Dec 2014 11:43:56 +0100

x86/asm: Guard against building the 32/64-bit versions of the asm-offsets*.c file directly

Sometimes it is helpful to build a kernel compilation unit
directly, i.e.:

  make .../<filename>.i

in order to look at compiler output.

Since asm-offsets_{32,64}.c are included by asm-offsets.c and
building them directly doesn't evaluate the macros used (thus
making the preprocessor output not very useful), error out when
an attempt is made to build them. Issue a hint for the user to
build asm-offsets.c instead.

Suggested-by: Michael Matz <matz@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418139917-12722-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/asm-offsets_32.c | 4 ++++
 arch/x86/kernel/asm-offsets_64.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index d67c4be..3b3b9d3 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -1,3 +1,7 @@
+#ifndef __LINUX_KBUILD_H
+# error "Please do not build this file directly, build asm-offsets.c instead"
+#endif
+
 #include <asm/ucontext.h>
 
 #include <linux/lguest.h>
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index e7c798b..4c0c596 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -1,3 +1,7 @@
+#ifndef __LINUX_KBUILD_H
+# error "Please do not build this file directly, build asm-offsets.c instead"
+#endif
+
 #include <asm/ia32.h>
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = 1,
