Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3LCOEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:04:11 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58199 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3LCOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:10 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Patrick Farrell <paf@cray.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 01/15] Revert "staging/lustre/nfs: writing to new files will return ENOENT"
Date: Tue,  3 Dec 2013 21:58:39 +0800
Message-Id: <1386079133-6459-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ad8dbc93a464869f64365a2123b3491965df3b3e.

The original commit was reverted in Lustre tree this due to
interoperability problems with 2.1 servers. But I forgot to remove
it from my patch queue. sorry for the noise.

Cc: Patrick Farrell <paf@cray.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 drivers/staging/lustre/lustre/llite/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index f36c5d8..82248e9 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -368,6 +368,8 @@ static int ll_intent_file_open(struct file *file, void *lmm,
 {
 	struct ll_sb_info *sbi = ll_i2sbi(file->f_dentry->d_inode);
 	struct dentry *parent = file->f_dentry->d_parent;
+	const char *name = file->f_dentry->d_name.name;
+	const int len = file->f_dentry->d_name.len;
 	struct md_op_data *op_data;
 	struct ptlrpc_request *req;
 	__u32 opc = LUSTRE_OPC_ANY;
@@ -392,9 +394,8 @@ static int ll_intent_file_open(struct file *file, void *lmm,
 	}
 
 	op_data  = ll_prep_md_op_data(NULL, parent->d_inode,
-				      file->f_dentry->d_inode, NULL, 0,
+				      file->f_dentry->d_inode, name, len,
 				      O_RDWR, opc, NULL);
-
 	if (IS_ERR(op_data))
 		return PTR_ERR(op_data);
 
-- 
1.7.9.5

