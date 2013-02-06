Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab3BFC60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:58:26 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:34897 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab3BFC6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:58:25 -0500
Message-ID: <1360119498.8965.5.camel@phoenix>
Subject: [PATCH 3/3] regulator: s5m8767: Prevent possible NULL pointer
 dereference
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, LiamGirdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 10:58:18 +0800
In-Reply-To: <1360119305.8965.1.camel@phoenix>
References: <1360119305.8965.1.camel@phoenix>
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
index 4cb65e3..0349358 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -659,17 +659,17 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	struct s5m8767_info *s5m8767;
 	int i, ret, size, buck_init;
 
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data not supplied\n");
+		return -ENODEV;
+	}
+
 	if (iodev->dev->of_node) {
 		ret = s5m8767_pmic_dt_parse_pdata(pdev, pdata);
 		if (ret)
 			return ret;
 	}
 
-	if (!pdata) {
-		dev_err(&pdev->dev, "Platform data not supplied\n");
-		return -ENODEV;
-	}
-
 	if (pdata->buck2_gpiodvs) {
 		if (pdata->buck3_gpiodvs || pdata->buck4_gpiodvs) {
 			dev_err(&pdev->dev, "S5M8767 GPIO DVS NOT VALID\n");
-- 
1.7.9.5



