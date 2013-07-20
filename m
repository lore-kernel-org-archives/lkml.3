Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3GTOhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 10:37:45 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51323 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3GTOhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 10:37:21 -0400
From: Bob Liu <lliubbo@gmail.com>
Cc: linux-kernel@vger.kernel.org, sjenning@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, ngupta@vflare.org, minchan@kernel.org,
        konrad.wilk@oracle.com, rcj@linux.vnet.ibm.com, mgorman@suse.de,
        riel@redhat.com, penberg@kernel.org, akpm@linux-foundation.org,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 1/2] zcache: staging: %s/ZCACHE/ZCACHE_OLD
Date: Sat, 20 Jul 2013 22:36:57 +0800
Message-Id: <1374331018-11045-2-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374331018-11045-1-git-send-email-bob.liu@oracle.com>
References: <1374331018-11045-1-git-send-email-bob.liu@oracle.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/staging/zcache/Kconfig  |   12 ++++++------
 drivers/staging/zcache/Makefile |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 2d7b2da..f96fb12 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -1,4 +1,4 @@
-config ZCACHE
+config ZCACHE_OLD
 	tristate "Dynamic compression of swap pages and clean pagecache pages"
 	depends on CRYPTO=y && SWAP=y && CLEANCACHE && FRONTSWAP
 	select CRYPTO_LZO
@@ -10,9 +10,9 @@ config ZCACHE
 	  memory to store clean page cache pages and swap in RAM,
 	  providing a noticeable reduction in disk I/O.
 
-config ZCACHE_DEBUG
+config ZCACHE_OLD_DEBUG
 	bool "Enable debug statistics"
-	depends on DEBUG_FS && ZCACHE
+	depends on DEBUG_FS && ZCACHE_OLD
 	default n
 	help
 	  This is used to provide an debugfs directory with counters of
@@ -20,7 +20,7 @@ config ZCACHE_DEBUG
 
 config RAMSTER
 	tristate "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
-	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE
+	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE_OLD
 	depends on NET
 	# must ensure struct page is 8-byte aligned
 	select HAVE_ALIGNED_STRUCT_PAGE if !64BIT
@@ -45,9 +45,9 @@ config RAMSTER_DEBUG
 # __add_to_swap_cache, and implement __swap_writepage (which is swap_writepage
 # without the frontswap call. When these are in-tree, the dependency on
 # BROKEN can be removed
-config ZCACHE_WRITEBACK
+config ZCACHE_OLD_WRITEBACK
 	bool "Allow compressed swap pages to be writtenback to swap disk"
-	depends on ZCACHE=y && BROKEN
+	depends on ZCACHE_OLD=y && BROKEN
 	default n
 	help
 	  Zcache caches compressed swap pages (and other data) in RAM which
diff --git a/drivers/staging/zcache/Makefile b/drivers/staging/zcache/Makefile
index 845a5c2..34d27bd 100644
--- a/drivers/staging/zcache/Makefile
+++ b/drivers/staging/zcache/Makefile
@@ -1,8 +1,8 @@
 zcache-y	:=		zcache-main.o tmem.o zbud.o
-zcache-$(CONFIG_ZCACHE_DEBUG) += debug.o
+zcache-$(CONFIG_ZCACHE_OLD_DEBUG) += debug.o
 zcache-$(CONFIG_RAMSTER_DEBUG) += ramster/debug.o
 zcache-$(CONFIG_RAMSTER)	+=	ramster/ramster.o ramster/r2net.o
 zcache-$(CONFIG_RAMSTER)	+=	ramster/nodemanager.o ramster/tcp.o
 zcache-$(CONFIG_RAMSTER)	+=	ramster/heartbeat.o ramster/masklog.o
 
-obj-$(CONFIG_ZCACHE)	+=	zcache.o
+obj-$(CONFIG_ZCACHE_OLD)	+=	zcache.o
-- 
1.7.10.4

