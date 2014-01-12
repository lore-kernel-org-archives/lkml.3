Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbaALO2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 09:28:06 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:41949 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaALO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 09:28:05 -0500
From: Joe <cyborg101010@gmail.com>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, dan.carpenter@oracle.com, cruzjbishop@gmail.com,
        linux-kernel@vger.kernel.org, cyborg101010@gmail.com
Subject: [PATCH] AlarmDev: Changing is_wakeup() to be a function to pass checkpatch
Date: Sun, 12 Jan 2014 14:14:34 +0000
Message-Id: <1389536074-17145-1-git-send-email-cyborg101010@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/android/alarm-dev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 647694f..87f2a02 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -66,13 +66,15 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
  *
  * Return: 1 if this is a wakeup alarm, otherwise 0
  */
-static int is_wakeup(enum android_alarm_type type)
+static int is_wakeup(enum andriod_alarm_type type)
 {
-	return (type == ANDROID_ALARM_RTC_WAKEUP ||
-		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP);
+	if (type == ANDROID_ALARM_RTC_WAKEUP ||
+	    type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP)
+		return 1;
+	else
+		return 0;
 }
 
-
 static void devalarm_start(struct devalarm *alrm, ktime_t exp)
 {
 	if (is_wakeup(alrm->type))
-- 
1.8.3.2

