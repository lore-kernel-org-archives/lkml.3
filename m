Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3KZUvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:51:24 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:54304
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757955Ab3KZUvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:51:21 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: akpm@linux-foundation.org, alexander.h.duyck@intel.com,
        dan.carpenter@oracle.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH linux-next] dma-debug: Fix coccinelle warnings in device_dma_allocations()
Date: Tue, 26 Nov 2013 13:51:15 -0700
Message-Id: <1385499075-1928-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/dma-debug.c:740:11-16: ERROR: invalid reference to the index variable of the iterator on line 726

This error is a result of referencing entry->dev in dev_warn() when entry
might not be valid at the time of reference. Change dev_warn() to use input
parameter struct device *dev instead to print warning.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 lib/dma-debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index e34865e..5f29445 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -737,7 +737,7 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
 	local_irq_restore(flags);
 
 	if (map_err_cnt)
-		dev_warn(entry->dev,
+		dev_warn(dev,
 			"DMA-API: device driver failed to check map errors: "
 			"[count] = %d\n", map_err_cnt);
 	return count;
-- 
1.8.3.2

