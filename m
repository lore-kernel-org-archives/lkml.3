Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaGLT4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 15:56:13 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64154 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaGLT4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 15:56:10 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: gregkh@linuxfoundation.org, swetland@google.com, daniel@ffwll.ch,
        maarten.lankhorst@canonical.com, john.stultz@linaro.org,
        sumit.semwal@linaro.org, peter.senna@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: android: Cleanup style issues
Date: Sat, 12 Jul 2014 21:55:56 +0200
Message-Id: <1405194956-4590-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch warnings:
 - Remove else after return
 - Add space after declaration

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/staging/android/sync_debug.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/sync_debug.c b/drivers/staging/android/sync_debug.c
index a9f7fd5..257fc91 100644
--- a/drivers/staging/android/sync_debug.c
+++ b/drivers/staging/android/sync_debug.c
@@ -74,10 +74,11 @@ static const char *sync_status_str(int status)
 {
 	if (status == 0)
 		return "signaled";
-	else if (status > 0)
+
+	if (status > 0)
 		return "active";
-	else
-		return "error";
+
+	return "error";
 }
 
 static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
@@ -95,12 +96,14 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
 
 	if (status <= 0) {
 		struct timeval tv = ktime_to_timeval(pt->base.timestamp);
+
 		seq_printf(s, "@%ld.%06ld", tv.tv_sec, tv.tv_usec);
 	}
 
 	if (parent->ops->timeline_value_str &&
 	    parent->ops->pt_value_str) {
 		char value[64];
+
 		parent->ops->pt_value_str(pt, value, sizeof(value));
 		seq_printf(s, ": %s", value);
 		if (fence) {
@@ -122,6 +125,7 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
 
 	if (obj->ops->timeline_value_str) {
 		char value[64];
+
 		obj->ops->timeline_value_str(obj, value, sizeof(value));
 		seq_printf(s, ": %s", value);
 	}
@@ -234,6 +238,7 @@ void sync_dump(void)
 	for (i = 0; i < s.count; i += DUMP_CHUNK) {
 		if ((s.count - i) > DUMP_CHUNK) {
 			char c = s.buf[i + DUMP_CHUNK];
+
 			s.buf[i + DUMP_CHUNK] = 0;
 			pr_cont("%s", s.buf + i);
 			s.buf[i + DUMP_CHUNK] = c;
-- 
1.9.3

