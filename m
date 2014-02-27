Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaB0MS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:18:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35240 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaB0MS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:18:56 -0500
Date: Thu, 27 Feb 2014 17:46:40 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, David Howells <dhowells@redhat.com>,
        Stephan Springl <springl-kernel@bfw-online.de>,
        Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH 33/46] kernel: Add prototype declaration to header file
 include/linux/compat.h
Message-ID: <cab0d757b2114a3918d3af51fdf95c4a73cadc40.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of function to header file
include/linux/compat.h
because they are used by more than one file.

This eliminates the following warning in kernel/compat.c:
kernel/compat.c:357:17: warning: no previous prototype for ‘compat_sys_sigpending’ [-Wmissing-prototypes]
kernel/compat.c:446:17: warning: no previous prototype for ‘compat_sys_old_getrlimit’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/compat.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 3f448c6..083e0dd 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -305,6 +305,13 @@ struct compat_msgbuf;
 
 extern void compat_exit_robust_list(struct task_struct *curr);
 
+asmlinkage long compat_sys_sigpending(compat_old_sigset_t __user *set);
+
+#ifdef COMPAT_RLIM_OLD_INFINITY
+asmlinkage long compat_sys_old_getrlimit(unsigned int resource,
+					 struct compat_rlimit __user *rlim);
+#endif
+
 asmlinkage long
 compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
 			   compat_size_t len);
-- 
1.7.9.5

