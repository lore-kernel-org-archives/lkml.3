Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3IYU1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:27:47 -0400
Received: from numidia.opendz.org ([98.142.220.152]:38021 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab3IYU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:27:46 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        <kernel-hardening@lists.openwall.com>
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 10/12] procfs: move PROC_BLOCK_SIZE declaration up to make it visible
Date: Wed, 25 Sep 2013 21:14:43 +0100
Message-Id: <1380140085-29712-11-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move PROC_BLOCK_SIZE declaraiton up, so new code can use it.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ed8e3f7..fe02ee4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -150,6 +150,9 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = show } )
 
+/* 4K page size but our output routines use some slack for overruns */
+#define PROC_BLOCK_SIZE	(3*1024)
+
 /**
  * proc_same_open_cred - Check if the file's opener cred matches the
  * current cred.
@@ -738,7 +741,6 @@ static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
 
-#define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
 
 static ssize_t proc_info_read(struct file * file, char __user * buf,
 			  size_t count, loff_t *ppos)
-- 
1.7.11.7

