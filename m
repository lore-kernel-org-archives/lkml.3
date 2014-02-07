Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbaBGMAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:00:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaBGLwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 194/233] fs/compat: fix lookup_dcookie() parameter handling
Date: Fri,  7 Feb 2014 11:46:53 +0000
Message-Id: <1391773652-25214-195-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit d8d14bd09cddbaf0168d61af638455a26bd027ff upstream.

Commit d5dc77bfeeab ("consolidate compat lookup_dcookie()") coverted all
architectures to the new compat_sys_lookup_dcookie() syscall.

The "len" paramater of the new compat syscall must have the type
compat_size_t in order to enforce zero extension for architectures where
the ABI requires that the caller of a function performed zero and/or
sign extension to 64 bit of all parameters.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/dcookies.c          | 2 +-
 include/linux/compat.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcookies.c b/fs/dcookies.c
index ab5954b..ac44a69 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -204,7 +204,7 @@ out:
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, w0, u32, w1, char __user *, buf, size_t, len)
+COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, w0, u32, w1, char __user *, buf, compat_size_t, len)
 {
 #ifdef __BIG_ENDIAN
 	return sys_lookup_dcookie(((u64)w0 << 32) | w1, buf, len);
diff --git a/include/linux/compat.h b/include/linux/compat.h
index caa5385..df70600 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -421,7 +421,7 @@ extern long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  compat_long_t addr, compat_long_t data);
 
-asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, size_t);
+asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, compat_size_t);
 /*
  * epoll (fs/eventpoll.c) compat bits follow ...
  */
-- 
1.8.3.2

