Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaIHNi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:38:29 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49545 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaIHNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:38:27 -0400
From: Dmitry Voytik <voytikd@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        linux-kernel@vger.kernel.org, Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH] staging: binder: fix coding style issues
Date: Mon,  8 Sep 2014 17:37:47 +0400
Message-Id: <1410183467-13504-1-git-send-email-voytikd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issues:
* put braces in all if-else branches;
* limit the length of changed lines to 80 columns.
checkpatch.pl warning count reduces by 3.

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
---
 drivers/staging/android/binder.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 4f34dc0..b7d6b3a 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2198,12 +2198,16 @@ retry:
 		struct binder_work *w;
 		struct binder_transaction *t = NULL;
 
-		if (!list_empty(&thread->todo))
-			w = list_first_entry(&thread->todo, struct binder_work, entry);
-		else if (!list_empty(&proc->todo) && wait_for_proc_work)
-			w = list_first_entry(&proc->todo, struct binder_work, entry);
-		else {
-			if (ptr - buffer == 4 && !(thread->looper & BINDER_LOOPER_STATE_NEED_RETURN)) /* no data added */
+		if (!list_empty(&thread->todo)) {
+			w = list_first_entry(&thread->todo, struct binder_work,
+						entry);
+		} else if (!list_empty(&proc->todo) && wait_for_proc_work) {
+			w = list_first_entry(&proc->todo, struct binder_work,
+						entry);
+		} else {
+			/* no data added */
+			if (ptr - buffer == 4 && !(thread->looper &
+					BINDER_LOOPER_STATE_NEED_RETURN))
 				goto retry;
 			break;
 		}
-- 
1.9.1

