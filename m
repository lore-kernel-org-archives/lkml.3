Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3L0WRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:17:19 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:48164 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3L0WOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:14:32 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 4/8] Use __kernel_long_t in struct msgbuf
Date: Fri, 27 Dec 2013 14:14:20 -0800
Message-Id: <1388182464-28428-5-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X32 msgsnd/msgrcv system calls are the same as x86-64 msgsnd/msgrcv system
calls, which use 64-bit integer for long in struct msgbuf . But x32 long
is 32 bit.  This patch replaces long in struct msgbuf with __kernel_long_t.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/linux/msg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/msg.h b/include/uapi/linux/msg.h
index 22d95c6..a703755 100644
--- a/include/uapi/linux/msg.h
+++ b/include/uapi/linux/msg.h
@@ -34,8 +34,8 @@ struct msqid_ds {
 
 /* message buffer for msgsnd and msgrcv calls */
 struct msgbuf {
-	long mtype;         /* type of message */
-	char mtext[1];      /* message text */
+	__kernel_long_t mtype;          /* type of message */
+	char mtext[1];                  /* message text */
 };
 
 /* buffer for msgctl calls IPC_INFO, MSG_INFO */
-- 
1.8.4.2

