Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3IRHVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 03:21:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:42244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab3IRHVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 03:21:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,928,1371106800"; 
   d="scan'208";a="405041454"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] gcov: reuse kbasename helper
Date: Wed, 18 Sep 2013 10:21:17 +0300
Message-Id: <1379488877-15264-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get name of the file from a pathname let's use kbasename() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 kernel/gcov/fs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 7a7d2ee..7eb891a 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -365,7 +365,7 @@ static const char *deskew(const char *basename)
  */
 static void add_links(struct gcov_node *node, struct dentry *parent)
 {
-	char *basename;
+	const char *basename;
 	char *target;
 	int num;
 	int i;
@@ -380,10 +380,9 @@ static void add_links(struct gcov_node *node, struct dentry *parent)
 					 &gcov_link[i]);
 		if (!target)
 			goto out_err;
-		basename = strrchr(target, '/');
-		if (!basename)
+		basename = kbasename(target);
+		if (basename == target)
 			goto out_err;
-		basename++;
 		node->links[i] = debugfs_create_symlink(deskew(basename),
 							parent,	target);
 		if (!node->links[i])
-- 
1.8.4.rc3

