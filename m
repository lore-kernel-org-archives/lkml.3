Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaAEUit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 15:38:49 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59458 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAEUis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:38:48 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv5 4/7] file: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Sun,  5 Jan 2014 21:36:31 +0100
Message-Id: <00926a053fce1d3ca8f4bdd481b7bec81f00e60f.1388952061.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
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

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 4a78f981557a..1420d2890b43 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -897,7 +897,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 	struct file *file = fget_raw(fildes);
 
 	if (file) {
-		ret = get_unused_fd();
+		ret = get_unused_fd_flags(0);
 		if (ret >= 0)
 			fd_install(ret, file);
 		else
-- 
1.8.4.2

