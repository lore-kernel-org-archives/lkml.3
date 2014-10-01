Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaI3Qpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:45:40 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62093 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaI3Qpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:45:38 -0400
From: Somya Anand <somyaanand214@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Somya Anand <somyaanand214@gmail.com>
Subject: [PATCH] Staging: Android: alarm-dev: Fixed a y2038 issue
Date: Wed,  1 Oct 2014 22:16:26 +0530
Message-Id: <1412181986-4507-1-git-send-email-somyaanand214@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed y2038 issue by replacing timespec with timespec64.

Signed-off-by: Somya Anand <somyaanand214@gmail.com>
---
 drivers/staging/android/alarm-dev.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index ff4b3e8..ba8acf4 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/miscdevice.h>
@@ -113,7 +114,7 @@ static void alarm_clear(enum android_alarm_type alarm_type)
 }
 
 static void alarm_set(enum android_alarm_type alarm_type,
-							struct timespec *ts)
+							struct timespec64 *ts)
 {
 	uint32_t alarm_type_mask = 1U << alarm_type;
 	unsigned long flags;
@@ -152,7 +153,7 @@ static int alarm_wait(void)
 	return rv;
 }
 
-static int alarm_set_rtc(struct timespec *ts)
+static int alarm_set_rtc(struct timespec64 *ts)
 {
 	struct rtc_time new_rtc_tm;
 	struct rtc_device *rtc_dev;
@@ -176,7 +177,7 @@ static int alarm_set_rtc(struct timespec *ts)
 }
 
 static int alarm_get_time(enum android_alarm_type alarm_type,
-							struct timespec *ts)
+							struct timespec64 *ts)
 {
 	int rv = 0;
 
@@ -199,7 +200,7 @@ static int alarm_get_time(enum android_alarm_type alarm_type,
 }
 
 static long alarm_do_ioctl(struct file *file, unsigned int cmd,
-							struct timespec *ts)
+							struct timespec64 *ts)
 {
 	int rv = 0;
 	unsigned long flags;
@@ -253,7 +254,7 @@ static long alarm_do_ioctl(struct file *file, unsigned int cmd,
 static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 
-	struct timespec ts;
+	struct timespec64 ts;
 	int rv;
 
 	switch (ANDROID_ALARM_BASE_CMD(cmd)) {
@@ -284,7 +285,7 @@ static long alarm_compat_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 
-	struct timespec ts;
+	struct timespec64 ts;
 	int rv;
 
 	switch (ANDROID_ALARM_BASE_CMD(cmd)) {
-- 
1.9.1

