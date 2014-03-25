Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaCYRXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:23:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55993 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbaCYRW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:22:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 41/81] hwmon: (max1668) Fix writing the minimum temperature
Date: Tue, 25 Mar 2014 10:15:54 -0700
Message-Id: <1395767794-5012-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 500a91571f0a5d0d3242d83802ea2fd1faccc66e upstream.

When trying to set the minimum temperature, the driver was erroneously
writing the maximum temperature into the chip.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/max1668.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/max1668.c b/drivers/hwmon/max1668.c
index 666d9f6..4a9f3bc 100644
--- a/drivers/hwmon/max1668.c
+++ b/drivers/hwmon/max1668.c
@@ -243,7 +243,7 @@ static ssize_t set_temp_min(struct device *dev,
 	data->temp_min[index] = SENSORS_LIMIT(temp/1000, -128, 127);
 	if (i2c_smbus_write_byte_data(client,
 					MAX1668_REG_LIML_WR(index),
-					data->temp_max[index]))
+					data->temp_min[index]))
 		count = -EIO;
 	mutex_unlock(&data->update_lock);
 
-- 
1.8.3.2

