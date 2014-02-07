Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaBGLwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42305 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbaBGLv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 181/233] compat: fix sys_fanotify_mark
Date: Fri,  7 Feb 2014 11:46:40 +0000
Message-Id: <1391773652-25214-182-git-send-email-luis.henriques@canonical.com>
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

commit 592f6b842f64e416c7598a1b97c649b34241e22d upstream.

Commit 91c2e0bcae72 ("unify compat fanotify_mark(2), switch to
COMPAT_SYSCALL_DEFINE") added a new unified compat fanotify_mark syscall
to be used by all architectures.

Unfortunately the unified version merges the split mask parameter in a
wrong way: the lower and higher word got swapped.

This was discovered with glibc's tst-fanotify test case.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Andreas Krebbel <krebbel@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Acked-by: "David S. Miller" <davem@davemloft.net>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/notify/fanotify/fanotify_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index e44cb64..6663511 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -888,9 +888,9 @@ COMPAT_SYSCALL_DEFINE6(fanotify_mark,
 {
 	return sys_fanotify_mark(fanotify_fd, flags,
 #ifdef __BIG_ENDIAN
-				((__u64)mask1 << 32) | mask0,
-#else
 				((__u64)mask0 << 32) | mask1,
+#else
+				((__u64)mask1 << 32) | mask0,
 #endif
 				 dfd, pathname);
 }
-- 
1.8.3.2

