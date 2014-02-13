Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaBMLkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:40:31 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:59827 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbaBMLk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:40:29 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com,
        sachin.kamat@linaro.org
Subject: [PATCH 2/2] regulator: s5m8767: Add missing of_node_put
Date: Thu, 13 Feb 2014 17:05:07 +0530
Message-Id: <1392291307-21104-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392291307-21104-1-git-send-email-sachin.kamat@linaro.org>
References: <1392291307-21104-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/s5m8767.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 40de16802681..4c356b872e6b 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -659,6 +659,8 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 		rmode++;
 	}
 
+	of_node_put(regulators_np);
+
 	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-uses-gpio-dvs", NULL)) {
 		pdata->buck2_gpiodvs = true;
 
-- 
1.7.9.5

