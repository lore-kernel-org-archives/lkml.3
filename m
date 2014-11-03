Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaKCOpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:45:46 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38862 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaKCOmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:42:35 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 08/14] regulator: max8660: zero-initialize regulator match table array
Date: Mon,  3 Nov 2014 15:40:43 +0100
Message-Id: <1415025649-8119-9-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct of_regulator_match rmatch[] is declared as a non-static local
variable so the structure members are not auto-initialized.

Initialize the array at declaration time to avoid the structure members
values to be indeterminate and have sane defaults instead.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max8660.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 2fc4111..7eee2ca 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -335,7 +335,7 @@ static int max8660_pdata_from_dt(struct device *dev,
 	int matched, i;
 	struct device_node *np;
 	struct max8660_subdev_data *sub;
-	struct of_regulator_match rmatch[ARRAY_SIZE(max8660_reg)];
+	struct of_regulator_match rmatch[ARRAY_SIZE(max8660_reg)] = { };
 
 	np = of_get_child_by_name(dev->of_node, "regulators");
 	if (!np) {
-- 
2.1.0

