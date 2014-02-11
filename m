Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaBKTHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaBKTHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 19/79] compat: fix sys_fanotify_mark
Date: Tue, 11 Feb 2014 11:05:23 -0800
Message-Id: <20140211184721.482373761@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fanotify/fanotify_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -867,9 +867,9 @@ COMPAT_SYSCALL_DEFINE6(fanotify_mark,
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


