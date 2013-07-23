Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663Ab3GWW1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934598Ab3GWW1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 040/103] hwmon: (nct6775) Drop unsupported fan alarm attributes for NCT6775
Date: Tue, 23 Jul 2013 15:25:51 -0700
Message-Id: <20130723220423.060251183@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 41fa9a944fce1d7efd5ee3d50ac85b92f42dcc3d upstream.

NCT6775 does not support alarms for fans 4 and 5. Drop the attributes.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/nct6775.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -199,7 +199,7 @@ static const s8 NCT6775_ALARM_BITS[] = {
 	0, 1, 2, 3, 8, 21, 20, 16,	/* in0.. in7 */
 	17, -1, -1, -1, -1, -1, -1,	/* in8..in14 */
 	-1,				/* unused */
-	6, 7, 11, 10, 23,		/* fan1..fan5 */
+	6, 7, 11, -1, -1,		/* fan1..fan5 */
 	-1, -1, -1,			/* unused */
 	4, 5, 13, -1, -1, -1,		/* temp1..temp6 */
 	12, -1 };			/* intrusion0, intrusion1 */
@@ -3877,10 +3877,12 @@ static int nct6775_probe(struct platform
 						 &sda_fan_input[i].dev_attr);
 			if (err)
 				goto exit_remove;
-			err = device_create_file(dev,
-						 &sda_fan_alarm[i].dev_attr);
-			if (err)
-				goto exit_remove;
+			if (data->ALARM_BITS[FAN_ALARM_BASE + i] >= 0) {
+				err = device_create_file(dev,
+						&sda_fan_alarm[i].dev_attr);
+				if (err)
+					goto exit_remove;
+			}
 			if (data->kind != nct6776 &&
 			    data->kind != nct6779) {
 				err = device_create_file(dev,


