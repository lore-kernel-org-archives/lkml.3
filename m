Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbaFZRPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:15:52 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:26992 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043AbaFZRPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:15:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak8KAKhUrFNXQz8N/2dsb2JhbABagw2rRQUBAQEBAQEFAW2Yf4ENF3WEYCOBAhg3iC4DFQG7Lg2GUBeFZIZ3giUdhC0FmFyBfYs6giyGD4IAgUQ7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/1] kernel/trace/trace.c: remove unnecessary null test before debugfs_remove
Date: Thu, 26 Jun 2014 19:14:31 +0200
Message-Id: <1403802871-8599-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes checkpatch warning:

"WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/trace/trace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 384ede3..58c78e4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6095,10 +6095,8 @@ destroy_trace_option_files(struct trace_option_dentry *topts)
 	if (!topts)
 		return;
 
-	for (cnt = 0; topts[cnt].opt; cnt++) {
-		if (topts[cnt].entry)
-			debugfs_remove(topts[cnt].entry);
-	}
+	for (cnt = 0; topts[cnt].opt; cnt++)
+		debugfs_remove(topts[cnt].entry);
 
 	kfree(topts);
 }
-- 
1.8.4.5

