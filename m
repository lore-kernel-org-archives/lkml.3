Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3DLBOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:14:48 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49782 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab3DLBOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:42 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 18/25] init/main: call memlayout_global_init() in start_kernel().
Date: Thu, 11 Apr 2013 18:13:50 -0700
Message-Id: <1365729237-29711-19-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-9360-0000-0000-000011B4F90B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memlayout_global_init() initializes the first memlayout, which is
assumed to match the initial page-flag nid settings.

This is done in start_kernel() as the initdata used to populate the
memlayout is purged from memory early in the boot process (XXX: When?).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 init/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/main.c b/init/main.c
index 63534a1..a1c2094 100644
--- a/init/main.c
+++ b/init/main.c
@@ -72,6 +72,7 @@
 #include <linux/ptrace.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
+#include <linux/memlayout.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -618,6 +619,7 @@ asmlinkage void __init start_kernel(void)
 	security_init();
 	dbg_late_init();
 	vfs_caches_init(totalram_pages);
+	memlayout_global_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();
-- 
1.8.2.1

