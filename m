Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaEVULR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:11:17 -0400
Received: from mout.gmx.net ([212.227.17.22]:53697 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaEVULQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:11:16 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, b.zolnierkie@samsung.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] ioat: Use time_before()
Date: Thu, 22 May 2014 22:11:06 +0200
Message-Id: <1400789466-11156-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:b8uCdB+w2h6b9KtF7PKOibHsxBjkPvsXO2ypYIgLOOkE71vptyi
 GMMN0nVXcBM1euNUo5ntqV8LyTB/oFp++a5cc2dufHnZXIJqs1gPsZFkUB6nl9XKZCoEgZH
 atz5J2IMSpweQAH8FDKCFugWE9B554rBOiPsta64obfqB+/nugAy72MqDjqDw9DGsPmhkna
 /+NjcXCtJcDjZrBOcGmOw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/dma/ioat/dma_v2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 8d10580..fdd60c7 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -735,7 +735,8 @@ int ioat2_check_space_lock(struct ioat2_dma_chan *ioat, int num_descs)
 	 * called under bh_disabled so we need to trigger the timer
 	 * event directly
 	 */
-	if (jiffies > chan->timer.expires && timer_pending(&chan->timer)) {
+	if (time_before(chan->timer.expires, jiffies)
+	    && timer_pending(&chan->timer)) {
 		struct ioatdma_device *device = chan->device;
 
 		mod_timer(&chan->timer, jiffies + COMPLETION_TIMEOUT);
-- 
1.7.10.4

