Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaAUFRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:17:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58430 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaAUFQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:16:14 -0500
Date: Mon, 20 Jan 2014 21:16:04 -0800
From: "tip-bot for H.J. Lu" <tipbot@zytor.com>
Message-ID: <tip-443d5670f77aab121cb95f45da60f0aad390bcb5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <1388182464-28428-5-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-5-git-send-email-hjl.tools@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] uapi: Use __kernel_long_t in struct msgbuf
Git-Commit-ID: 443d5670f77aab121cb95f45da60f0aad390bcb5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 20 Jan 2014 21:16:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  443d5670f77aab121cb95f45da60f0aad390bcb5
Gitweb:     http://git.kernel.org/tip/443d5670f77aab121cb95f45da60f0aad390bcb5
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Fri, 27 Dec 2013 14:14:20 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Jan 2014 14:44:50 -0800

uapi: Use __kernel_long_t in struct msgbuf

x32 msgsnd/msgrcv system calls are the same as x86-64 msgsnd/msgrcv system
calls, which use 64-bit integer for long in struct msgbuf . But x32 long
is 32 bit.  This patch replaces long in struct msgbuf with __kernel_long_t.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1388182464-28428-5-git-send-email-hjl.tools@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
