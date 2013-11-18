Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab3KRJw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:52:29 -0500
Received: from mail.abilis.ch ([195.70.19.74]:22433 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3KRJwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:52:25 -0500
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Roskin <proski@gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        Noam Camus <noamc@ezchip.com>, Joe Perches <joe@perches.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH 1/2] init/Kconfig: add option to disable kernel compression
Date: Mon, 18 Nov 2013 10:51:50 +0100
Message-Id: <1384768311-8824-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20131118094807.GC31741@ab42.lan>
References: <20131118094807.GC31741@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ARC users say they can boot faster with without kernel compression.
This probably depends on things like the FLASH chip they use etc.

Until now, kernel compression can only be disabled by removing "select
HAVE_<compression>" lines from the architecture Kconfig.  So add the
Kconfig logic to permit disabling of kernel compression.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 arch/arc/Kconfig |    2 ++
 init/Kconfig     |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 2ee0c9b..15f4c3d 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -21,6 +21,8 @@ config ARC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IOREMAP_PROT
+	select HAVE_KERNEL_UNCOMPRESSED
+	select HAVE_KERNEL_GZIP
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_MEMBLOCK
diff --git a/init/Kconfig b/init/Kconfig
index 3fc8a2f..a21e94b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -97,6 +97,9 @@ config LOCALVERSION_AUTO
 
 	  which is done within the script "scripts/setlocalversion".)
 
+config HAVE_KERNEL_UNCOMPRESSED
+        bool
+
 config HAVE_KERNEL_GZIP
 	bool
 
@@ -118,7 +121,7 @@ config HAVE_KERNEL_LZ4
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4 || HAVE_KERNEL_UNCOMPRESSED
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -137,6 +140,14 @@ choice
 
 	  If in doubt, select 'gzip'
 
+config KERNEL_UNCOMPRESSED
+	bool "No compression"
+	depends on HAVE_KERNEL_UNCOMPRESSED
+	help
+	  No compression at all. The kernel is huge but the compression and
+	  decompression times are zero.
+	  This is usually not what you want.
+
 config KERNEL_GZIP
 	bool "Gzip"
 	depends on HAVE_KERNEL_GZIP
-- 
1.7.1

