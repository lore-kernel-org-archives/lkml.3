Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaIXN42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:56:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50976 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbaIXNr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:28 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/22] phy: phy-mvebu-sata: Add missing error check for devm_kzalloc
Date: Wed, 24 Sep 2014 19:17:01 +0530
Message-ID: <1411566440-19169-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

Currently this driver is missing a check on the return value of devm_kzalloc,
which would cause a NULL pointer dereference in a OOM situation.

This patch adds the aformentioned missing check.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-mvebu-sata.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/phy-mvebu-sata.c b/drivers/phy/phy-mvebu-sata.c
index cc3c0e1..10bb8e5 100644
--- a/drivers/phy/phy-mvebu-sata.c
+++ b/drivers/phy/phy-mvebu-sata.c
@@ -89,6 +89,8 @@ static int phy_mvebu_sata_probe(struct platform_device *pdev)
 	struct phy *phy;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(&pdev->dev, res);
-- 
1.7.9.5

