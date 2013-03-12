Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3CLFli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:41:38 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:50652 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab3CLFlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:41:36 -0400
From: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com,
        =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Subject: [PATCH] CIFS: fix module loading regression
Date: Tue, 12 Mar 2013 02:41:25 -0300
Message-Id: <1363066885-26173-1-git-send-email-crrodriguez@opensuse.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit:

7f78e0351394052e1a6293e175825eb5c7869507
fs: Limit sys_mount to only request filesystem modules.

cifs module no longer loads when issuing the mount command
due to the lack of a MODULE_ALIAS_FS.

Signed-off-by: Cristian Rodríguez <crrodriguez@opensuse.org>
---
 fs/cifs/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1a052c0..81ebb98 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -777,6 +777,8 @@ struct file_system_type cifs_fs_type = {
 	.kill_sb = cifs_kill_sb,
 	/*  .fs_flags */
 };
+MODULE_ALIAS_FS("cifs");
+
 const struct inode_operations cifs_dir_inode_ops = {
 	.create = cifs_create,
 	.atomic_open = cifs_atomic_open,
-- 
1.8.1.4

