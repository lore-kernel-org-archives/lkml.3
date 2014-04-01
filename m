Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaDAQSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:18:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44732 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaDAQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 41/86] can: flexcan: flexcan_remove(): add missing netif_napi_del()
Date: Tue,  1 Apr 2014 09:07:54 -0700
Message-Id: <1396368519-12728-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d96e43e8fce28cf97df576a07af9d65657a41a6f upstream.

This patch adds the missing netif_napi_del() to the flexcan_remove() function.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/flexcan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 275b721..96eef58 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1145,6 +1145,7 @@ static int flexcan_remove(struct platform_device *pdev)
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
 
+	netif_napi_del(&priv->napi);
 	free_candev(dev);
 
 	return 0;
-- 
1.8.3.2

