Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422748AbaD3OcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:32:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52344 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759225AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 07/16] kgr: trigger the first check earlier
Date: Wed, 30 Apr 2014 16:30:40 +0200
Message-Id: <1398868249-26169-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
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
 kernel/kgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kgr.c b/kernel/kgr.c
index 6f55c7654618..5e9a07faddb9 100644
--- a/kernel/kgr.c
+++ b/kernel/kgr.c
@@ -281,7 +281,7 @@ int kgr_start_patching(const struct kgr_patch *patch)
 	/*
 	 * give everyone time to exit kernel, and check after a while
 	 */
-	queue_delayed_work(kgr_wq, &kgr_work, KGR_TIMEOUT * HZ);
+	queue_delayed_work(kgr_wq, &kgr_work, 5 * HZ);
 
 	return 0;
 }
-- 
1.9.2

