Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935676AbaDJSoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:44:08 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33932 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbaDJSoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:44:04 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: npajkovs@redhat.com, akpm@linux-foundation.org
Subject: [PATCH 02/15] ipc:msg.c same indent for switch/case
Date: Thu, 10 Apr 2014 19:43:59 +0100
Message-Id: <1397155439-6361-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: switch and case should be at the same indent

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/msg.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index a385372..45c6360 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -612,23 +612,22 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 
 static int testmsg(struct msg_msg *msg, long type, int mode)
 {
-	switch (mode)
-	{
-		case SEARCH_ANY:
-		case SEARCH_NUMBER:
+	switch (mode) {
+	case SEARCH_ANY:
+	case SEARCH_NUMBER:
+		return 1;
+	case SEARCH_LESSEQUAL:
+		if (msg->m_type <= type)
 			return 1;
-		case SEARCH_LESSEQUAL:
-			if (msg->m_type <= type)
-				return 1;
-			break;
-		case SEARCH_EQUAL:
-			if (msg->m_type == type)
-				return 1;
-			break;
-		case SEARCH_NOTEQUAL:
-			if (msg->m_type != type)
-				return 1;
-			break;
+		break;
+	case SEARCH_EQUAL:
+		if (msg->m_type == type)
+			return 1;
+		break;
+	case SEARCH_NOTEQUAL:
+		if (msg->m_type != type)
+			return 1;
+		break;
 	}
 	return 0;
 }
-- 
1.8.3.2

