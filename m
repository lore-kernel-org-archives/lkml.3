Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaKCOqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:46:14 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38858 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaKCOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:42:34 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 07/14] regulator: max77802: zero-initialize regulator match table
Date: Mon,  3 Nov 2014 15:40:42 +0100
Message-Id: <1415025649-8119-8-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct of_regulator_match is declared as a non-static local variable
so the structure members are not auto-initialized.

Initialize the struct at declaration time to avoid the structure members
values to be indeterminate and have sane defaults instead.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index a0d1462..d10c605 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -520,7 +520,7 @@ static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np;
 	struct max77686_regulator_data *rdata;
-	struct of_regulator_match rmatch;
+	struct of_regulator_match rmatch = { };
 	unsigned int i;
 
 	pmic_np = iodev->dev->of_node;
-- 
2.1.0

