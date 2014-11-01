Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874AbaKAVsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 17:48:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaKAVsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 17:48:50 -0400
Date: Sat, 1 Nov 2014 14:48:32 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-fb7183ef3c016d9067ff83f3ff2455be1818f902@git.kernel.org>
Cc: josh@joshtriplett.org, eternal.n08@gmail.com, keescook@chromium.org,
        hpa@zytor.com, matt.fleming@intel.com, mingo@kernel.org,
        ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, matt.fleming@intel.com, tglx@linutronix.de,
        ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org,
        eternal.n08@gmail.com, josh@joshtriplett.org, keescook@chromium.org,
        hpa@zytor.com
In-Reply-To: <20141031162204.GA26268@www.outflux.net>
References: <20141031162204.GA26268@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Document intermediates more clearly
Git-Commit-ID: fb7183ef3c016d9067ff83f3ff2455be1818f902
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

Commit-ID:  fb7183ef3c016d9067ff83f3ff2455be1818f902
Gitweb:     http://git.kernel.org/tip/fb7183ef3c016d9067ff83f3ff2455be1818f902
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri, 31 Oct 2014 09:22:04 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 1 Nov 2014 22:46:02 +0100

x86, boot: Document intermediates more clearly

This adds a comment detailing the various intermediate files used to build
the bootable decompression image for the x86 kernel.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Junjie Mao <eternal.n08@gmail.com>
Link: http://lkml.kernel.org/r/20141031162204.GA26268@www.outflux.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/boot/compressed/Makefile | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 704f58a..8a39181 100644
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
