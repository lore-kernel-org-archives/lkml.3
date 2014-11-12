Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaKLPBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:01:32 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:45183 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752377AbaKLPBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:01:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: robert.w.love@intel.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        fcoe-devel@open-fcoe.org
Subject: [PATCH 1/1] fcoe: use continue instead of goto+label
Date: Wed, 12 Nov 2014 16:01:26 +0100
Message-Id: <1415804486-15022-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a label pointing to the start of a while loop and a goto
nested only in the loop. The goto jumps to the label in some cases.
Replace the goto and the label by simple continue.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Robert Love <robert.w.love@intel.com>
Cc: fcoe-devel@open-fcoe.org
---
 drivers/scsi/fcoe/fcoe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4a8ac7d8c76b..f9eef51c9823 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1874,7 +1874,6 @@ static int fcoe_percpu_receive_thread(void *arg)
 
 	set_user_nice(current, MIN_NICE);
 
-retry:
 	while (!kthread_should_stop()) {
 
 		spin_lock_bh(&p->fcoe_rx_list.lock);
@@ -1884,7 +1883,7 @@ retry:
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_bh(&p->fcoe_rx_list.lock);
 			schedule();
-			goto retry;
+			continue;
 		}
 
 		spin_unlock_bh(&p->fcoe_rx_list.lock);
-- 
2.1.3

