Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab3GWPhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:37:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:32904 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab3GWPhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:37:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,728,1367996400"; 
   d="scan'208";a="369722400"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "Blin, Jerome" <jerome.blin@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/3] dmatest: print message on debug level in case of no error
Date: Tue, 23 Jul 2013 18:36:48 +0300
Message-Id: <1374593808-32475-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374593808-32475-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1374593808-32475-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's move the behaviour of printing no error message back to the pre v3.10
times. It means we will use debug level in the described case, and a warning
level otherwise.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index eae5989..92f796c 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -407,7 +407,11 @@ static int thread_result_add(struct dmatest_info *info,
 	list_add_tail(&tr->node, &r->results);
 	mutex_unlock(&info->results_lock);
 
-	pr_warn("%s\n", thread_result_get(r->name, tr));
+	if (tr->type == DMATEST_ET_OK)
+		pr_debug("%s\n", thread_result_get(r->name, tr));
+	else
+		pr_warn("%s\n", thread_result_get(r->name, tr));
+
 	return 0;
 }
 
-- 
1.8.3.2

