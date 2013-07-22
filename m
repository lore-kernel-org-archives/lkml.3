Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab3GVQK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38428 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab3GVQKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:23 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 07/48] staging/lustre/llite: A not locked mutex can be unlocked.
Date: Tue, 23 Jul 2013 00:06:28 +0800
Message-Id: <1374509230-3324-8-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

In case of memory pressure a not locked mutex can be unlocked
in function ll_file_open(). This is not allowed and subsequent
behavior is not defined.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3157
Lustre-change: http://review.whamcloud.com/6028
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: John Hammond <johnlockwoodhammond@gmail.com>
Reviewed-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
Reviewed-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 927b3a0..717682c 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -526,7 +526,7 @@ int ll_file_open(struct inode *inode, struct file *file)
 
 	fd = ll_file_data_get();
 	if (fd == NULL)
-		GOTO(out_och_free, rc = -ENOMEM);
+		GOTO(out_openerr, rc = -ENOMEM);
 
 	fd->fd_file = file;
 	if (S_ISDIR(inode->i_mode)) {
-- 
1.7.9.5

