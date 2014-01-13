Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaAMUKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:10:47 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60799 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaAMUKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:10:42 -0500
From: Joe Borg <cyborg101010@gmail.com>
To: dan.carpenter@oracle.com
Cc: cyborg101010@gmail.com, abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] AlarmDev: Changing is_wakeup() to be a function to pass checkpatch
Date: Mon, 13 Jan 2014 20:10:36 +0000
Message-Id: <1389643836-6170-1-git-send-email-cyborg101010@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by Joe Borg <cyborg101010@gmail.com>
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
1.8.5.2

