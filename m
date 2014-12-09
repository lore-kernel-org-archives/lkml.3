Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaLIPpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:45:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47330 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbaLIPpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:45:22 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Michael Matz <matz@suse.de>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH] x86, asm-offsets: Guard against building the 32/64-bit versions directly
Date: Tue,  9 Dec 2014 16:45:17 +0100
Message-Id: <1418139917-12722-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Sometimes it is helpful to build a kernel compilation unit directly, i.e.

make .../<filename>.i

in order to look at compiler output.

Since asm-offsets_{32,64}.c are included by asm-offsets.c and building
them directly doesn't evaluate the macros used (thus making the
preprocessor output not very useful), error out when an attempt is made
to build them. Issue a hint for the user to build asm-offsets.c instead.

Suggested-by: Michael Matz <matz@suse.de>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/asm-offsets_32.c | 4 ++++
 arch/x86/kernel/asm-offsets_64.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index d67c4be3e8b1..207c48278dff 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -1,3 +1,7 @@
+#ifndef __LINUX_KBUILD_H
+#error "Please do not build this file directly, build asm-offsets.c instead"
+#endif
+
 #include <asm/ucontext.h>
 
 #include <linux/lguest.h>
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 4f9359f36bb7..7fcb2312b532 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -1,3 +1,7 @@
+#ifndef __LINUX_KBUILD_H
+#error "Please do not build this file directly, build asm-offsets.c instead"
+#endif
+
 #include <asm/ia32.h>
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = 1,
-- 
2.0.0

