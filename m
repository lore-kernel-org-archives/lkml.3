Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaA0NV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:21:58 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:52297 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaA0NVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:21:53 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 3/3] s390/compat: change parameter types from unsigned long to compat_ulong_t
Date: Mon, 27 Jan 2014 14:21:45 +0100
Message-Id: <1390828905-52245-4-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1390828905-52245-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1390828905-52245-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012713-6892-0000-0000-00000795700C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change parameter types of s390's compat ipc syscall from unsigned long to
compat_ulong_t to enforce zero extension of these parameters.

This is not really a bug, since s390_ipc compat syscall is only a wrapper
to the generic compat_sys_ipc() syscall, which performs correct zero and
sign extension.

This was introduced with 56e41d3c5aa84 "merge compat sys_ipc instances".

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/compat_linux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index e030d2bdec1b..db02052bd137 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -286,8 +286,8 @@ asmlinkage long sys32_getegid16(void)
 }
 
 #ifdef CONFIG_SYSVIPC
-COMPAT_SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
-		unsigned long, third, compat_uptr_t, ptr)
+COMPAT_SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, compat_ulong_t, second,
+		compat_ulong_t, third, compat_uptr_t, ptr)
 {
 	if (call >> 16)		/* hack for backward compatibility */
 		return -EINVAL;
-- 
1.8.4.5

