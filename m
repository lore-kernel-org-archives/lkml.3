Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab3J1WyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:54:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35821 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756244Ab3J1WyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:54:24 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        sachin.kamat@linaro.org, dan.j.williams@intel.com,
        vinod.koul@intel.com,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: [PATCH 1/2] dma: mv_xor: Remove unneeded NULL address check
Date: Mon, 28 Oct 2013 19:54:14 -0300
Message-Id: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mmio address is checked at probe-time, which makes this test
redundant. Let's just remove it.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/dma/mv_xor.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 536dcb8..d00d58e 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1076,10 +1076,6 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	}
 
 	mv_chan->mmr_base = xordev->xor_base;
-	if (!mv_chan->mmr_base) {
-		ret = -ENOMEM;
-		goto err_free_dma;
-	}
 	tasklet_init(&mv_chan->irq_tasklet, mv_xor_tasklet, (unsigned long)
 		     mv_chan);
 
-- 
1.8.1.5

