Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3IAET7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 00:19:59 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41071 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3IAET6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 00:19:58 -0400
Message-ID: <1378009191.25863.1.camel@phoenix>
Subject: [PATCH] regulator: da9063: Statize da9063_ldo_lim_event
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 01 Sep 2013 12:19:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da9063_ldo_lim_event() is only referenced in this driver, make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9063-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 139ad45..1a78163 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -592,7 +592,7 @@ static struct da9063_dev_model regulators_models[] = {
 };
 
 /* Regulator interrupt handlers */
-irqreturn_t da9063_ldo_lim_event(int irq, void *data)
+static irqreturn_t da9063_ldo_lim_event(int irq, void *data)
 {
 	struct da9063_regulators *regulators = data;
 	struct da9063 *hw = regulators->regulator[0].hw;
-- 
1.8.1.2



