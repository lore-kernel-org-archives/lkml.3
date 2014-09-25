Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaIYSGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:06:25 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59139 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaIYSGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:06:24 -0400
From: Ramon Fried <ramon.fried@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Ramon Fried <ramon.fried@gmail.com>
Subject: [PATCH] staging: lustre: llite_lib.c Set ll_md_setattr function to be static
Date: Thu, 25 Sep 2014 21:05:06 +0300
Message-Id: <1411668306-19748-1-git-send-email-ramon.fried@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warning:
llite_lib.c:1240:5: warning: symbol 'll_md_setattr' was not declared. Should it be static?


Signed-off-by: Ramon Fried <ramon.fried@gmail.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 59e36b0..a8bcc51 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1237,7 +1237,7 @@ void ll_clear_inode(struct inode *inode)
 	lli->lli_has_smd = false;
 }
 
-int ll_md_setattr(struct dentry *dentry, struct md_op_data *op_data,
+static int ll_md_setattr(struct dentry *dentry, struct md_op_data *op_data,
 		  struct md_open_data **mod)
 {
 	struct lustre_md md;
-- 
1.9.1

