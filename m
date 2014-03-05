Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbaCEOwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:52:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaCEOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 24/62] hwmon: (max1668) Fix writing the minimum temperature
Date: Wed,  5 Mar 2014 14:36:28 +0000
Message-Id: <1394030226-26652-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 500a91571f0a5d0d3242d83802ea2fd1faccc66e upstream.

When trying to set the minimum temperature, the driver was erroneously
writing the maximum temperature into the chip.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/max1668.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/max1668.c b/drivers/hwmon/max1668.c
index 335b183..f058886 100644
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
1.9.0

