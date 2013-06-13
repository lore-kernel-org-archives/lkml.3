Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab3FMSe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:34:59 -0400
Received: from etezian.org ([198.101.225.253]:56452 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758890Ab3FMS27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:59 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 10/19] bh1770glc: use kstrtoul instead of strict_strtoul
Date: Thu, 13 Jun 2013 20:20:44 +0200
Message-Id: <1ced2fc1f90220249beb332801dcbbc34f8a251d.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kstrtoul() calls have been done by using base 0
up to now. This allowed hexadecimal and octal
entry on the sysfs interface.

Hexadecimal or octal entry is not required, nor
wanted for the proximity sensor.

The base is now changed to 10 in order to accept
only decimal numbers on the proximity sensor
sysfs interface.

Signed-off-by: Andi Shyti <andi@etezian.org>
Signed-off-by: Onur Atilla <oatilla@gmail.com>
---
 drivers/misc/bh1770glc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index bd90eaf..b5fc2b9 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -645,7 +645,7 @@ static ssize_t bh1770_power_state_store(struct device *dev,
 	unsigned long value;
 	ssize_t ret;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -744,7 +744,7 @@ static ssize_t bh1770_prox_enable_store(struct device *dev,
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -883,7 +883,7 @@ static ssize_t bh1770_set_prox_rate_above(struct device *dev,
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -899,7 +899,7 @@ static ssize_t bh1770_set_prox_rate_below(struct device *dev,
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -923,7 +923,7 @@ static ssize_t bh1770_set_prox_thres(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 	if (value > BH1770_PROX_RANGE)
 		return -EINVAL;
@@ -952,7 +952,7 @@ static ssize_t bh1770_prox_persistence_store(struct device *dev,
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	if (value > BH1770_PROX_MAX_PERSISTENCE)
@@ -977,7 +977,7 @@ static ssize_t bh1770_prox_abs_thres_store(struct device *dev,
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	if (value > BH1770_PROX_RANGE)
@@ -1022,7 +1022,7 @@ static ssize_t bh1770_lux_calib_store(struct device *dev,
 	u32 old_calib;
 	u32 new_corr;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -1084,7 +1084,7 @@ static ssize_t bh1770_set_lux_rate(struct device *dev,
 	unsigned long rate_hz;
 	int ret, i;
 
-	if (strict_strtoul(buf, 0, &rate_hz))
+	if (kstrtoul(buf, 10, &rate_hz))
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(lux_rates_hz) - 1; i++)
@@ -1122,7 +1122,7 @@ static ssize_t bh1770_set_lux_thresh(struct bh1770_chip *chip, u16 *target,
 	int ret = 0;
 	unsigned long thresh;
 
-	if (strict_strtoul(buf, 0, &thresh))
+	if (kstrtoul(buf, 10, &thresh))
 		return -EINVAL;
 
 	if (thresh > BH1770_LUX_RANGE)
-- 
1.7.10.4

