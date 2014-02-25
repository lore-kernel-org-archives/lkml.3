Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaBYOTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:19:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:59941 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbaBYOTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:19:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="481478450"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, willy@linux.intel.com
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v6 09/22] Remove mm/filemap_xip.c
Date: Tue, 25 Feb 2014 09:18:25 -0500
Message-Id: <1393337918-28265-10-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now empty as all of its contents have been replaced by fs/xip.c

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 mm/Makefile      |  1 -
 mm/filemap_xip.c | 23 -----------------------
 2 files changed, 24 deletions(-)
 delete mode 100644 mm/filemap_xip.c

diff --git a/mm/Makefile b/mm/Makefile
index 310c90a..454c176 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
-obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
deleted file mode 100644
index 6316578..0000000
--- a/mm/filemap_xip.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- *	linux/mm/filemap_xip.c
- *
- * Copyright (C) 2005 IBM Corporation
- * Author: Carsten Otte <cotte@de.ibm.com>
- *
- * derived from linux/mm/filemap.c - Copyright (C) Linus Torvalds
- *
- */
-
-#include <linux/fs.h>
-#include <linux/pagemap.h>
-#include <linux/export.h>
-#include <linux/uio.h>
-#include <linux/rmap.h>
-#include <linux/mmu_notifier.h>
-#include <linux/sched.h>
-#include <linux/seqlock.h>
-#include <linux/mutex.h>
-#include <linux/gfp.h>
-#include <asm/tlbflush.h>
-#include <asm/io.h>
-
-- 
1.8.5.3

