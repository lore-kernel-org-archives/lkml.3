Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3LXNh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:37:57 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62876 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3LXNhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:37:55 -0500
Message-ID: <1387892270.16392.1.camel@phoenix>
Subject: [PATCH] regulator: max77693: Add missing .owner field in
 regulator_desc
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 24 Dec 2013 21:37:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing .owner field in regulator_desc, which is used for refcounting.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max77693.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index feb20bf..5fb899f 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -138,6 +138,7 @@ static struct regulator_ops max77693_charger_ops = {
 	.n_voltages	= 4,					\
 	.ops		= &max77693_safeout_ops,		\
 	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
 	.volt_table	= max77693_safeout_table,		\
 	.vsel_reg	= MAX77693_CHG_REG_SAFEOUT_CTRL,	\
 	.vsel_mask	= SAFEOUT_CTRL_SAFEOUT##_num##_MASK,	\
-- 
1.8.1.2



