Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaFRTnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:43:22 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16274 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaFRTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:43:21 -0400
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="35095558"
From: Graham Williams <graham.williams@linaro.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "Matt Porter" <mporter@linaro.org>, Lee Jones <lee.jones@linaro.org>
CC: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: bcm590xx: fix vbus name
Date: Wed, 18 Jun 2014 12:42:10 -0700
Message-ID: <1403120530-27395-1-git-send-email-graham.williams@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vbus regulator was not getting its name set. This results
in the sysfs entry being empty. The lack of a bcm590xx_regs[]
table entry also upsets Coverity runs. Add the table entry
so the name gets set properly.

Signed-off-by: Graham Williams <graham.williams@linaro.org>
---
 drivers/regulator/bcm590xx-regulator.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
index 57544e2..58ece59 100644
--- a/drivers/regulator/bcm590xx-regulator.c
+++ b/drivers/regulator/bcm590xx-regulator.c
@@ -119,6 +119,10 @@ static const unsigned int ldo_c_table[] = {
 	2900000, 3000000, 3300000,
 };
 
+static const unsigned int ldo_vbus[] = {
+	5000000,
+};
+
 /* DCDC group CSR: supported voltages in microvolts */
 static const struct regulator_linear_range dcdc_csr_ranges[] = {
 	REGULATOR_LINEAR_RANGE(860000, 2, 50, 10000),
@@ -192,6 +196,7 @@ static struct bcm590xx_info bcm590xx_regs[] = {
 	BCM590XX_REG_TABLE(gpldo4, ldo_a_table),
 	BCM590XX_REG_TABLE(gpldo5, ldo_a_table),
 	BCM590XX_REG_TABLE(gpldo6, ldo_a_table),
+	BCM590XX_REG_TABLE(vbus, ldo_vbus),
 };
 
 struct bcm590xx_reg {
-- 
1.7.9.5

