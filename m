Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3HYKvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 06:51:24 -0400
Received: from numidia.opendz.org ([98.142.220.152]:41498 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab3HYKvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 06:51:23 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH] ath5k: debugfs: NULL-terminate strings
Date: Sun, 25 Aug 2013 11:50:49 +0100
Message-Id: <1377427849-13264-1-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid processing garbage data by NULL terminating the strings.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
Patch compile tested only.

 drivers/net/wireless/ath/ath5k/debug.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 9d00dab..b8d031a 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -245,9 +245,11 @@ static ssize_t write_file_beacon(struct file *file,
 	struct ath5k_hw *ah = file->private_data;
 	char buf[20];
 
-	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 
+	buf[count] = '\0';
 	if (strncmp(buf, "disable", 7) == 0) {
 		AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
 		pr_info("debugfs disable beacons\n");
@@ -345,9 +347,11 @@ static ssize_t write_file_debug(struct file *file,
 	unsigned int i;
 	char buf[20];
 
-	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 
+	buf[count] = '\0';
 	for (i = 0; i < ARRAY_SIZE(dbg_info); i++) {
 		if (strncmp(buf, dbg_info[i].name,
 					strlen(dbg_info[i].name)) == 0) {
@@ -448,9 +452,11 @@ static ssize_t write_file_antenna(struct file *file,
 	unsigned int i;
 	char buf[20];
 
-	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 
+	buf[count] = '\0';
 	if (strncmp(buf, "diversity", 9) == 0) {
 		ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
 		pr_info("debug: enable diversity\n");
@@ -619,9 +625,11 @@ static ssize_t write_file_frameerrors(struct file *file,
 	struct ath5k_statistics *st = &ah->stats;
 	char buf[20];
 
-	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 
+	buf[count] = '\0';
 	if (strncmp(buf, "clear", 5) == 0) {
 		st->rxerr_crc = 0;
 		st->rxerr_phy = 0;
@@ -766,9 +774,11 @@ static ssize_t write_file_ani(struct file *file,
 	struct ath5k_hw *ah = file->private_data;
 	char buf[20];
 
-	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 
+	buf[count] = '\0';
 	if (strncmp(buf, "sens-low", 8) == 0) {
 		ath5k_ani_init(ah, ATH5K_ANI_MODE_MANUAL_HIGH);
 	} else if (strncmp(buf, "sens-high", 9) == 0) {
@@ -862,9 +872,11 @@ static ssize_t write_file_queue(struct file *file,
 	struct ath5k_hw *ah = file->private_data;
 	char buf[20];
 
-	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+	count = min_t(size_t, count, sizeof(buf) - 1);
+	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 
+	buf[count] = '\0';
 	if (strncmp(buf, "start", 5) == 0)
 		ieee80211_wake_queues(ah->hw);
 	else if (strncmp(buf, "stop", 4) == 0)
-- 
1.7.11.7

