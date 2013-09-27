Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3I0I0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:26:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:51154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab3I0I0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,991,1371106800"; 
   d="scan'208";a="366342900"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] arch: tile: re-use kbasename() helper
Date: Fri, 27 Sep 2013 11:26:30 +0300
Message-Id: <1380270390-25429-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbasename() returns the filename part of a pathname.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/tile/kernel/stack.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 362284a..c93977a 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -23,6 +23,7 @@
 #include <linux/mmzone.h>
 #include <linux/dcache.h>
 #include <linux/fs.h>
+#include <linux/string.h>
 #include <asm/backtrace.h>
 #include <asm/page.h>
 #include <asm/ucontext.h>
@@ -332,21 +333,18 @@ static void describe_addr(struct KBacktraceIterator *kbt,
 	}
 
 	if (vma->vm_file) {
-		char *s;
 		p = d_path(&vma->vm_file->f_path, buf, bufsize);
 		if (IS_ERR(p))
 			p = "?";
-		s = strrchr(p, '/');
-		if (s)
-			p = s+1;
+		name = kbasename(p);
 	} else {
-		p = "anon";
+		name = "anon";
 	}
 
 	/* Generate a string description of the vma info. */
-	namelen = strlen(p);
+	namelen = strlen(name);
 	remaining = (bufsize - 1) - namelen;
-	memmove(buf, p, namelen);
+	memmove(buf, name, namelen);
 	snprintf(buf + namelen, remaining, "[%lx+%lx] ",
 		 vma->vm_start, vma->vm_end - vma->vm_start);
 }
-- 
1.8.4.rc3

