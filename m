Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbbAFMlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:41:09 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:54541 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbAFMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:41:07 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86/boot: Add ability to call printf in video modes initialization
Date: Tue,  6 Jan 2015 18:40:29 +0600
Message-Id: <1420548029-20277-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.212.gc5b9256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added ability to call printf in video-mode.c, video-bios.c, video-vesa.c and
video-vga.c for debugging purposes.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/realmode/rm/Makefile | 4 ++--
 arch/x86/realmode/rm/printf.c | 1 +
 arch/x86/realmode/rm/string.c | 1 +
 arch/x86/realmode/rm/tty.c    | 1 +
 4 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/realmode/rm/printf.c
 create mode 100644 arch/x86/realmode/rm/string.c
 create mode 100644 arch/x86/realmode/rm/tty.c

diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 7c0d7be..e0f78f5 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -9,8 +9,8 @@
 
 always := realmode.bin realmode.relocs
 
-wakeup-objs	:= wakeup_asm.o wakemain.o video-mode.o
-wakeup-objs	+= copy.o bioscall.o regs.o
+wakeup-objs	:= wakeup_asm.o wakemain.o string.o tty.o printf.o
+wakeup-objs	+= video-mode.o copy.o bioscall.o regs.o
 # The link order of the video-*.o modules can matter.  In particular,
 # video-vga.o *must* be listed first, followed by video-vesa.o.
 # Hardware-specific drivers should follow in the order they should be
diff --git a/arch/x86/realmode/rm/printf.c b/arch/x86/realmode/rm/printf.c
new file mode 100644
index 0000000..bae7729
--- /dev/null
+++ b/arch/x86/realmode/rm/printf.c
@@ -0,0 +1 @@
+#include "../../boot/printf.c"
diff --git a/arch/x86/realmode/rm/string.c b/arch/x86/realmode/rm/string.c
new file mode 100644
index 0000000..cbd5413
--- /dev/null
+++ b/arch/x86/realmode/rm/string.c
@@ -0,0 +1 @@
+#include "../../boot/string.c"
diff --git a/arch/x86/realmode/rm/tty.c b/arch/x86/realmode/rm/tty.c
new file mode 100644
index 0000000..d915398
--- /dev/null
+++ b/arch/x86/realmode/rm/tty.c
@@ -0,0 +1 @@
+#include "../../boot/tty.c"
-- 
2.2.1.212.gc5b9256

