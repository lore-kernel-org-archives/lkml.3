Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3LZGyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 01:54:06 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:42596 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3LZGyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 01:54:05 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH] regulator: act8865: fix incorrect devm_kzalloc for act8865
Date: Thu, 26 Dec 2013 14:52:43 +0800
Message-ID: <1388040763-15653-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which cause to allocate more needless memory.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/regulator/act8865-regulator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index f853353..aecf01b 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -290,9 +290,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	act8865 = devm_kzalloc(dev, sizeof(struct act8865) +
-			sizeof(struct regulator_dev *) * ACT8865_REG_NUM,
-			GFP_KERNEL);
+	act8865 = devm_kzalloc(dev, sizeof(struct act8865), GFP_KERNEL);
 	if (!act8865)
 		return -ENOMEM;
 
-- 
1.7.9.5

