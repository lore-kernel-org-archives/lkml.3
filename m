Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3CNKiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:38:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab3CNKiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 65/88] hwmon: (pmbus/ltc2978) Use detected chip ID to select supported functionality
Date: Thu, 14 Mar 2013 10:35:58 +0000
Message-Id: <1363257381-15900-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit f366fccd0809f13ba20d64cae3c83f7338c88af7 upstream.

We read the chip ID from the chip, use it to determine if the chip ID provided
to the driver is correct, and report it if wrong. We should also use the
correct chip ID to select supported functionality.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/pmbus/ltc2978.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index cc29a7e..a58de38 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -326,7 +326,7 @@ static int ltc2978_probe(struct i2c_client *client,
 	data->temp_max = 0x7c00;
 	data->temp2_max = 0x7c00;
 
-	switch (id->driver_data) {
+	switch (data->id) {
 	case ltc2978:
 		info->read_word_data = ltc2978_read_word_data;
 		info->pages = 8;
-- 
1.8.1.2

