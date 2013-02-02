Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab3BBOwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:52:25 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47980 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab3BBOwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:52:23 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/6] f2fs: move out f2fs_balance_fs from gc_thread_func
Date: Sat,  2 Feb 2013 23:52:13 +0900
Message-Id: <1359816733-16286-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

When GC thread is running continously there is no need to call
f2fs_balance_fs unconditinally for garbage collection, instead
the garbage collection will be taken via. calling f2fs_gc in the
thread. So, we can move out the balance out of thread loop and
make it run initially when the thread is started.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 375e69e..66ac6ad 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -34,6 +34,8 @@ static int gc_thread_func(void *data)
 
 	wait_ms = GC_THREAD_MIN_SLEEP_TIME;
 
+	f2fs_balance_fs(sbi);
+
 	do {
 		if (try_to_freeze())
 			continue;
@@ -49,7 +51,6 @@ static int gc_thread_func(void *data)
 			continue;
 		}
 
-		f2fs_balance_fs(sbi);
 
 		if (!test_opt(sbi, BG_GC))
 			continue;
-- 
1.7.9.5

