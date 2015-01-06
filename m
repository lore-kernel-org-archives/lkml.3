Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbbAFQ3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:29:41 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61988 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbbAFQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:29:39 -0500
From: Valentin Rothberg <valentinrothberg@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Valentin Rothberg <valentinrothberg@gmail.com>
Subject: [PATCH] workqueue.h: remove loops of single statement macros
Date: Tue,  6 Jan 2015 17:29:29 +0100
Message-Id: <1420561769-28068-1-git-send-email-valentinrothberg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl complained about two single statement macros in
do while (0) loops.  The loops and the trailing semicolons are
now removed, which makes checkpatch happy and the two macros
consistent with the rest of the file.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
---
 include/linux/workqueue.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b996e6cd..74db135 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -220,14 +220,10 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 #endif
 
 #define INIT_WORK(_work, _func)						\
-	do {								\
-		__INIT_WORK((_work), (_func), 0);			\
-	} while (0)
+	__INIT_WORK((_work), (_func), 0)
 
 #define INIT_WORK_ONSTACK(_work, _func)					\
-	do {								\
-		__INIT_WORK((_work), (_func), 1);			\
-	} while (0)
+	__INIT_WORK((_work), (_func), 1)
 
 #define __INIT_DELAYED_WORK(_work, _func, _tflags)			\
 	do {								\
-- 
1.9.1

