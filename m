Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3FJLwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:52:31 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42652 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3FJLuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:24 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 08/15] net: emaclite: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:06 +0530
Message-Id: <1370864113-17895-9-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>
CC: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 1cd131b..fd4dbda 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1159,9 +1159,11 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	ndev->irq = res->start;
 
 	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	lp->base_addr = devm_request_and_ioremap(&ofdev->dev, res);
-	if (!lp->base_addr)
+	lp->base_addr = devm_ioremap_resource(&ofdev->dev, res);
+	if (IS_ERR(lp->base_addr)) {
+		rc = PTR_ERR(lp->base_addr);
 		goto error;
+	}
 
 	ndev->mem_start = res->start;
 	ndev->mem_end = res->end;
-- 
1.7.9.5

