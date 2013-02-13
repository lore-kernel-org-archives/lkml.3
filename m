Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab3BMBbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 20:31:39 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63092 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab3BMBbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 20:31:38 -0500
Message-ID: <1360719091.14930.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: s5m8767: Prevent possible NULL pointer
 dereference
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, LiamGirdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 09:31:31 +0800
In-Reply-To: <1360718985.14930.1.camel@phoenix>
References: <1360718985.14930.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s5m8767_pmic_dt_parse_pdata dereferenes pdata, thus check pdata earlier to
avoid NULL pointer dereference.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s5m8767.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index ef0532d..8a83194 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -659,17 +659,17 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	struct s5m8767_info *s5m8767;
 	int i, ret, size, buck_init;
 
+	if (!pdata) {
+		dev_err(pdev->dev.parent, "Platform data not supplied\n");
+		return -ENODEV;
+	}
+
 	if (iodev->dev->of_node) {
 		ret = s5m8767_pmic_dt_parse_pdata(pdev, pdata);
 		if (ret)
 			return ret;
 	}
 
-	if (!pdata) {
-		dev_err(pdev->dev.parent, "Platform data not supplied\n");
-		return -ENODEV;
-	}
-
 	if (pdata->buck2_gpiodvs) {
 		if (pdata->buck3_gpiodvs || pdata->buck4_gpiodvs) {
 			dev_err(&pdev->dev, "S5M8767 GPIO DVS NOT VALID\n");
-- 
1.7.9.5



