Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3HONNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:13:31 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:42144 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab3HONNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:13:11 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/10] file: remove get_unused_fd()
Date: Thu, 15 Aug 2013 15:11:00 +0200
Message-Id: <8335dd0b48ed05061c3c186aa99a6b41b4526ece.1376327678.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1376327678.git.ydroneaud@opteya.com>
References: <cover.1376327678.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1376327678.git.ydroneaud@opteya.com>
References: <cover.1376327678.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro get_unused_fd() allocates a file descriptor without O_CLOEXEC flag.

This can be seen as an unsafe default: in most case O_CLOEXEC
must be used to not leak file descriptor across exec().

Using O_CLOEXEC by default allows userspace to choose, without race,
if the file descriptor is going to be inherited across exec().

This patch removes get_unused_fd() so that newer kernel code use
anon_inode_getfd() or get_unused_fd_flags() with flags provided
by userspace. If flags cannot be given by userspace,
O_CLOEXEC must be the default flag.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1376327678.git.ydroneaud@opteya.com

---
 include/linux/file.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index cbacf4f..8666002 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -63,7 +63,6 @@ extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
 extern void put_filp(struct file *);
 extern int get_unused_fd_flags(unsigned flags);
-#define get_unused_fd() get_unused_fd_flags(0)
 extern void put_unused_fd(unsigned int fd);
 
 extern void fd_install(unsigned int fd, struct file *file);
-- 
1.8.3.1

