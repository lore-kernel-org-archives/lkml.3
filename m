Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbaFYLJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:09:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41092 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755297AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -repost 07/21] kgr: trigger the first check earlier
Date: Wed, 25 Jun 2014 13:07:01 +0200
Message-Id: <1403694435-3180-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 5 seconds, not 30. This speeds up the whole process in most
scenarios.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/kgraft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index 9b832419e0fd..b0c712e8297c 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -319,7 +319,7 @@ int kgr_start_patching(const struct kgr_patch *patch)
 	/*
 	 * give everyone time to exit kernel, and check after a while
 	 */
-	queue_delayed_work(kgr_wq, &kgr_work, KGR_TIMEOUT * HZ);
+	queue_delayed_work(kgr_wq, &kgr_work, 5 * HZ);
 
 	return 0;
 }
-- 
2.0.0

