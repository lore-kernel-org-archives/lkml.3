Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3L0R0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:26:51 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:56171 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab3L0RZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:25:31 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 3/8] Use __kernel_ulong_t in uapi struct ipc64_perm
Date: Fri, 27 Dec 2013 09:25:07 -0800
Message-Id: <1388165112-6545-4-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X32 IPC system call is the same as x86-64 IPC system call, which uses
64-bit integer for unsigned long in struct ipc64_perm.  But x32 long is
32 bit.  This patch replaces unsigned long in uapi struct ipc64_perm with
__kernel_ulong_t if __BITS_PER_LONG == 64.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/asm-generic/ipcbuf.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/asm-generic/ipcbuf.h b/include/uapi/asm-generic/ipcbuf.h
index 76982b2..4635fa5 100644
--- a/include/uapi/asm-generic/ipcbuf.h
+++ b/include/uapi/asm-generic/ipcbuf.h
@@ -27,8 +27,13 @@ struct ipc64_perm {
 	unsigned char		__pad1[4 - sizeof(__kernel_mode_t)];
 	unsigned short		seq;
 	unsigned short		__pad2;
+#if __BITS_PER_LONG == 64
+	__kernel_ulong_t	__unused1;
+	__kernel_ulong_t	__unused2;
+#else
 	unsigned long		__unused1;
 	unsigned long		__unused2;
+#endif
 };
 
 #endif /* __ASM_GENERIC_IPCBUF_H */
-- 
1.8.4.2

