Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaAOWLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:11:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41325 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaAOV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Carnes <bmcarnes@gmail.com>, Jean Delvare <khali@linux-fr.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 046/166] hwmon: (w83l786ng) Fix fan speed control mode setting and reporting
Date: Wed, 15 Jan 2014 13:51:00 -0800
Message-Id: <1389822780-4729-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Carnes <bmcarnes@gmail.com>

commit cf7559bc053471f32373d71d04a9aa19e0b48d59 upstream.

The wrong mask is used, which causes some fan speed control modes
(pwmX_enable) to be incorrectly reported, and some modes to be
impossible to set.

[JD: add subject and description.]

Signed-off-by: Brian Carnes <bmcarnes@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/w83l786ng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index 79710bc..c7514e0 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -511,7 +511,7 @@ store_pwm_enable(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->update_lock);
 	reg = w83l786ng_read_value(client, W83L786NG_REG_FAN_CFG);
 	data->pwm_enable[nr] = val;
-	reg &= ~(0x02 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
+	reg &= ~(0x03 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
 	reg |= (val - 1) << W83L786NG_PWM_ENABLE_SHIFT[nr];
 	w83l786ng_write_value(client, W83L786NG_REG_FAN_CFG, reg);
 	mutex_unlock(&data->update_lock);
@@ -777,7 +777,7 @@ static struct w83l786ng_data *w83l786ng_update_device(struct device *dev)
 			    ((pwmcfg >> W83L786NG_PWM_MODE_SHIFT[i]) & 1)
 			    ? 0 : 1;
 			data->pwm_enable[i] =
-			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 2) + 1;
+			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 3) + 1;
 			data->pwm[i] = w83l786ng_read_value(client,
 			    W83L786NG_REG_PWM[i]);
 		}
-- 
1.8.3.2

