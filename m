Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3LYP6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 10:58:55 -0500
Received: from mail-gg0-f181.google.com ([209.85.161.181]:62221 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3LYP6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 10:58:54 -0500
X-Greylist: delayed 56030 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Dec 2013 10:58:54 EST
Date: Wed, 25 Dec 2013 07:58:50 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use __kernel_long_t in struct msgbuf
Message-ID: <20131225155850.GA26252@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

