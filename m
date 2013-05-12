Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3ELOwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:52:54 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60578 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3ELOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:52:53 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: linus.walleij@linaro.org
Cc: linux@prisktech.co.nz, swarren@nvidia.com, olof@lixom.net,
        axel.lin@ingics.com, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: pinctrl: vt8500: use devm_ioremap_resource()
Date: Sun, 12 May 2013 16:59:51 +0200
Message-Id: <1368370791-32630-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_ioremap_resource.cocci

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/pinctrl/vt8500/pinctrl-wmt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index ab63104..e877082 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -569,10 +569,10 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
 	struct resource *res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	data->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!data->base) {
+	data->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(data->base)) {
 		dev_err(&pdev->dev, "failed to map memory resource\n");
-		return -EBUSY;
+		return PTR_ERR(data->base);
 	}
 
 	wmt_desc.pins = data->pins;
-- 
1.7.10.4

