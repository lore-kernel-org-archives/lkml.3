Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab3GWPhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:37:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:23270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab3GWPhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:37:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,728,1367996400"; 
   d="scan'208";a="375152734"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "Blin, Jerome" <jerome.blin@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/3] dmatest: remove IS_ERR_OR_NULL checks of debugfs calls
Date: Tue, 23 Jul 2013 18:36:47 +0300
Message-Id: <1374593808-32475-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374593808-32475-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1374593808-32475-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a really little chance when we are able to create a directory and are
not able to create nodes under it. So, this patch just removes those checks.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 91716f4..eae5989 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -1131,7 +1131,6 @@ static const struct file_operations dtf_results_fops = {
 static int dmatest_register_dbgfs(struct dmatest_info *info)
 {
 	struct dentry *d;
-	int ret = -ENOMEM;
 
 	d = debugfs_create_dir("dmatest", NULL);
 	if (IS_ERR(d))
@@ -1142,24 +1141,18 @@ static int dmatest_register_dbgfs(struct dmatest_info *info)
 	info->root = d;
 
 	/* Run or stop threaded test */
-	d = debugfs_create_file("run", S_IWUSR | S_IRUGO, info->root,
-				info, &dtf_run_fops);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
+	debugfs_create_file("run", S_IWUSR | S_IRUGO, info->root, info,
+			    &dtf_run_fops);
 
 	/* Results of test in progress */
-	d = debugfs_create_file("results", S_IRUGO, info->root, info,
-				&dtf_results_fops);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
+	debugfs_create_file("results", S_IRUGO, info->root, info,
+			    &dtf_results_fops);
 
 	return 0;
 
-err_node:
-	debugfs_remove_recursive(info->root);
 err_root:
 	pr_err("dmatest: Failed to initialize debugfs\n");
-	return ret;
+	return -ENOMEM;
 }
 
 static int __init dmatest_init(void)
-- 
1.8.3.2

