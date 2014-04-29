Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaD2AWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:22:30 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55422 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaD2AW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:22:28 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: rric@kernel.org, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] oprofile: Fix format string mismatch in oprofile_perf.c
Date: Tue, 29 Apr 2014 09:22:20 +0900
Message-Id: <1398730940-2151-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in oprofile_perf_create_files.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/oprofile/oprofile_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index d5b2732..968e6dc 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -146,7 +146,7 @@ static int oprofile_perf_create_files(struct dentry *root)
 		struct dentry *dir;
 		char buf[4];
 
-		snprintf(buf, sizeof buf, "%d", i);
+		snprintf(buf, sizeof buf, "%u", i);
 		dir = oprofilefs_mkdir(root, buf);
 		oprofilefs_create_ulong(dir, "enabled", &counter_config[i].enabled);
 		oprofilefs_create_ulong(dir, "event", &counter_config[i].event);
-- 
2.0.0.rc1

