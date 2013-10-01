Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3JAELb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 00:11:31 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58135 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3JAEL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 00:11:29 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, rmk+kernel@arm.linux.org.uk,
        badarkhe.manish@gmail.com
Subject: [PATCH] regulator: tps65090: remove usage of IS_ERR_OR_NULL
Date: Tue,  1 Oct 2013 09:41:04 +0530
Message-Id: <1380600664-20649-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the driver to avoid the usage of IS_ERR_OR_NULL()
macro.

The case present in this patch simply translates to normal check for pointer,
wheather it is NULL or has an error code.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 bd611cdf.. ad3d4d4... M	drivers/regulator/tps65090-regulator.c
 drivers/regulator/tps65090-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index bd611cdf..ad3d4d4 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -245,7 +245,7 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 	if (!tps65090_pdata && tps65090_mfd->dev->of_node)
 		tps65090_pdata = tps65090_parse_dt_reg_data(pdev,
 					&tps65090_reg_matches);
-	if (IS_ERR_OR_NULL(tps65090_pdata)) {
+	if (!tps65090_pdata || IS_ERR(tps65090_pdata)) {
 		dev_err(&pdev->dev, "Platform data missing\n");
 		return tps65090_pdata ? PTR_ERR(tps65090_pdata) : -EINVAL;
 	}
-- 
1.7.10.4

