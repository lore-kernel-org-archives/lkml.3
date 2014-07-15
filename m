Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292AbaGOXO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:14:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792AbaGOXOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.15 16/84] hwmon: (adc128d818) Drop write support on inX_input attributes
Date: Tue, 15 Jul 2014 16:17:13 -0700
Message-Id: <20140715231713.685190197@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 7fe7381cbdadf16792e733789983690b3fa82880 upstream.

Writes into input registers doesn't make sense, even more so since
the writes actually ended up writing into the maximum limit registers.
Drop it.

Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/adc128d818.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/hwmon/adc128d818.c
+++ b/drivers/hwmon/adc128d818.c
@@ -239,50 +239,50 @@ static ssize_t adc128_show_alarm(struct
 	return sprintf(buf, "%u\n", !!(alarms & mask));
 }
 
-static SENSOR_DEVICE_ATTR_2(in0_input, S_IWUSR | S_IRUGO,
-			    adc128_show_in, adc128_set_in, 0, 0);
+static SENSOR_DEVICE_ATTR_2(in0_input, S_IRUGO,
+			    adc128_show_in, NULL, 0, 0);
 static SENSOR_DEVICE_ATTR_2(in0_min, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 0, 1);
 static SENSOR_DEVICE_ATTR_2(in0_max, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 0, 2);
 
-static SENSOR_DEVICE_ATTR_2(in1_input, S_IWUSR | S_IRUGO,
-			    adc128_show_in, adc128_set_in, 1, 0);
+static SENSOR_DEVICE_ATTR_2(in1_input, S_IRUGO,
+			    adc128_show_in, NULL, 1, 0);
 static SENSOR_DEVICE_ATTR_2(in1_min, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 1, 1);
 static SENSOR_DEVICE_ATTR_2(in1_max, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 1, 2);
 
-static SENSOR_DEVICE_ATTR_2(in2_input, S_IWUSR | S_IRUGO,
-			    adc128_show_in, adc128_set_in, 2, 0);
+static SENSOR_DEVICE_ATTR_2(in2_input, S_IRUGO,
+			    adc128_show_in, NULL, 2, 0);
 static SENSOR_DEVICE_ATTR_2(in2_min, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 2, 1);
 static SENSOR_DEVICE_ATTR_2(in2_max, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 2, 2);
 
-static SENSOR_DEVICE_ATTR_2(in3_input, S_IWUSR | S_IRUGO,
-			    adc128_show_in, adc128_set_in, 3, 0);
+static SENSOR_DEVICE_ATTR_2(in3_input, S_IRUGO,
+			    adc128_show_in, NULL, 3, 0);
 static SENSOR_DEVICE_ATTR_2(in3_min, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 3, 1);
 static SENSOR_DEVICE_ATTR_2(in3_max, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 3, 2);
 
-static SENSOR_DEVICE_ATTR_2(in4_input, S_IWUSR | S_IRUGO,
-			    adc128_show_in, adc128_set_in, 4, 0);
+static SENSOR_DEVICE_ATTR_2(in4_input, S_IRUGO,
+			    adc128_show_in, NULL, 4, 0);
 static SENSOR_DEVICE_ATTR_2(in4_min, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 4, 1);
 static SENSOR_DEVICE_ATTR_2(in4_max, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 4, 2);
 
-static SENSOR_DEVICE_ATTR_2(in5_input, S_IWUSR | S_IRUGO,
-			    adc128_show_in, adc128_set_in, 5, 0);
+static SENSOR_DEVICE_ATTR_2(in5_input, S_IRUGO,
+			    adc128_show_in, NULL, 5, 0);
 static SENSOR_DEVICE_ATTR_2(in5_min, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 5, 1);
 static SENSOR_DEVICE_ATTR_2(in5_max, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 5, 2);
 
-static SENSOR_DEVICE_ATTR_2(in6_input, S_IWUSR | S_IRUGO,
-			    adc128_show_in, adc128_set_in, 6, 0);
+static SENSOR_DEVICE_ATTR_2(in6_input, S_IRUGO,
+			    adc128_show_in, NULL, 6, 0);
 static SENSOR_DEVICE_ATTR_2(in6_min, S_IWUSR | S_IRUGO,
 			    adc128_show_in, adc128_set_in, 6, 1);
 static SENSOR_DEVICE_ATTR_2(in6_max, S_IWUSR | S_IRUGO,


