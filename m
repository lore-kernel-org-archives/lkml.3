Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaHOMkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:40:35 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60335 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaHOMkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:40:24 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, kgene.kim@samsung.com, maxime.ripard@free-electrons.com,
        linux-samsung-soc@vger.kernel.org
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH 1/9] phy: phy-omap-control: Remove unncessary site specific OOM messages
Date: Fri, 15 Aug 2014 13:40:08 +0100
Message-Id: <1408106416-19044-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408106416-19044-1-git-send-email-peter.griffin@linaro.org>
References: <1408106416-19044-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site specific OOM messages are unncessary, because they duplicate
messages from the memory subsystem which include dump_stack().

Removing these superflous messages makes the kernel smaller. A discussion
here http://patchwork.ozlabs.org/patch/324158/ found that all error paths
from kzalloc will print a error message, and that any error path which maybe
found which doesn't would be considered a bug in kzalloc.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/phy/phy-omap-control.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
index 9487bf1..cb2f4d1 100644
--- a/drivers/phy/phy-omap-control.c
+++ b/drivers/phy/phy-omap-control.c
@@ -295,10 +295,8 @@ static int omap_control_phy_probe(struct platform_device *pdev)
 
 	control_phy = devm_kzalloc(&pdev->dev, sizeof(*control_phy),
 		GFP_KERNEL);
-	if (!control_phy) {
-		dev_err(&pdev->dev, "unable to alloc memory for control phy\n");
+	if (!control_phy)
 		return -ENOMEM;
-	}
 
 	control_phy->dev = &pdev->dev;
 	control_phy->type = *(enum omap_control_phy_type *)of_id->data;
-- 
1.9.1

