Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab3LZPvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:51:35 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:60556 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3LZPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:51:27 -0500
Date: Thu, 26 Dec 2013 07:51:23 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t in struct msgbuf
Message-ID: <20131226155123.GE23355@gmail.com>
References: <20131225155850.GA26252@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XvKFcGCOAo53UbWW"
Content-Disposition: inline
In-Reply-To: <20131225155850.GA26252@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 07:58:50AM -0800, H.J. Lu wrote:
> X32 msgsnd/msgrcv system calls are the same as x86-64 msgsnd/msgrcv system
> calls, which use 64-bit integer for long in struct msgbuf . But x32 long
> is 32 bit.  This patch replaces long in struct msgbuf with __kernel_long_t.
> 

Here is the updated patch which uses __kernel_long_t only if
__BITS_PER_LONG == 64. 
 
H.J.

--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0004-Use-__kernel_long_t-in-struct-msgbuf.patch"

>From a632b2db9ccab7560ae6696fd6e4ca2a42024b7b Mon Sep 17 00:00:00 2001
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 25 Dec 2013 07:55:28 -0800
Subject: [PATCH] Use __kernel_long_t in struct msgbuf

X32 msgsnd/msgrcv system calls are the same as x86-64 msgsnd/msgrcv system
calls, which use 64-bit integer for long in struct msgbuf . But x32 long
is 32 bit.  This patch replaces long in struct msgbuf with __kernel_long_t
if __BITS_PER_LONG == 64.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/linux/msg.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/msg.h b/include/uapi/linux/msg.h
index 22d95c6..6b6ec96 100644
--- a/include/uapi/linux/msg.h
+++ b/include/uapi/linux/msg.h
@@ -34,8 +34,12 @@ struct msqid_ds {
 
 /* message buffer for msgsnd and msgrcv calls */
 struct msgbuf {
-	long mtype;         /* type of message */
-	char mtext[1];      /* message text */
+#if __BITS_PER_LONG == 64
+	__kernel_long_t mtype;          /* type of message */
+#else
+	long mtype;                     /* type of message */
+#endif
+	char mtext[1];                  /* message text */
 };
 
 /* buffer for msgctl calls IPC_INFO, MSG_INFO */
-- 
1.8.4.2


--XvKFcGCOAo53UbWW--
