Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaFYLJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:09:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41120 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Libor Pechacek <lpechacek@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -repost 20/21] kgr: rephrase the "kGraft failed" message
Date: Wed, 25 Jun 2014 13:07:14 +0200
Message-Id: <1403694435-3180-20-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libor Pechacek <lpechacek@suse.cz>

kGraft not succeeding on the first attempt can hardly be called a
failure.  kGraft is merely waiting for sleeping processes to wake up
and get out of the way.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/kgraft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index 1247f1c60b09..90ef7fba6d0a 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -108,7 +108,7 @@ static void kgr_finalize(void)
 static void kgr_work_fn(struct work_struct *work)
 {
 	if (kgr_still_patching()) {
-		pr_info("kgr failed after timeout (%d), still in degraded mode\n",
+		pr_info("kgr still in progress after timeout (%d)\n",
 			KGR_TIMEOUT);
 		/* recheck again later */
 		queue_delayed_work(kgr_wq, &kgr_work, KGR_TIMEOUT * HZ);
-- 
2.0.0

