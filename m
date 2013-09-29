Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3I2GPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:15:23 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47161 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3I2GOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:14:53 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/5] splice: Use sync wakeup for splice_from_pipe_next()
Date: Sun, 29 Sep 2013 15:14:37 +0900
Message-Id: <1380435278-10927-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
References: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sync wakeup is a hint to the scheduler that means a waker would go to
sleep right soon.  In splice_from_pipe_next(), it calls pipe_wait()
after calling wakeup_pipe_writers() so it'd be better using sync
wakeup rather than normal one.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 fs/splice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 0325e8b0d816..9fb7dc5ef061 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -872,7 +872,7 @@ int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_desc *sd)
 			return -ERESTARTSYS;
 
 		if (sd->need_wakeup) {
-			wakeup_pipe_writers(pipe, false);
+			wakeup_pipe_writers(pipe, true);
 			sd->need_wakeup = false;
 		}
 
-- 
1.7.9.2

