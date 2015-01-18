Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbbAROIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:08:22 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:48471 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751853AbbAROIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:08:12 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Ceresoli <luca@lucaceresoli.net>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging: lustre: llite: declare internal symbols as static
Date: Sun, 18 Jan 2015 15:06:50 +0100
Message-Id: <1421590012-7082-5-git-send-email-luca@lucaceresoli.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
References: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warnings like:
  warning: symbol '...' was not declared. Should it be static?

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Peng Tao <bergwolf@gmail.com>
Cc: Jinshan Xiong <jinshan.xiong@intel.com>
Cc: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: HPDD-discuss@lists.01.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/lustre/lustre/llite/dir.c  | 4 ++--
 drivers/staging/lustre/lustre/llite/file.c | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 1ac7a70..babba60 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -652,8 +652,8 @@ static int ll_send_mgc_param(struct obd_export *mgc, char *string)
 	return rc;
 }
 
-int ll_dir_setdirstripe(struct inode *dir, struct lmv_user_md *lump,
-			char *filename)
+static int ll_dir_setdirstripe(struct inode *dir, struct lmv_user_md *lump,
+			       char *filename)
 {
 	struct ptlrpc_request *request = NULL;
 	struct md_op_data *op_data;
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 35a2df0..ca270f4 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1587,7 +1587,8 @@ ll_get_grouplock(struct inode *inode, struct file *file, unsigned long arg)
 	return 0;
 }
 
-int ll_put_grouplock(struct inode *inode, struct file *file, unsigned long arg)
+static int ll_put_grouplock(struct inode *inode, struct file *file,
+			    unsigned long arg)
 {
 	struct ll_inode_info   *lli = ll_i2info(inode);
 	struct ll_file_data    *fd = LUSTRE_FPRIVATE(file);
-- 
1.9.1

