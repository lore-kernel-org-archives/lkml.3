Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3HQKmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 06:42:53 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56438 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3HQKmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 06:42:52 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dmaengine: make dmatest less noisy
Date: Sat, 17 Aug 2013 12:42:40 +0200
Message-Id: <1376736160-26827-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 95019c8c5 "dmatest: gather test results in the linked list"
started to warning whenever we add results to a test thread.
A warning for something completely normal? This is just cluttering
my terminal. Get rid of this.

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/dmatest.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e88ded2..6bb51e2 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -406,7 +406,6 @@ static int thread_result_add(struct dmatest_info *info,
 	list_add_tail(&tr->node, &r->results);
 	mutex_unlock(&info->results_lock);
 
-	pr_warn("%s\n", thread_result_get(r->name, tr));
 	return 0;
 }
 
-- 
1.8.1.4

