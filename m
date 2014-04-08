Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbaDHMHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:07:40 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:49248 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbaDHMHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:07:39 -0400
Message-ID: <1396958857.26620.35.camel@x220>
Subject: [PATCH] initramfs: remove "compression mode" choice
From: Paul Bolle <pebolle@tiscali.nl>
To: P J P <ppandit@redhat.com>, P J P <prasad@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Apr 2014 14:07:37 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2014 12:07:37.0458 (UTC) FILETIME=[21E3ED20:01CF5323]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9ba4bcb64589 ("initramfs: read CONFIG_RD_ variables for
initramfs compression") removed the users of the various
INITRAMFS_COMPRESSION_* Kconfig symbols. So since v3.13 the entire
"Built-in initramfs compression mode" choice is a set of knobs connected
to nothing. The entire choice can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
The help texts that are removed here contain a bit of information, eg on
the various compression algorithms. Is it useful enough to be readded
somewhere else?

"P J P" apparently has two redhat.com addresses. 

 usr/Kconfig | 77 -------------------------------------------------------------
 1 file changed, 77 deletions(-)

diff --git a/usr/Kconfig b/usr/Kconfig
index 642f503d3e9f..2d4c77eecf2e 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -98,80 +98,3 @@ config RD_LZ4
 	help
 	  Support loading of a LZ4 encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
-
-choice
-	prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=""
-	help
-	  This option decides by which algorithm the builtin initramfs
-	  will be compressed.  Several compression algorithms are
-	  available, which differ in efficiency, compression and
-	  decompression speed.  Compression speed is only relevant
-	  when building a kernel.  Decompression speed is relevant at
-	  each boot.
-
-	  If you have any problems with bzip2 or LZMA compressed
-	  initramfs, mail me (Alain Knaff) <alain@knaff.lu>.
-
-	  High compression options are mostly useful for users who are
-	  low on RAM, since it reduces the memory consumption during
-	  boot.
-
-	  If in doubt, select 'gzip'
-
-config INITRAMFS_COMPRESSION_NONE
-	bool "None"
-	help
-	  Do not compress the built-in initramfs at all. This may
-	  sound wasteful in space, but, you should be aware that the
-	  built-in initramfs will be compressed at a later stage
-	  anyways along with the rest of the kernel, on those
-	  architectures that support this.
-	  However, not compressing the initramfs may lead to slightly
-	  higher memory consumption during a short time at boot, while
-	  both the cpio image and the unpacked filesystem image will
-	  be present in memory simultaneously
-
-config INITRAMFS_COMPRESSION_GZIP
-	bool "Gzip"
-	depends on RD_GZIP
-	help
-	  The old and tried gzip compression. It provides a good balance
-	  between compression ratio and decompression speed.
-
-config INITRAMFS_COMPRESSION_BZIP2
-	bool "Bzip2"
-	depends on RD_BZIP2
-	help
-	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the choices.  The initramfs
-	  size is about 10% smaller with bzip2, in comparison to gzip.
-	  Bzip2 uses a large amount of memory. For modern kernels you
-	  will need at least 8MB RAM or more for booting.
-
-config INITRAMFS_COMPRESSION_LZMA
-	bool "LZMA"
-	depends on RD_LZMA
-	help
-	  This algorithm's compression ratio is best.
-	  Decompression speed is between the other choices.
-	  Compression is slowest. The initramfs size is about 33%
-	  smaller with LZMA in comparison to gzip.
-
-config INITRAMFS_COMPRESSION_XZ
-	bool "XZ"
-	depends on RD_XZ
-	help
-	  XZ uses the LZMA2 algorithm. The initramfs size is about 30%
-	  smaller with XZ in comparison to gzip. Decompression speed
-	  is better than that of bzip2 but worse than gzip and LZO.
-	  Compression is slow.
-
-config INITRAMFS_COMPRESSION_LZO
-	bool "LZO"
-	depends on RD_LZO
-	help
-	  Its compression ratio is the poorest among the choices. The kernel
-	  size is about 10% bigger than gzip; however its speed
-	  (both compression and decompression) is the fastest.
-
-endchoice
-- 
1.9.0

