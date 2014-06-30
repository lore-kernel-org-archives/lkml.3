Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaF3Hdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:33:31 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35263 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaF3Hda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:33:30 -0400
Message-ID: <1404113605.21614.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: act8865: Explictly initialize of_node array
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        "Wenyou.Yang" <wenyou.yang@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 15:33:25 +0800
In-Reply-To: <1404113529.21614.1.camel@phoenix>
References: <1404113529.21614.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence below build warning:
  CC [M]  drivers/regulator/act8865-regulator.o
drivers/regulator/act8865-regulator.c: In function ‘act8865_pmic_probe’:
drivers/regulator/act8865-regulator.c:321: warning: ‘of_node’ may be used uninitialized in this function

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/act8865-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index f07be36..e9fea78 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -276,7 +276,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	struct act8865_platform_data *pdata = dev_get_platdata(dev);
 	struct regulator_config config = { };
 	struct act8865 *act8865;
-	struct device_node *of_node[ACT8865_REG_NUM];
+	struct device_node *of_node[ACT8865_REG_NUM] = { };
 	int i;
 	int ret;
 
-- 
1.9.1



