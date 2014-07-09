Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaGILjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:39:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26878 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaGILgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:39 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-73-53bd293a4eaf
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 04/21] x86: boot: vdso: disable
 instrumentation for code not linked with kernel
Date: Wed, 09 Jul 2014 15:29:58 +0400
Message-id: <1404905415-9046-5-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xy7pWmnuDDRb3cVps+/WIzeL33pms
	FnPWr2GzuP7tDaPFhIdt7BYru5vZLLY/e8tksbLzAavFpsfXWC3+7NrBZHF51xw2i3tr/rNa
	3L7Ma3HpwAImi5Z9F5gs2j7/Y7XYt/I8kLVkI5PF4iO3mS3ePZvMbLF501Rmix8bHrM6iHm0
	NPeweeycdZfdY8GmUo9NqzrZPDZ9msTu0fX2CpPHu3Pn2D1OzPjN4vHkynQmj81L6j0+Pr3F
	4vF+31U2j74tqxg9ziw4wu7xeZNcAH8Ul01Kak5mWWqRvl0CV8bK55fZC5YJVnTveMrUwDiH
	r4uRk0NCwERiwbzPbBC2mMSFe+uBbC4OIYGljBJbfpxghXD6mCQ2vjrDDlLFJqAn8W/WdrAO
	EQEFic29z8CKmAWa2STaOz6wgiSEBYokWlYsYAaxWQRUJQ4+fMsEYvMKuEpcf7mHBWKdgsSy
	5TPB6jkF3CQmTL8GVM8BtM1VYsIKtQmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525i
	hMTS1x2MS49ZHWIU4GBU4uF9sXtPsBBrYllxZe4hRgkOZiURXlvRvcFCvCmJlVWpRfnxRaU5
	qcWHGJk4OKUaGNeEc+zs+z3Heo8pC9ebZAa5iMe7U1nkw3pfr4t7Vs17u33ax+sKeskySfFf
	/CfNsnnTuuvSkqenW7uW952/wL3MocnK/E7bDaG3tes2ztrp3sS7TTrTICV9fUdh1GeO5X/O
	+ykfd+25Hmo9gVVeN4bv261fd8LXHtf78CrV9bTz5bgJpnkhf5RYijMSDbWYi4oTARu0y72D	AgAA
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

