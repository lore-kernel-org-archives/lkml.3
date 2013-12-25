Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3LYQIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 11:08:12 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:50993 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3LYQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 11:08:11 -0500
Date: Wed, 25 Dec 2013 08:08:07 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use __kernel_ulong_t in struct msqid64_ds
Message-ID: <20131225160807.GA32441@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x32 and x86-64 use the same struct msqid64_ds for system calls.
But x32 long is 32-bit. This patch replaces unsigned long with
__kernel_ulong_t in struct msqid64_ds.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/asm-generic/msgbuf.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/asm-generic/msgbuf.h b/include/uapi/asm-generic/msgbuf.h
index aec850d..f55ecc4 100644
--- a/include/uapi/asm-generic/msgbuf.h
+++ b/include/uapi/asm-generic/msgbuf.h
@@ -35,13 +35,13 @@ struct msqid64_ds {
 #if __BITS_PER_LONG != 64
 	unsigned long	__unused3;
 #endif
-	unsigned long  msg_cbytes;	/* current number of bytes on queue */
-	unsigned long  msg_qnum;	/* number of messages in queue */
-	unsigned long  msg_qbytes;	/* max number of bytes on queue */
+	__kernel_ulong_t msg_cbytes;	/* current number of bytes on queue */
+	__kernel_ulong_t msg_qnum;	/* number of messages in queue */
+	__kernel_ulong_t msg_qbytes;	/* max number of bytes on queue */
 	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
 	__kernel_pid_t msg_lrpid;	/* last receive pid */
-	unsigned long  __unused4;
-	unsigned long  __unused5;
+	__kernel_ulong_t __unused4;
+	__kernel_ulong_t __unused5;
 };
 
 #endif /* __ASM_GENERIC_MSGBUF_H */
-- 
1.8.4.2

