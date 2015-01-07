Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbbAGNzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:55:14 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:58470 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbAGNzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:55:11 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH v2] x86/boot: Add ability to call printf in video modes initialization
Date: Wed,  7 Jan 2015 19:54:54 +0600
Message-Id: <1420638894-14286-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.212.gc5b9256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added ability to call printf in video-mode.c, video-bios.c, video-vesa.c and
video-vga.c for debugging purposes.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/realmode/rm/Makefile | 3 +++
 arch/x86/realmode/rm/printf.c | 1 +
 arch/x86/realmode/rm/string.c | 1 +
 arch/x86/realmode/rm/tty.c    | 1 +
 4 files changed, 6 insertions(+)
 create mode 100644 arch/x86/realmode/rm/printf.c
 create mode 100644 arch/x86/realmode/rm/string.c
 create mode 100644 arch/x86/realmode/rm/tty.c

diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 7c0d7be..7354820 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -19,6 +19,9 @@ wakeup-objs	+= video-vga.o
 wakeup-objs	+= video-vesa.o
 wakeup-objs	+= video-bios.o
 
+realmode-y                      += string.o
+realmode-y                      += tty.o
+realmode-y                      += printf.o
 realmode-y			+= header.o
 realmode-y			+= trampoline_$(BITS).o
 realmode-y			+= stack.o
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

