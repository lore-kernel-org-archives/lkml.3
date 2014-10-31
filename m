Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbaJaQXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:23:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36776 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaJaQXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:23:21 -0400
Date: Fri, 31 Oct 2014 09:22:04 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Junjie Mao <eternal.n08@gmail.com>
Subject: [PATCH] x86, boot: document intermediates more clearly
Message-ID: <20141031162204.GA26268@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a comment detailing the various intermediate files used to build
the bootable decompression image for the x86 kernel.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/Makefile | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index be1e07d4b596..44a866b85c6f 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -3,6 +3,18 @@
 #
 # create a compressed vmlinux image from the original vmlinux
 #
+# vmlinuz is:
+#	decompression code (*.o)
+#	asm globals (piggy.S), including:
+#		vmlinux.bin.(gz|bz2|lzma|...)
+#
+# vmlinux.bin is:
+#	vmlinux stripped of debugging and comments
+# vmlinux.bin.all is:
+#	vmlinux.bin + vmlinux.relocs
+# vmlinux.bin.(gz|bz2|lzma|...) is:
+#	(see scripts/Makefile.lib size_append)
+#	compressed vmlinux.bin.all + u32 size of vmlinux.bin.all
 
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
 	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
