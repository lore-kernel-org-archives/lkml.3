Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaD0Smu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:42:50 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48976 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbaD0Smt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:42:49 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH] staging/lustre/llite: Fix a compile warning.
Date: Sun, 27 Apr 2014 14:42:29 -0400
Message-Id: <1398624149-8209-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the warning below in Lustre code.
Actually the warning is invalid since we either always assign
the symname in ll_readlink_internal or return an error there and
then the following rc check would assign symlink variable explicitly.

In file included from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/linux/lustre_compat25.h:41:0,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/linux/lvfs.h:48,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/lvfs.h:45,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/obd_support.h:41,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/obd_class.h:40,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/linux/lustre_lite.h:49,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/../include/lustre_lite.h:45,
                 from /home/green/bk/linux/drivers/staging/lustre/lustre/llite/symlink.c:42:
/home/green/bk/linux/drivers/staging/lustre/lustre/llite/symlink.c: In function ‘ll_follow_link’:
/home/green/bk/linux/include/linux/namei.h:88:29: warning: ‘symname’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  nd->saved_names[nd->depth] = path;
                             ^
/home/green/bk/linux/drivers/staging/lustre/lustre/llite/symlink.c:123:8: note: ‘symname’ was declared here
  char *symname;
        ^

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/symlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/symlink.c b/drivers/staging/lustre/lustre/llite/symlink.c
index 80d48b5..129d302 100644
--- a/drivers/staging/lustre/lustre/llite/symlink.c
+++ b/drivers/staging/lustre/lustre/llite/symlink.c
@@ -120,7 +120,7 @@ static void *ll_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct inode *inode = dentry->d_inode;
 	struct ptlrpc_request *request = NULL;
 	int rc;
-	char *symname;
+	char *symname = NULL;
 
 	CDEBUG(D_VFSTRACE, "VFS Op\n");
 	/* Limit the recursive symlink depth to 5 instead of default
-- 
1.8.5.3

