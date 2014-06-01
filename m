Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbaFAN7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:59:43 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:45972 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453AbaFAN7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:59:41 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org
Subject: [PATCHv7 4/6] file: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Sun,  1 Jun 2014 15:58:45 +0200
Message-Id: <65a2618acc6a6f55e4d9aedd89292b0378dac37b.1401630396.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401630396.git.ydroneaud@opteya.com>
References: <cover.1401630396.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1401630396.git.ydroneaud@opteya.com>
References: <cover.1401630396.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro get_unused_fd() is used to allocate a file descriptor with
default flags. Those default flags (0) can be "unsafe":
O_CLOEXEC must be made the default to not leak file descriptor
across exec().

In a further patch, get_unused_fd() will be removed so that
new code start using get_unused_fd_flags() (or anon_inode_getfd())
with correct flags.

This patch replaces calls to get_unused_fd() with equivalent call to
get_unused_fd_flags(0).

Link: http://lkml.kernel.org/r/cover.1401630396.git.ydroneaud@opteya.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 66923fe3176e..4186f81cd9f1 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -868,7 +868,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 	struct file *file = fget_raw(fildes);
 
 	if (file) {
-		ret = get_unused_fd();
+		ret = get_unused_fd_flags(0);
 		if (ret >= 0)
 			fd_install(ret, file);
 		else
-- 
1.9.3

