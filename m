Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3IWHyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:54:25 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61825 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3IWHyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:54:24 -0400
Message-ID: <1379922860.20251.1.camel@phoenix>
Subject: [PATCH] regulator: wm831x-ldo: Fix max_uV for gp_ldo and aldo
 linear range settings
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 23 Sep 2013 15:54:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the linear range settings in commit 5ff26a14c3331
"regulator: wm831x-ldo: Convert to use linear ranges".

For wm831x_gp_ldo:
We have below equations for list voltage before converting to linear ranges:

sel <= 0xe:
        volt = 0.9-1.6V in 50mV steps
sel <= 0x1f:
        volt = 1.7-3.3V in 100mV steps

max_uV for the first linear range should be 1600000 rather than 1650000. Fix it.

For wm831x_aldo:
We have below equations for list voltage before converting to linear ranges:

sel <= 0xc:
        volt = 1-1.6V in 50mV steps
sel <= 0x1f
        volt = 1.7-3.5V in 100mV steps

max_uV for the first linear range should be 1600000 rather than 1650000. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/wm831x-ldo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 2be72fe..482ebe8 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -63,7 +63,7 @@ static irqreturn_t wm831x_ldo_uv_irq(int irq, void *data)
  */
 
 static const struct regulator_linear_range wm831x_gp_ldo_ranges[] = {
-	{ .min_uV =  900000, .max_uV = 1650000, .min_sel =  0, .max_sel = 14,
+	{ .min_uV =  900000, .max_uV = 1600000, .min_sel =  0, .max_sel = 14,
 	  .uV_step =  50000 },
 	{ .min_uV = 1700000, .max_uV = 3300000, .min_sel = 15, .max_sel = 31,
 	  .uV_step = 100000 },
@@ -320,7 +320,7 @@ static struct platform_driver wm831x_gp_ldo_driver = {
  */
 
 static const struct regulator_linear_range wm831x_aldo_ranges[] = {
-	{ .min_uV = 1000000, .max_uV = 1650000, .min_sel =  0, .max_sel = 12,
+	{ .min_uV = 1000000, .max_uV = 1600000, .min_sel =  0, .max_sel = 12,
 	  .uV_step =  50000 },
 	{ .min_uV = 1700000, .max_uV = 3500000, .min_sel = 13, .max_sel = 31,
 	  .uV_step = 100000 },
-- 
1.8.1.2



