Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaAUFQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:16:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaAUFQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:16:05 -0500
Date: Mon, 20 Jan 2014 21:15:55 -0800
From: "tip-bot for H.J. Lu" <tipbot@zytor.com>
Message-ID: <tip-071ed2456f79722d0a54f51717e66aacbc7a5d26@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <1388182464-28428-4-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-4-git-send-email-hjl.tools@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] uapi, asm-generic:
  Use __kernel_ulong_t in uapi struct ipc64_perm
Git-Commit-ID: 071ed2456f79722d0a54f51717e66aacbc7a5d26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 20 Jan 2014 21:16:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  071ed2456f79722d0a54f51717e66aacbc7a5d26
Gitweb:     http://git.kernel.org/tip/071ed2456f79722d0a54f51717e66aacbc7a5d26
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Fri, 27 Dec 2013 14:14:19 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Jan 2014 14:44:35 -0800

uapi, asm-generic: Use __kernel_ulong_t in uapi struct ipc64_perm

x32 IPC system call is the same as x86-64 IPC system call, which uses
64-bit integer for unsigned long in struct ipc64_perm.  But x32 long is
32 bit.  This patch replaces unsigned long in uapi struct ipc64_perm with
__kernel_ulong_t.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1388182464-28428-4-git-send-email-hjl.tools@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
