Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaFWNbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:31:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60785 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbaFWN3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:29:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 07/21] kgr: trigger the first check earlier
Date: Mon, 23 Jun 2014 15:29:21 +0200
Message-Id: <1403530175-29217-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
References: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 10 seconds, not 30. This speeds up the whole process in most
scenarios.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/kgraft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index 9b832419e0fd..ce2f09f3b544 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -319,7 +319,7 @@ int kgr_start_patching(const struct kgr_patch *patch)
 	/*
 	 * give everyone time to exit kernel, and check after a while
 	 */
-	queue_delayed_work(kgr_wq, &kgr_work, KGR_TIMEOUT * HZ);
+	queue_delayed_work(kgr_wq, &kgr_work, 10 * HZ);
 
 	return 0;
 }
-- 
2.0.0

