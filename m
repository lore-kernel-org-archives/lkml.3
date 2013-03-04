Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3CDJLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:11:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:62251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328Ab3CDJKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:10:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="208485591"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 08/10] dmatest: define MAX_ERROR_COUNT constant
Date: Mon,  4 Mar 2013 11:09:32 +0200
Message-Id: <1362388174-3435-9-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its meaning is to limit amount of error messages to be printed out when buffer
mismatch is occured.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index d19234b..4225a29 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -66,6 +66,9 @@ module_param(timeout, uint, S_IRUGO);
 MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), "
 		 "Pass -1 for infinite timeout");
 
+/* Maximum amount of mismatched bytes in buffer to print */
+#define MAX_ERROR_COUNT		32
+
 /*
  * Initialization patterns. All bytes in the source buffer has bit 7
  * set, all bytes in the destination buffer has bit 7 cleared.
@@ -249,7 +252,7 @@ static unsigned int dmatest_verify(u8 **bufs, unsigned int start,
 			actual = buf[i];
 			expected = pattern | (~counter & PATTERN_COUNT_MASK);
 			if (actual != expected) {
-				if (error_count < 32)
+				if (error_count < MAX_ERROR_COUNT)
 					dmatest_mismatch(actual, pattern, i,
 							 counter, is_srcbuf);
 				error_count++;
@@ -258,9 +261,9 @@ static unsigned int dmatest_verify(u8 **bufs, unsigned int start,
 		}
 	}
 
-	if (error_count > 32)
+	if (error_count > MAX_ERROR_COUNT)
 		pr_warning("%s: %u errors suppressed\n",
-			current->comm, error_count - 32);
+			current->comm, error_count - MAX_ERROR_COUNT);
 
 	return error_count;
 }
-- 
1.8.2.rc0.22.gb3600c3

