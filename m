Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaE1IxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:53:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34901 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaE1IxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:53:22 -0400
From: Scott Weir <sjw0410@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: fix Missing a blank line after declarations warnings
Date: Wed, 28 May 2014 18:52:51 +1000
Message-Id: <1401267171-4106-1-git-send-email-sjw0410@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects coding style issue:
WARNING: Missing a black line after declarations

Signed-off-by: Scott Weir <sjw0410@gmail.com>
---
 drivers/staging/android/sync_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/android/sync_debug.c b/drivers/staging/android/sync_debug.c
index 00efaf9..2dd3fcc 100644
--- a/drivers/staging/android/sync_debug.c
+++ b/drivers/staging/android/sync_debug.c
@@ -95,12 +95,14 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
 
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
@@ -122,6 +124,7 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
 
 	if (obj->ops->timeline_value_str) {
 		char value[64];
+
 		obj->ops->timeline_value_str(obj, value, sizeof(value));
 		seq_printf(s, ": %s", value);
 	}
@@ -234,6 +237,7 @@ void sync_dump(void)
 	for (i = 0; i < s.count; i += DUMP_CHUNK) {
 		if ((s.count - i) > DUMP_CHUNK) {
 			char c = s.buf[i + DUMP_CHUNK];
+
 			s.buf[i + DUMP_CHUNK] = 0;
 			pr_cont("%s", s.buf + i);
 			s.buf[i + DUMP_CHUNK] = c;
-- 
1.9.1

