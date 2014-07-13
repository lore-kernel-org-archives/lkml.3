Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaGMOz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:55:29 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:39216 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaGMOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:55:21 -0400
Date: Sun, 13 Jul 2014 11:49:29 -0300
From: Lucas Tanure <tanure@linux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] staging: android: Clean up binder_send_failed_reply
Message-ID: <20140713144929.GA6656@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel coding style. Remove useless else statement after return.

Signed-off-by: Lucas Tanure <tanure@linux.com>
---
 drivers/staging/android/binder.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 14714a6..67c9847 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1210,24 +1210,23 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 					target_thread->return_error);
 			}
 			return;
-		} else {
-			struct binder_transaction *next = t->from_parent;
+		}
+		struct binder_transaction *next = t->from_parent;
 
-			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-				     "send failed reply for transaction %d, target dead\n",
-				     t->debug_id);
+		binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
+			"send failed reply for transaction %d, target dead\n",
+			t->debug_id);
 
-			binder_pop_transaction(target_thread, t);
-			if (next == NULL) {
-				binder_debug(BINDER_DEBUG_DEAD_BINDER,
-					     "reply failed, no target thread at root\n");
-				return;
-			}
-			t = next;
+		binder_pop_transaction(target_thread, t);
+		if (next == NULL) {
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "reply failed, no target thread -- retry %d\n",
-				      t->debug_id);
+				     "reply failed, no target thread at root\n");
+			return;
 		}
+		t = next;
+		binder_debug(BINDER_DEBUG_DEAD_BINDER,
+			     "reply failed, no target thread -- retry %d\n",
+			      t->debug_id);
 	}
 }
 
-- 
2.0.1

