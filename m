Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967090Ab3DRQyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:54:00 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64162 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966038Ab3DRQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:53:59 -0400
Message-ID: <1366304032.27953.1.camel@phoenix>
Subject: [PATCH RFT] regulator: palmas: Fix min_uV for LDO8 tracking mode
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Apr 2013 00:53:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SMPS45 is set to off and LDO8 tracking is enabled, the output voltage can
be set from 0.45 to 1.65 V. Thus set min_uV to be 450000.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Laxman,
My understanding is based on your comment in the code.
        /*
         * When SMPS45 is set to off and LDO8 tracking is enabled, the LDO8
         * output is defined by the LDO8_VOLTAGE.VSEL register divided by two,
         * and can be set from 0.45 to 1.65 V.
         */

Can you confirm if this patch is correct or not?
Axel

 drivers/regulator/palmas-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index d6efaf1..452d987 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -886,6 +886,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			if (pdata && (id == PALMAS_REG_LDO8) &&
 					pdata->enable_ldo8_tracking) {
 				palmas_enable_ldo8_track(palmas);
+				pmic->desc[id].min_uV = 450000;
 				pmic->desc[id].uV_step = 25000;
 			}
 		} else {
-- 
1.7.10.4



