Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaDALVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:21:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42807 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaDALTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 142/144] can: flexcan: flexcan_remove(): add missing netif_napi_del()
Date: Tue,  1 Apr 2014 12:15:46 +0100
Message-Id: <1396350948-29910-143-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d96e43e8fce28cf97df576a07af9d65657a41a6f upstream.

This patch adds the missing netif_napi_del() to the flexcan_remove() function.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index bc30fd1..1e54c7f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1213,6 +1213,7 @@ static int flexcan_remove(struct platform_device *pdev)
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
 
+	netif_napi_del(&priv->napi);
 	free_candev(dev);
 
 	return 0;
-- 
1.9.1

