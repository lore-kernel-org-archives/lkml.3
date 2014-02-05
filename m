Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaBENlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:41:47 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17135 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaBENlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:41:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Feb 2014 05:40:16 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] pinctrl: tegra: return correct error type
Date: Wed, 5 Feb 2014 19:11:34 +0530
Message-ID: <1391607694-8608-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When memory allocation failed, drive should return error as ENOMEM.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/pinctrl/pinctrl-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index a2e93a2..e767355 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -645,7 +645,7 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 				 GFP_KERNEL);
 	if (!pmx->regs) {
 		dev_err(&pdev->dev, "Can't alloc regs pointer\n");
-		return -ENODEV;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < pmx->nbanks; i++) {
-- 
1.7.9.5

