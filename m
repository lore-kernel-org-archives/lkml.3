Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaHOMlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:41:36 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:34094 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaHOMke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:40:34 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, kgene.kim@samsung.com, maxime.ripard@free-electrons.com,
        linux-samsung-soc@vger.kernel.org
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH 6/9] phy: phy-spear1340-miphy: Remove unncessary site specific OOM messages
Date: Fri, 15 Aug 2014 13:40:13 +0100
Message-Id: <1408106416-19044-7-git-send-email-peter.griffin@linaro.org>
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
 drivers/phy/phy-spear1340-miphy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/phy/phy-spear1340-miphy.c b/drivers/phy/phy-spear1340-miphy.c
index 7135ba2..ee4d66f 100644
--- a/drivers/phy/phy-spear1340-miphy.c
+++ b/drivers/phy/phy-spear1340-miphy.c
@@ -249,10 +249,8 @@ static int spear1340_miphy_probe(struct platform_device *pdev)
 	struct phy_provider *phy_provider;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev, "can't alloc spear1340_miphy private date memory\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->misc =
 		syscon_regmap_lookup_by_phandle(dev->of_node, "misc");
-- 
1.9.1

