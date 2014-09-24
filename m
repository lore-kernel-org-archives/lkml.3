Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaIXNy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:54:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50987 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbaIXNrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:33 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/22] phy: phy-spear1310-miphy: Remove unncessary site specific OOM messages
Date: Wed, 24 Sep 2014 19:17:04 +0530
Message-ID: <1411566440-19169-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

The site specific OOM messages are unncessary, because they duplicate
messages from the memory subsystem which include dump_stack().

Removing these superflous messages makes the kernel smaller. A discussion
here http://patchwork.ozlabs.org/patch/324158/ found that all error paths
from kzalloc will print a error message, and that any error path which maybe
found which doesn't would be considered a bug in kzalloc.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-spear1310-miphy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/phy/phy-spear1310-miphy.c b/drivers/phy/phy-spear1310-miphy.c
index 6dcbfcd..911d25b 100644
--- a/drivers/phy/phy-spear1310-miphy.c
+++ b/drivers/phy/phy-spear1310-miphy.c
@@ -212,10 +212,8 @@ static int spear1310_miphy_probe(struct platform_device *pdev)
 	struct phy_provider *phy_provider;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev, "can't alloc spear1310_miphy private date memory\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->misc =
 		syscon_regmap_lookup_by_phandle(dev->of_node, "misc");
-- 
1.7.9.5

