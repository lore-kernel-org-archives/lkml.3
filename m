Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaJCSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:16:56 -0400
Received: from mout.gmx.net ([212.227.17.20]:59726 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbaJCSQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:16:55 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Eric Paris <eparis@parisplace.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] ftruncate: create FAN_MODIFY and IN_MODIFY events
Date: Fri,  3 Oct 2014 20:16:30 +0200
Message-Id: <1412360190-1507-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V03:K0:LvuOp1KjzTKo0hdUGC5bgPZ62Hg4sfHs17uUx+5QhsRbUkmIr7e
 cREKn9fbk5k/Kuuo/0aB9mfJ5kaT7doby/ZhomOzsUUbnOwI2k77TMx0iJUie+DJjY1iHT6
 PC3zx6gsz90KofCncDIBk0o9fjaMImfNJXbeAM0q/pZj53H4m7E6b2A+Hdey55u4iC5HUrm
 HDvx2wpEhxy+UGM5wauZQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fanotify and the inotify API can be used to monitor changes of the file
system.

System call ftruncate modifies files. Hence it should trigger the corresponding
fanotify (FAN_MODIFY) and inotify (IN_MODIFY) events.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/open.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index d6fd3ac..e36f26e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -189,6 +189,8 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 		error = security_path_truncate(&f.file->f_path);
 	if (!error)
 		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, f.file);
+	if (!error) 
+		fsnotify_modify(f.file);
 	sb_end_write(inode->i_sb);
 out_putf:
 	fdput(f);
-- 
2.1.0

