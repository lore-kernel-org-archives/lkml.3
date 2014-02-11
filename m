Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaBKUD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:03:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaBKTG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 030/107] fs/compat: fix lookup_dcookie() parameter handling
Date: Tue, 11 Feb 2014 11:04:56 -0800
Message-Id: <20140211184749.054831394@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcookies.c          |    2 +-
 include/linux/compat.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -422,7 +422,7 @@ extern long compat_arch_ptrace(struct ta
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  compat_long_t addr, compat_long_t data);
 
-asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, size_t);
+asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, compat_size_t);
 /*
  * epoll (fs/eventpoll.c) compat bits follow ...
  */


