Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3L0WOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:14:53 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:38547 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab3L0WOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:14:35 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 8/8] Use __kernel_long_t in struct mq_attr
Date: Fri, 27 Dec 2013 14:14:24 -0800
Message-Id: <1388182464-28428-9-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x32 and x86-64 use the same struct mq_attr for system calls.  But
x32 long is 32-bit. This patch replaces long with __kernel_long_t in
struct mq_attr.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
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
-- 
1.8.4.2

