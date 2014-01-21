Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaAUFRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:17:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaAUFQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:16:51 -0500
Date: Mon, 20 Jan 2014 21:16:40 -0800
From: "tip-bot for H.J. Lu" <tipbot@zytor.com>
Message-ID: <tip-63159f5dcccb3858d88aaef800c4ee0eb4cc8577@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <1388182464-28428-9-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-9-git-send-email-hjl.tools@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] uapi: Use __kernel_long_t in struct mq_attr
Git-Commit-ID: 63159f5dcccb3858d88aaef800c4ee0eb4cc8577
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 20 Jan 2014 21:16:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63159f5dcccb3858d88aaef800c4ee0eb4cc8577
Gitweb:     http://git.kernel.org/tip/63159f5dcccb3858d88aaef800c4ee0eb4cc8577
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Fri, 27 Dec 2013 14:14:24 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Jan 2014 14:45:33 -0800

uapi: Use __kernel_long_t in struct mq_attr

Both x32 and x86-64 use the same struct mq_attr for system calls.  But
x32 long is 32-bit. This patch replaces long with __kernel_long_t in
struct mq_attr.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1388182464-28428-9-git-send-email-hjl.tools@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/uapi/linux/mqueue.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/mqueue.h b/include/uapi/linux/mqueue.h
index 8b5a796..d0a2b8e 100644
--- a/include/uapi/linux/mqueue.h
+++ b/include/uapi/linux/mqueue.h
@@ -23,11 +23,11 @@
 #define MQ_BYTES_MAX	819200
 
 struct mq_attr {
-	long	mq_flags;	/* message queue flags			*/
-	long	mq_maxmsg;	/* maximum number of messages		*/
-	long	mq_msgsize;	/* maximum message size			*/
-	long	mq_curmsgs;	/* number of messages currently queued	*/
-	long	__reserved[4];	/* ignored for input, zeroed for output */
+	__kernel_long_t	mq_flags;	/* message queue flags			*/
+	__kernel_long_t	mq_maxmsg;	/* maximum number of messages		*/
+	__kernel_long_t	mq_msgsize;	/* maximum message size			*/
+	__kernel_long_t	mq_curmsgs;	/* number of messages currently queued	*/
+	__kernel_long_t	__reserved[4];	/* ignored for input, zeroed for output */
 };
 
 /*
