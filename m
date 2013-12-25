Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3LYQ6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 11:58:38 -0500
Received: from mail-gg0-f180.google.com ([209.85.161.180]:40544 "EHLO
	mail-gg0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3LYQ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 11:58:37 -0500
Date: Wed, 25 Dec 2013 08:58:34 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use __kernel_long_t in struct mq_attr
Message-ID: <20131225165834.GA1526@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

