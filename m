Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3FXHsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:48:22 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:40818 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3FXHsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:48:21 -0400
Subject: [PATCH] pstore: Fail to unlink if a driver has not defined
 pstore_erase
To: ccross@android.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, cbouatmailru@gmail.com
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, benh@kernel.crashing.org, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com
Date: Mon, 24 Jun 2013 13:18:06 +0530
Message-ID: <20130624074453.24481.96622.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062407-3864-0000-0000-000008C4C118
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pstore_erase is used to erase the record from the persistent store.
So if a driver has not defined pstore_erase callback return
-EINVAL instead of unlinking a file as deleting the file without
erasing its record in persistent store will give a wrong impression
to customers.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index e4bcb2c..fa6339a 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -178,6 +178,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 	if (p->psi->erase)
 		p->psi->erase(p->type, p->id, p->count,
 			      dentry->d_inode->i_ctime, p->psi);
+	else
+		return -EINVAL;
 
 	return simple_unlink(dir, dentry);
 }

