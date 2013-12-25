Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab3LYPpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 10:45:47 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:34057 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3LYPpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 10:45:46 -0500
Date: Wed, 25 Dec 2013 07:45:41 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use __kernel_ulong_t in uapi struct ipc64_perm
Message-ID: <20131225154541.GA12109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X32 IPC system call is the same as x86-64 IPC system call, which uses
64-bit integer for unsigned long in struct ipc64_perm.  But x32 long is
32 bit.  This patch replaces unsigned long in uapi struct ipc64_perm with
__kernel_ulong_t.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/asm-generic/ipcbuf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/asm-generic/ipcbuf.h b/include/uapi/asm-generic/ipcbuf.h
index 76982b2..3dbcc1e 100644
--- a/include/uapi/asm-generic/ipcbuf.h
+++ b/include/uapi/asm-generic/ipcbuf.h
@@ -27,8 +27,8 @@ struct ipc64_perm {
 	unsigned char		__pad1[4 - sizeof(__kernel_mode_t)];
 	unsigned short		seq;
 	unsigned short		__pad2;
-	unsigned long		__unused1;
-	unsigned long		__unused2;
+	__kernel_ulong_t	__unused1;
+	__kernel_ulong_t	__unused2;
 };
 
 #endif /* __ASM_GENERIC_IPCBUF_H */
-- 
1.8.4.2

