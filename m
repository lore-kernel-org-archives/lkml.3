Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322Ab3ECAIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:08:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42274 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639Ab3ECABn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:43 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 24/31] init/main: call memlayout_global_init() in start_kernel().
Date: Thu,  2 May 2013 17:00:56 -0700
Message-Id: <1367539263-19999-25-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-3620-0000-0000-0000024F5462
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
index ceed17a..8ed5209 100644
--- a/init/main.c
+++ b/init/main.c
@@ -74,6 +74,7 @@
 #include <linux/ptrace.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
+#include <linux/memlayout.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -613,6 +614,7 @@ asmlinkage void __init start_kernel(void)
 	security_init();
 	dbg_late_init();
 	vfs_caches_init(totalram_pages);
+	memlayout_global_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();
-- 
1.8.2.2

