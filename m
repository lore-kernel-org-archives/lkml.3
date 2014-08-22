Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaHVAzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:55:04 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:59248 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaHVAzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:55:02 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: RK808: Fix uninitialized value
Date: Thu, 21 Aug 2014 17:54:55 -0700
Message-Id: <1408668895-1108-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RK808 regulator driver was putting its config on the stack but not
initting it.  That means that you got a semi-random config.  Fix this.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/regulator/rk808-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 94753fd..4d5041c 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -334,7 +334,7 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 {
 	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
 	struct rk808_board *pdata;
-	struct regulator_config config;
+	struct regulator_config config = {};
 	struct regulator_dev *rk808_rdev;
 	struct regulator_init_data *reg_data;
 	int i = 0;
-- 
2.1.0.rc2.206.gedb03e5

