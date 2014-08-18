Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaHRJeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:34:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42520 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaHRJeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 025/137] hwmon: (adt7470) Fix writes to temperature limit registers
Date: Mon, 18 Aug 2014 10:31:26 +0100
Message-Id: <1408354398-10226-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit de12d6f4b10b21854441f5242dcb29ea96181e58 upstream.

Temperature limit registers are signed. Limits therefore need
to be clamped to (-128, 127) degrees C and not to (0, 255)
degrees C.

Without this fix, writing a limit of 128 degrees C sets the
actual limit to -128 degrees C.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/adt7470.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 6099f50b28aa..8013bb311486 100644
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
1.9.1

