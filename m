Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3LZPyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:54:14 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:63964 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3LZPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:54:13 -0500
Date: Thu, 26 Dec 2013 07:54:10 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t in struct mq_attr
Message-ID: <20131226155410.GH23355@gmail.com>
References: <20131225165834.GA1526@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JbKQpFqZXJ2T76Sg"
Content-Disposition: inline
In-Reply-To: <20131225165834.GA1526@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 08:58:34AM -0800, H.J. Lu wrote:
> Both x32 and x86-64 use the same struct mq_attr for system calls.  But
> x32 long is 32-bit. This patch replaces long with __kernel_long_t in
> struct mq_attr.
> 

Here is the updated patch which uses __kernel_long_t only if
__BITS_PER_LONG == 64. 
 
H.J.

--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0008-Use-__kernel_long_t-in-struct-mq_attr.patch"

>From fc117a05dd0a4a9ec7e6ae286aac9433609ce155 Mon Sep 17 00:00:00 2001
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 25 Dec 2013 08:56:22 -0800
Subject: [PATCH] Use __kernel_long_t in struct mq_attr

Both x32 and x86-64 use the same struct mq_attr for system calls.  But
x32 long is 32-bit. This patch replaces long with __kernel_long_t in
struct mq_attr if __BITS_PER_LONG == 64.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/linux/mqueue.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/mqueue.h b/include/uapi/linux/mqueue.h
index 8b5a796..03bf30e 100644
--- a/include/uapi/linux/mqueue.h
+++ b/include/uapi/linux/mqueue.h
@@ -23,11 +23,19 @@
 #define MQ_BYTES_MAX	819200
 
 struct mq_attr {
-	long	mq_flags;	/* message queue flags			*/
-	long	mq_maxmsg;	/* maximum number of messages		*/
-	long	mq_msgsize;	/* maximum message size			*/
-	long	mq_curmsgs;	/* number of messages currently queued	*/
-	long	__reserved[4];	/* ignored for input, zeroed for output */
+#if __BITS_PER_LONG == 64
+	__kernel_long_t	mq_flags;	/* message queue flags			*/
+	__kernel_long_t	mq_maxmsg;	/* maximum number of messages		*/
+	__kernel_long_t	mq_msgsize;	/* maximum message size			*/
+	__kernel_long_t	mq_curmsgs;	/* number of messages currently queued	*/
+	__kernel_long_t	__reserved[4];	/* ignored for input, zeroed for output */
+#else
+	long	mq_flags;		/* message queue flags			*/
+	long	mq_maxmsg;		/* maximum number of messages		*/
+	long	mq_msgsize;		/* maximum message size			*/
+	long	mq_curmsgs;		/* number of messages currently queued	*/
+	long	__reserved[4];		/* ignored for input, zeroed for output */
+#endif
 };
 
 /*
-- 
1.8.4.2


--JbKQpFqZXJ2T76Sg--
