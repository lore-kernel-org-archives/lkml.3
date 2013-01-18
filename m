Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3ARVYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:24:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42285 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab3ARVYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:24:38 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, dan.magenheimer@oracle.com
Subject: [PATCH 3/5] staging: zcache: adjustments to config/build files due to renaming
Date: Fri, 18 Jan 2013 13:24:25 -0800
Message-Id: <1358544267-9104-4-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
References: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[V2: no code changes, patchset now generated via git format-patch -M]

In staging/zcache, adjust config/build due to ramster->zcache renaming

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/zcache/Kconfig  |   17 ++++++-----------
 drivers/staging/zcache/Makefile |    2 +-
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 3abf661..c1dbd04 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -1,23 +1,18 @@
-config ZCACHE2
+config ZCACHE
 	bool "Dynamic compression of swap pages and clean pagecache pages"
-	depends on CRYPTO=y && SWAP=y && CLEANCACHE && FRONTSWAP && !ZCACHE 
+	depends on CRYPTO=y && SWAP=y && CLEANCACHE && FRONTSWAP
 	select CRYPTO_LZO
 	default n
 	help
-	  Zcache2 doubles RAM efficiency while providing a significant
-	  performance boosts on many workloads.  Zcache2 uses
+	  Zcache doubles RAM efficiency while providing a significant
+	  performance boosts on many workloads.  Zcache uses
 	  compression and an in-kernel implementation of transcendent
 	  memory to store clean page cache pages and swap in RAM,
-	  providing a noticeable reduction in disk I/O.  Zcache2
-	  is a complete rewrite of the older zcache; it was intended to
-	  be a merge but that has been blocked due to political and
-	  technical disagreements.  It is intended that they will merge
-	  again in the future.  Until then, zcache2 is a single-node
-	  version of ramster.
+	  providing a noticeable reduction in disk I/O.
 
 config RAMSTER
 	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
-	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE2=y
+	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE=y
 	depends on NET
 	# must ensure struct page is 8-byte aligned
 	select HAVE_ALIGNED_STRUCT_PAGE if !64_BIT
diff --git a/drivers/staging/zcache/Makefile b/drivers/staging/zcache/Makefile
index 2d8b9d0..4711049 100644
--- a/drivers/staging/zcache/Makefile
+++ b/drivers/staging/zcache/Makefile
@@ -3,4 +3,4 @@ zcache-$(CONFIG_RAMSTER)	+=	ramster/ramster.o ramster/r2net.o
 zcache-$(CONFIG_RAMSTER)	+=	ramster/nodemanager.o ramster/tcp.o
 zcache-$(CONFIG_RAMSTER)	+=	ramster/heartbeat.o ramster/masklog.o
 
-obj-$(CONFIG_ZCACHE2)	+=	zcache.o
+obj-$(CONFIG_ZCACHE)	+=	zcache.o
-- 
1.7.1

