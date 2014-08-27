Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaH0Tvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:51:45 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54446 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbaH0Tvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:51:44 -0400
From: rtg.canonical@gmail.com
X-Google-Original-From: tim.gardner@canonical.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.17-rc2] fs: namespace: suppress 'may be used uninitialized' warnings
Date: Wed, 27 Aug 2014 13:51:05 -0600
Message-Id: <1409169065-61597-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

The gcc version 4.9.1 compiler complains Even though it isn't possible for
these variables to not get initialized before they are used.

fs/namespace.c: In function ‘SyS_mount’:
fs/namespace.c:2720:8: warning: ‘kernel_dev’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
        ^
fs/namespace.c:2699:8: note: ‘kernel_dev’ was declared here
  char *kernel_dev;
        ^
fs/namespace.c:2720:8: warning: ‘kernel_type’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
        ^
fs/namespace.c:2697:8: note: ‘kernel_type’ was declared here
  char *kernel_type;
        ^
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/namespace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 20232e4..8681260 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2694,9 +2694,9 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 		char __user *, type, unsigned long, flags, void __user *, data)
 {
 	int ret;
-	char *kernel_type;
+	char *uninitialized_var(kernel_type);
 	struct filename *kernel_dir;
-	char *kernel_dev;
+	char *uninitialized_var(kernel_dev);
 	unsigned long data_page;
 
 	ret = copy_mount_string(type, &kernel_type);
-- 
2.1.0

