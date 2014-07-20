Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaGTSYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 14:24:18 -0400
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:41108 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753167AbaGTSYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 14:24:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:560:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3868:3874:4385:5007:6261:7901:7903:9010:10004:10026:10848:11026:11473:11658:11914:12043:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brass01_5f08ad194754a
X-Filterd-Recvd-Size: 2346
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Teigland <teigland@redhat.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] dlm: plock: Reduce indentation by rearranging order
Date: Sun, 20 Jul 2014 11:23:42 -0700
Message-Id: <f0e69e54dd8036834e47ccfafc3b8b06060f3ef1.1405879494.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405879494.git.joe@perches.com>
References: <cover.1405879494.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if blocks that have a goto at the end of one branch can be
simplified by reordering and unindenting.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/dlm/plock.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index e0ab3a9..3e0b6fc 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -144,23 +144,23 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 
 	send_op(op);
 
-	if (xop->callback == NULL) {
-		rv = wait_event_killable(recv_wq, (op->done != 0));
-		if (rv == -ERESTARTSYS) {
-			log_debug(ls, "dlm_posix_lock: wait killed %llx",
-				  (unsigned long long)number);
-			spin_lock(&ops_lock);
-			list_del(&op->list);
-			spin_unlock(&ops_lock);
-			kfree(xop);
-			do_unlock_close(ls, number, file, fl);
-			goto out;
-		}
-	} else {
+	if (xop->callback) {
 		rv = FILE_LOCK_DEFERRED;
 		goto out;
 	}
 
+	rv = wait_event_killable(recv_wq, (op->done != 0));
+	if (rv == -ERESTARTSYS) {
+		log_debug(ls, "dlm_posix_lock: wait killed %llx",
+			  (unsigned long long)number);
+		spin_lock(&ops_lock);
+		list_del(&op->list);
+		spin_unlock(&ops_lock);
+		kfree(xop);
+		do_unlock_close(ls, number, file, fl);
+		goto out;
+	}
+
 	spin_lock(&ops_lock);
 	if (!list_empty(&op->list)) {
 		log_error(ls, "dlm_posix_lock: op on list %llx",
-- 
1.8.1.2.459.gbcd45b4.dirty

