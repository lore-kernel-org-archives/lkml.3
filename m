Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3KOFo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:44:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49505 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab3KOFoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:44:21 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Roskin <proski@gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Revert "init/Kconfig: add option to disable kernel compression"
Date: Thu, 14 Nov 2013 21:43:47 -0800
Message-Id: <1384494227-24029-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

This reverts commit 69f0554ec261fd686ac7fa1c598cc9eb27b83a80.

This patch breaks randconfig on at least the x86-64 architecture, and
most likely on others.  There is work underway to support uncompressed
kernels in a generic way, but it looks like it will amount to
rewriting the support from scratch; see the LKML thread in the Link:
for info.

Therefore, revert this change and wait for the fix.

Reported-by: Pavel Roskin <proski@gnu.org>
Cc: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131113113418.167b8ffd@IRBT4585
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 init/Kconfig | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5496f307988e..bc8911fab28e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -118,6 +118,7 @@ config HAVE_KERNEL_LZ4
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -136,13 +137,6 @@ choice
 
 	  If in doubt, select 'gzip'
 
-config KERNEL_UNCOMPRESSED
-	bool "No compression"
-	help
-	  No compression at all. The kernel is huge but the compression and
-	  decompression times are zero.
-	  This is usually not what you want.
-
 config KERNEL_GZIP
 	bool "Gzip"
 	depends on HAVE_KERNEL_GZIP
-- 
1.8.3.1

