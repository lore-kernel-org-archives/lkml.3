Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaKFV15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:27:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaKFV1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:27:52 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Aristeu Rozanski <arozansk@redhat.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] lib/halfmd4: make build optional
Date: Thu,  6 Nov 2014 16:27:33 -0500
Message-Id: <1415309253-13019-1-git-send-email-aris@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <arozansk@redhat.com>

halfmd4 currently is built unconditionally:
	text    data     bss     dec     hex filename
	 801     176       8     985     3d9 lib/halfmd4.o
	 801     176       8     985     3d9 (TOTALS)

and it's used by ext3 and ext4. This patch is useful for situations
in which memory footprint is a concern and those filesystems aren't
used.

Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 fs/ext3/Kconfig | 1 +
 fs/ext4/Kconfig | 1 +
 lib/Kconfig     | 7 +++++++
 lib/Makefile    | 3 ++-
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext3/Kconfig b/fs/ext3/Kconfig
index e8c6ba0..a6ab4e8 100644
--- a/fs/ext3/Kconfig
+++ b/fs/ext3/Kconfig
@@ -1,6 +1,7 @@
 config EXT3_FS
 	tristate "Ext3 journalling file system support"
 	select JBD
+	select HALF_MD4
 	help
 	  This is the journalling version of the Second extended file system
 	  (often called ext3), the de facto standard Linux file system
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index efea5d5..cbb56ee 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -4,6 +4,7 @@ config EXT4_FS
 	select CRC16
 	select CRYPTO
 	select CRYPTO_CRC32C
+	select HALF_MD4
 	help
 	  This is the next generation of the ext3 filesystem.
 
diff --git a/lib/Kconfig b/lib/Kconfig
index 675920b..108196c 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -180,6 +180,13 @@ config CRC8
 	  when they need to do cyclic redundancy check according CRC8
 	  algorithm. Module will be called crc8.
 
+config HALF_MD4
+	bool "Half MD4 transform"
+	default y
+	help
+	  This option enables a reduced (32 bit output) version of MD4
+	  transform.
+
 config AUDIT_GENERIC
 	bool
 	depends on AUDIT && !AUDIT_ARCH
diff --git a/lib/Makefile b/lib/Makefile
index 9c12cbc..53fd120 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -22,7 +22,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
 
-obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
+obj-y += bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o iovec.o clz_ctz.o \
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
@@ -74,6 +74,7 @@ obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
 obj-$(CONFIG_CRC8)	+= crc8.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
+obj-$(CONFIG_HALF_MD4) += halfmd4.o
 
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
 obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
-- 
1.8.3.1

