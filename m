Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaCKK15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:27:57 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:35703 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbaCKK1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:27:53 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv6 4/6] file: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Tue, 11 Mar 2014 11:23:43 +0100
Message-Id: <4cde087a056424b698c061d40da7c76eb4a6bf8d.1394532336.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1394532336.git.ydroneaud@opteya.com>
References: <cover.1394532336.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1394532336.git.ydroneaud@opteya.com>
References: <cover.1394532336.git.ydroneaud@opteya.com>
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

Link: http://lkml.kernel.org/r/cover.1394532336.git.ydroneaud@opteya.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 18f7d27855c4..d8ace9a8a821 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -857,7 +857,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 	struct file *file = fget_raw(fildes);
 
 	if (file) {
-		ret = get_unused_fd();
+		ret = get_unused_fd_flags(0);
 		if (ret >= 0)
 			fd_install(ret, file);
 		else
-- 
1.8.5.3

