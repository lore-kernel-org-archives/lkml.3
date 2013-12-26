Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3LZPjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:39:04 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:46849 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3LZPjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:39:03 -0500
Date: Thu, 26 Dec 2013 07:38:59 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_ulong_t in uapi struct ipc64_perm
Message-ID: <20131226153859.GD23355@gmail.com>
References: <20131225154541.GA12109@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <20131225154541.GA12109@gmail.com>
Toc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 07:45:41AM -0800, H.J. Lu wrote:
> X32 IPC system call is the same as x86-64 IPC system call, which uses
> 64-bit integer for unsigned long in struct ipc64_perm.  But x32 long is
> 32 bit.  This patch replaces unsigned long in uapi struct ipc64_perm with
> __kernel_ulong_t.
> 

Here is the updated patch which uses __kernel_ulong_t only if
__BITS_PER_LONG == 64. 
 
H.J.

--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-Use-__kernel_ulong_t-in-uapi-struct-ipc64_perm.patch"

>From 81b4c3c55f994d54eafcaf4adaa2a16786c41fdd Mon Sep 17 00:00:00 2001
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 25 Dec 2013 07:13:02 -0800
Subject: [PATCH] Use __kernel_ulong_t in uapi struct ipc64_perm

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


--3siQDZowHQqNOShm--
