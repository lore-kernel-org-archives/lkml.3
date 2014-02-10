Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaBJR2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:28:09 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42728 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaBJR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:28:07 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] block: Fix type mismatch in ssize_t_blk_mq_tag_sysfs_show
Date: Tue, 11 Feb 2014 02:27:58 +0900
Message-Id: <1392053278-2188-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck detected following format string mismatch.
[blk-mq-tag.c:201]: (warning) %u in format string (no. 1) requires
'unsigned int' but the argument type is 'int'.

Change "cpu" from int to unsigned int, because the cpu
never become minus value.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 block/blk-mq-tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 5d70edc..83ae96c 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -184,7 +184,7 @@ void blk_mq_free_tags(struct blk_mq_tags *tags)
 ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
 {
 	char *orig_page = page;
-	int cpu;
+	unsigned int cpu;
 
 	if (!tags)
 		return 0;
-- 
1.9.rc1

