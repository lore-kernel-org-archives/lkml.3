Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3DLBc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:32:58 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49438 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab3DLBbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:31:48 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH PART2 v2 5/7] staging: ramster/debug: Add RAMSTER_DEBUG Kconfig entry 
Date: Fri, 12 Apr 2013 09:31:25 +0800
Message-Id: <1365730287-16876-6-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365730287-16876-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365730287-16876-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-7014-0000-0000-000002D6FB29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RAMSTER_DEBUG Kconfig entry.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/Kconfig         |    8 ++++++++
 drivers/staging/zcache/Makefile        |    2 +-
 drivers/staging/zcache/ramster/debug.h |    2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index c3b8a10..05e87a1 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -33,6 +33,14 @@ config RAMSTER
 	  zcache2, compresses swap pages into local RAM, but then remotifies
 	  the compressed pages to another node in the RAMster cluster.
 
+config RAMSTER_DEBUG
+        bool "Enable ramster debug statistics"
+        depends on DEBUG_FS && RAMSTER
+        default n
+        help
+          This is used to provide an debugfs directory with counters of
+          how ramster is doing. You probably want to set this to 'N'.
+
 # Depends on not-yet-upstreamed mm patches to export end_swap_bio_write and
 # __add_to_swap_cache, and implement __swap_writepage (which is swap_writepage
 # without the frontswap call. When these are in-tree, the dependency on
diff --git a/drivers/staging/zcache/Makefile b/drivers/staging/zcache/Makefile
index 4956fa0..845a5c2 100644
--- a/drivers/staging/zcache/Makefile
+++ b/drivers/staging/zcache/Makefile
@@ -1,6 +1,6 @@
 zcache-y	:=		zcache-main.o tmem.o zbud.o
 zcache-$(CONFIG_ZCACHE_DEBUG) += debug.o
-zcache-$(CONFIG_RAMSTER) += ramster/debug.o
+zcache-$(CONFIG_RAMSTER_DEBUG) += ramster/debug.o
 zcache-$(CONFIG_RAMSTER)	+=	ramster/ramster.o ramster/r2net.o
 zcache-$(CONFIG_RAMSTER)	+=	ramster/nodemanager.o ramster/tcp.o
 zcache-$(CONFIG_RAMSTER)	+=	ramster/heartbeat.o ramster/masklog.o
diff --git a/drivers/staging/zcache/ramster/debug.h b/drivers/staging/zcache/ramster/debug.h
index 7b2deaa..7f80dd4 100644
--- a/drivers/staging/zcache/ramster/debug.h
+++ b/drivers/staging/zcache/ramster/debug.h
@@ -1,4 +1,4 @@
-#ifdef CONFIG_RAMSTER
+#ifdef CONFIG_RAMSTER_DEBUG
 
 extern long ramster_flnodes;
 static atomic_t ramster_flnodes_atomic = ATOMIC_INIT(0);
-- 
1.7.10.4

