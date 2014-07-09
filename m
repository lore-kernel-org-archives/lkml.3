Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaGILSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:18:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43665 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaGILKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:22 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-94-53bd2317632c
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 04/21] x86: boot: vdso: disable instrumentation for
 code not linked with kernel
Date: Wed, 09 Jul 2014 15:01:01 +0400
Message-id: <1404903678-8257-5-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7riynuDDRqf61ts+/WIzeLyrjls
	DkwefVtWMXp83iQXwBTFZZOSmpNZllqkb5fAlbHy+WX2gmWCFd07njI1MM7h62Lk5JAQMJG4
	MGEKE4QtJnHh3nq2LkYuDiGBpYwSLT3HWSCcPiaJt7sWg1WxCehJ/Ju1nQ3EFhFQkNjc+4wV
	xGYW0JHYeK0VrEZYIFti/9udzCA2i4CqxIOFO8FqeAVcJabcbGGG2KYgsWz5TLA4p4CbRE/P
	ArBeIaCa1Z+3MU5g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQMvuxgXHzM6hCj
	AAejEg+vRu3uYCHWxLLiytxDjBIczEoivLaie4OFeFMSK6tSi/Lji0pzUosPMTJxcEo1MPbO
	aCmd3H9hV3bk9aV737K57Sp1XXMpYI3yoW1pR8uMNb+ziByd1T1NW/xv1O/F5w5biMt8Pssq
	N8GZ5e9uYaVPt2Zbhno4CC78NzvMO+DrVQXzfHnxx+JMX/zar9VZaqXY7D0xnUlQtqbvlPi6
	qplzTohwS77aXc7umdeYHSIbmbKAo+cImxJLcUaioRZzUXEiAFooH8nhAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid build errors, compiler's instrumentation must be disabled
for code not linked with kernel image.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/boot/Makefile            | 2 ++
 arch/x86/boot/compressed/Makefile | 2 ++
 arch/x86/realmode/Makefile        | 2 +-
 arch/x86/realmode/rm/Makefile     | 1 +
 arch/x86/vdso/Makefile            | 1 +
 5 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index dbe8dd2..9204cc0 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -14,6 +14,8 @@
 # Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
 # The number is the same as you would ordinarily press at bootup.
 
+KASAN_SANITIZE := n
+
 SVGA_MODE	:= -DSVGA_MODE=NORMAL_VGA
 
 targets		:= vmlinux.bin setup.bin setup.elf bzImage
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0fcd913..64a92b3 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,6 +4,8 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
+KASAN_SANITIZE := n
+
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
 	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
 
diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
index 94f7fbe..e02c2c6 100644
--- a/arch/x86/realmode/Makefile
+++ b/arch/x86/realmode/Makefile
@@ -6,7 +6,7 @@
 # for more details.
 #
 #
-
+KASAN_SANITIZE := n
 subdir- := rm
 
 obj-y += init.o
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 7c0d7be..2730d77 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -6,6 +6,7 @@
 # for more details.
 #
 #
+KASAN_SANITIZE := n
 
 always := realmode.bin realmode.relocs
 
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 61b04fe..90daad6 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -3,6 +3,7 @@
 #
 
 KBUILD_CFLAGS += $(DISABLE_LTO)
+KASAN_SANITIZE := n
 
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
-- 
1.8.5.5

