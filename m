Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaI3Vgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:36:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaI3Vgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 031/103] can: c_can: checking IS_ERR() instead of NULL
Date: Tue, 30 Sep 2014 14:30:36 -0700
Message-Id: <1412112708-27356-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 37b75a3aa8ec7031df75219fe2f8e5e9b7be398f upstream.

devm_ioremap() returns NULL on error, not an ERR_PTR().

Fixes: 33cf75656923 ('can: c_can_platform: Fix raminit, use devm_ioremap() instead of devm_ioremap_resource()')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/c_can/c_can_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 873b83a..a7d4089 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -196,7 +196,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		priv->raminit_ctrlreg = devm_ioremap(&pdev->dev, res->start,
 						     resource_size(res));
-		if (IS_ERR(priv->raminit_ctrlreg) || (int)priv->instance < 0)
+		if (!priv->raminit_ctrlreg || priv->instance < 0)
 			dev_info(&pdev->dev, "control memory is not used for raminit\n");
 		else
 			priv->raminit = c_can_hw_raminit;
-- 
1.9.1

