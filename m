Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaG3MlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:41:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36655 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbaG3MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 25/94] hwmon: (adt7470) Fix writes to temperature limit registers
Date: Wed, 30 Jul 2014 14:14:14 +0200
Message-Id: <c37dcd9c0d05539c0ce3887373b5eabef74ab997.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit de12d6f4b10b21854441f5242dcb29ea96181e58 upstream.

Temperature limit registers are signed. Limits therefore need
to be clamped to (-128, 127) degrees C and not to (0, 255)
degrees C.

Without this fix, writing a limit of 128 degrees C sets the
actual limit to -128 degrees C.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/adt7470.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 0f4dea5ccf17..9ee3913850d6 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -515,7 +515,7 @@ static ssize_t set_temp_min(struct device *dev,
 		return -EINVAL;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
-	temp = clamp_val(temp, 0, 255);
+	temp = clamp_val(temp, -128, 127);
 
 	mutex_lock(&data->lock);
 	data->temp_min[attr->index] = temp;
@@ -549,7 +549,7 @@ static ssize_t set_temp_max(struct device *dev,
 		return -EINVAL;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
-	temp = clamp_val(temp, 0, 255);
+	temp = clamp_val(temp, -128, 127);
 
 	mutex_lock(&data->lock);
 	data->temp_max[attr->index] = temp;
@@ -826,7 +826,7 @@ static ssize_t set_pwm_tmin(struct device *dev,
 		return -EINVAL;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
-	temp = clamp_val(temp, 0, 255);
+	temp = clamp_val(temp, -128, 127);
 
 	mutex_lock(&data->lock);
 	data->pwm_tmin[attr->index] = temp;
-- 
2.0.1

