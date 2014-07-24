Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934805AbaGXKBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:01:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934641AbaGXJsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 093/128] hwmon: (amc6821) Fix permissions for temp2_input
Date: Thu, 24 Jul 2014 10:45:42 +0100
Message-Id: <1406195177-8656-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit df86754b746e9a0ff6f863f690b1c01d408e3cdc upstream.

temp2_input should not be writable, fix it.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/amc6821.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 4fe49d2bfe1d..09d2d78d482b 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -707,7 +707,7 @@ static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO,
 	get_temp_alarm, NULL, IDX_TEMP1_MAX);
 static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO,
 	get_temp_alarm, NULL, IDX_TEMP1_CRIT);
-static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO | S_IWUSR,
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO,
 	get_temp, NULL, IDX_TEMP2_INPUT);
 static SENSOR_DEVICE_ATTR(temp2_min, S_IRUGO | S_IWUSR, get_temp,
 	set_temp, IDX_TEMP2_MIN);
-- 
1.9.1

