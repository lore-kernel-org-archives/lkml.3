Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3FHMZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 08:25:38 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37968 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3FHMZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 08:25:36 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 3/4] f2fs: use the F2FS sepcifice flags in f2fs_ioctl() 
Date: Sat,  8 Jun 2013 21:25:28 +0900
Message-Id: <1370694328-2806-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In f2fs_ioctl() function, it is using generic flags.
Since F2FS specific flags are defined. So lets use
those flags.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8dfc1da..6071ff5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -538,10 +538,10 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int ret;
 
 	switch (cmd) {
-	case FS_IOC_GETFLAGS:
+	case F2FS_IOC_GETFLAGS:
 		flags = fi->i_flags & FS_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
-	case FS_IOC_SETFLAGS:
+	case F2FS_IOC_SETFLAGS:
 	{
 		unsigned int oldflags;
 
-- 
1.7.9.5

