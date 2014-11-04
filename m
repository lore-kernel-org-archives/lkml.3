Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaKDPDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:03:46 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59885 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbaKDPDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:03:42 -0500
Message-ID: <5458EC40.5020807@gmail.com>
Date: Tue, 04 Nov 2014 23:09:52 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, paul@paul-moore.com, eparis@redhat.com
CC: linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/linux/audit.h: Move dummy audit_file() from !AUDIT
 area to !AUDITSYSCALL area
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_file() is related with AUDITSYSCALL, not related with AUDIT, so
need move dummy one from !AUDIT area to !AUDITSYSCALL area. Or it will
cause issue if CONFIG_AUDIT with !CONFIG_AUDITSYSCALL.

The related error (with allmodconfig under tile):

    CC      fs/open.o
  fs/open.c: In function 'SYSC_fchmod':
  fs/open.c:530:3: error: implicit declaration of function 'audit_file' [-Werror=implicit-function-declaration]
     audit_file(f.file);
     ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 include/linux/audit.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 295ae1c..7b1d0d1 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -363,6 +363,8 @@ static inline void audit_inode(struct filename *name,
 				const struct dentry *dentry,
 				unsigned int parent)
 { }
+static inline void audit_file(struct file *file)
+{ }
 static inline void audit_inode_parent_hidden(struct filename *name,
 				const struct dentry *dentry)
 { }
@@ -538,9 +540,6 @@ static inline void audit_log_task_info(struct audit_buffer *ab,
 				       struct task_struct *tsk)
 { }
 #define audit_enabled 0
-static inline void audit_file(struct file *file)
-{
-}
 #endif /* CONFIG_AUDIT */
 static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
 {
-- 
1.9.3
