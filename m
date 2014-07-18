Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbaGRPfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:35:37 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:40142 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762467AbaGRPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:35:31 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org
Cc: dcb314@hotmail.com, adrian.hunter@intel.com, dedekind1@gmail.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 5/5] fs/ubifs/{sb,super}.c: drop negativity check on unsigned value
Date: Fri, 18 Jul 2014 18:35:25 +0300
Message-Id: <1405697725-23866-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80581
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 fs/ubifs/sb.c    | 2 +-
 fs/ubifs/super.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 4c37607..c2c3d13 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -447,7 +447,7 @@ static int validate_sb(struct ubifs_info *c, struct ubifs_sb_node *sup)
 		goto failed;
 	}
 
-	if (c->default_compr < 0 || c->default_compr >= UBIFS_COMPR_TYPES_CNT) {
+	if (c->default_compr >= UBIFS_COMPR_TYPES_CNT) {
 		err = 13;
 		goto failed;
 	}
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index e5bd068..9c59c10 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -75,7 +75,7 @@ static int validate_inode(struct ubifs_info *c, const struct inode *inode)
 		return 1;
 	}
 
-	if (ui->compr_type < 0 || ui->compr_type >= UBIFS_COMPR_TYPES_CNT) {
+	if (ui->compr_type >= UBIFS_COMPR_TYPES_CNT) {
 		ubifs_err("unknown compression type %d", ui->compr_type);
 		return 2;
 	}
-- 
1.8.5.5

