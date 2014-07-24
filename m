Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887AbaGXJ4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:56:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55151 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783AbaGXJtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 109/128] hwmon: (emc2103) Fix return value
Date: Thu, 24 Jul 2014 10:45:58 +0100
Message-Id: <1406195177-8656-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 1a3abbd0b9a16e40fd4718f99896c437a193c0a1 upstream.

kstrtol() returns appropriate error values. Use those instead of
hardcoding. Silences several sparse messages of following type:
"why not propagate 'result' from kstrtol() instead of (-22)?"

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Steve Glendinning <steve.glendinning@shawell.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/emc2103.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index b07305622087..2c137b26acb4 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -248,7 +248,7 @@ static ssize_t set_temp_min(struct device *dev, struct device_attribute *da,
 
 	int result = kstrtol(buf, 10, &val);
 	if (result < 0)
-		return -EINVAL;
+		return result;
 
 	val = DIV_ROUND_CLOSEST(val, 1000);
 	if ((val < -63) || (val > 127))
@@ -272,7 +272,7 @@ static ssize_t set_temp_max(struct device *dev, struct device_attribute *da,
 
 	int result = kstrtol(buf, 10, &val);
 	if (result < 0)
-		return -EINVAL;
+		return result;
 
 	val = DIV_ROUND_CLOSEST(val, 1000);
 	if ((val < -63) || (val > 127))
@@ -320,7 +320,7 @@ static ssize_t set_fan_div(struct device *dev, struct device_attribute *da,
 
 	int status = kstrtol(buf, 10, &new_div);
 	if (status < 0)
-		return -EINVAL;
+		return status;
 
 	if (new_div == old_div) /* No change */
 		return count;
@@ -394,7 +394,7 @@ static ssize_t set_fan_target(struct device *dev, struct device_attribute *da,
 
 	int result = kstrtol(buf, 10, &rpm_target);
 	if (result < 0)
-		return -EINVAL;
+		return result;
 
 	/* Datasheet states 16384 as maximum RPM target (table 3.2) */
 	if ((rpm_target < 0) || (rpm_target > 16384))
@@ -440,7 +440,7 @@ static ssize_t set_pwm_enable(struct device *dev, struct device_attribute *da,
 
 	int result = kstrtol(buf, 10, &new_value);
 	if (result < 0)
-		return -EINVAL;
+		return result;
 
 	mutex_lock(&data->update_lock);
 	switch (new_value) {
-- 
1.9.1

