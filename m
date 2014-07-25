Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbaGYGUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:20:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50094 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834AbaGYGUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:20:17 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: Wolfgang Grandegger <wg@grandegger.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, Pavel Machek <pavel@denx.de>,
        Thor Thayer <tthayer@altera.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wolfram Sang <wsa@sang-engineering.com>,
        Chen Gang <gang.chen@asianux.com>,
        George Cherian <george.cherian@ti.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mugunthan V N <mugunthanvnm@ti.com>
Subject: [can-next PATCH 1/1] net: can: c_can_platform: Use devm_ioremap instead of devm_ioremap_resource.
Date: Fri, 25 Jul 2014 11:49:41 +0530
Message-ID: <1406269181-4092-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.2.673.g9ab0882
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Cherian <george.cherian@ti.com>

The raminit register is shared register for both can0 and can1.
Using devm_ioremap_resource fails the mapping for can1 interface
leading to a non functional can interface.

Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 drivers/net/can/c_can/c_can_platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index e29b6d0..5dede6e 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -278,7 +278,8 @@ static int c_can_plat_probe(struct platform_device *pdev)
 			break;
 		}
 
-		priv->raminit_ctrlreg = devm_ioremap_resource(&pdev->dev, res);
+		priv->raminit_ctrlreg = devm_ioremap(&pdev->dev, res->start,
+						     resource_size(res));
 		if (IS_ERR(priv->raminit_ctrlreg) || priv->instance < 0)
 			dev_info(&pdev->dev, "control memory is not used for raminit\n");
 		else
-- 
2.0.2.673.g9ab0882

