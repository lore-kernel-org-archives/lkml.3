Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab3GCSsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:48:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31313 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267Ab3GCSlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:03 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nhe2sW5qS88A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-xbh0xj19u4A:10 a=sozttTNsAAAA:8 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184052.019318773@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [045/141] regulator: palmas: Fix "enable_reg" to point to the correct reg for
 SMPS10
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0045-regulator-palmas-Fix-enable_reg-to-point-to-the-corr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit f232168df0c7e7414b70ac5d8fed83086d441c0b ]

regulator_enable_regmap() uses enable_reg to enable the regulator.
But enable_reg for smps10 points to SMPS10_STATUS which is a
read-only register. Fixed the same by having enable_reg
set to SMPS10_CTRL.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/regulator/palmas-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 46c7e88..f9e8a2b 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -685,7 +685,7 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_STATUS);
+							PALMAS_SMPS10_CTRL);
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
-- 
1.7.10.4


