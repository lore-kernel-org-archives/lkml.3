Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965906Ab3DRGxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 02:53:04 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42209 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3DRGxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 02:53:02 -0400
Message-ID: <1366267975.28606.1.camel@phoenix>
Subject: [PATCH] regulator: Remove unnecessary include of linux/delay.h from
 regulator drivers
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 18 Apr 2013 14:52:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the drivers that need delay for the regulator voltage output voltage to
stabilize after being enabled or after being set to a new value has been
converted to implement enable_time and set_voltage_time_sel callbacks.
Then regulator core will take care of the necessary delay.

This patch removes the unneeded include of linux/delay.h in regulator drivers.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>
---
 drivers/regulator/lp8755.c   |    1 -
 drivers/regulator/max77686.c |    1 -
 drivers/regulator/s2mps11.c  |    1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index f0f6ea0..d9e38b4 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -19,7 +19,6 @@
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
 #include <linux/regmap.h>
-#include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index e4586ee..6a76833 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -24,7 +24,6 @@
 
 #include <linux/kernel.h>
 #include <linux/bug.h>
-#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index cd9ea2e..c9f16e1 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/bug.h>
-#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
-- 
1.7.10.4



