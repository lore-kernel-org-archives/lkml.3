Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3DUQ6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 12:58:50 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:34028 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3DUQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 12:58:49 -0400
Message-ID: <1366563522.10770.1.camel@phoenix>
Subject: [PATCH RFT] regulator: palmas: Fix off-by-one for ramp_delay and
 register value mapping
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 22 Apr 2013 00:58:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In probe(), we have below code to set ramp_delay:
e.g. When reg is 2, current code set
pmic->desc[id].ramp_delay = palmas_smps_ramp_delay[reg & 0x3];
                          = 5000
which means ramp_delay = 5000 is mapping to reg value = 2;

However, in palmas_smps_set_ramp_delay()
        ramp_delay = 5000 is mapping to reg value = 1.

This patch fixes the off-by-one value range checking for ramp_delay in
palmas_smps_set_ramp_delay().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Laxman,
I don't have the datasheet, so please check if this fix is correct.

Thanks,
Axel
 drivers/regulator/palmas-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 8fed60c..e3e8373 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -447,9 +447,9 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 
 	if (ramp_delay <= 0)
 		reg = 0;
-	else if (ramp_delay < 2500)
+	else if (ramp_delay <= 2500)From 6f6875db93eeff52d39623dd68522e1875cf5ef1 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@ingics.com>
Date: Mon, 22 Apr 2013 00:50:55 +0800
Subject: [PATCH RFT] regulator: palmas: Fix off-by-one for ramp_delay and register value mapping

In probe(), we have below code to set ramp_delay:
e.g. When reg is 2, current code set
pmic->desc[id].ramp_delay = palmas_smps_ramp_delay[reg & 0x3];
                          = 5000
which means ramp_delay = 5000 is mapping to reg value = 2;

However, in palmas_smps_set_ramp_delay()
        ramp_delay = 5000 is mapping to reg value = 1.

This patch fixes the off-by-one value range checking for ramp_delay in
palmas_smps_set_ramp_delay().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Laxman,
I don't have the datasheet, so please check if this fix is correct.

Thanks,
Axel
 drivers/regulator/palmas-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 8fed60c..e3e8373 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -447,9 +447,9 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 
 	if (ramp_delay <= 0)
 		reg = 0;
-	else if (ramp_delay < 2500)
+	else if (ramp_delay <= 2500)
 		reg = 3;
-	else if (ramp_delay < 5000)
+	else if (ramp_delay <= 5000)
 		reg = 2;
 	else
 		reg = 1;
-- 
1.7.10.4


 		reg = 3;
-	else if (ramp_delay < 5000)
+	else if (ramp_delay <= 5000)
 		reg = 2;
 	else
 		reg = 1;
-- 
1.7.10.4



