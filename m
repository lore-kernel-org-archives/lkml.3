Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab3HSIZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:25:33 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:39257 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3HSIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:25:31 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] dmaengine: make dmatest less noisy
Date: Mon, 19 Aug 2013 10:25:24 +0200
Message-Id: <1376900724-9636-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 95019c8c5 "dmatest: gather test results in the linked list"
started to warning whenever we add results to a test thread.
A warning for something completely normal? This is just cluttering
my terminal. Move to debug prints.

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Instead of flat out deleting this, move it to debug.
---
 drivers/dma/dmatest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e88ded2..e1dc005 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -36,7 +36,7 @@ static char test_device[20];
 module_param_string(device, test_device, sizeof(test_device), S_IRUGO);
 MODULE_PARM_DESC(device, "Bus ID of the DMA Engine to test (default: any)");
 
-static unsigned int threads_per_chan = 1;
+static unsigned int threads_per_chan = 8;
 module_param(threads_per_chan, uint, S_IRUGO);
 MODULE_PARM_DESC(threads_per_chan,
 		"Number of threads to start per channel (default: 1)");
@@ -406,7 +406,7 @@ static int thread_result_add(struct dmatest_info *info,
 	list_add_tail(&tr->node, &r->results);
 	mutex_unlock(&info->results_lock);
 
-	pr_warn("%s\n", thread_result_get(r->name, tr));
+	pr_debug("%s\n", thread_result_get(r->name, tr));
 	return 0;
 }
 
-- 
1.8.1.4

