Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3JVKOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:14:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:52882 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3JVKO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:14:28 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/4] dma: cppi41: return code > 0 of pm_runtime_get_sync() is not an error
Date: Tue, 22 Oct 2013 12:14:06 +0200
Message-Id: <1382436846-9057-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382436846-9057-1-git-send-email-bigeasy@linutronix.de>
References: <1382436846-9057-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return code of pm_runtime_get_sync() > 0 is not an error and may happen.
Noticed during rmmod & modprobe testing.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/cppi41.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index 561de4f..c706d21 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -956,7 +956,7 @@ static int cppi41_dma_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
-	if (ret)
+	if (ret < 0)
 		goto err_get_sync;
 
 	cdd->queues_rx = glue_info->queues_rx;
-- 
1.8.4.rc3

