Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaJSKkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 06:40:08 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaJSKkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 06:40:05 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com
Subject: [PATCH 2/2] ocfs2: Fix d_splice_alias() return code checking
Date: Sun, 19 Oct 2014 12:39:44 +0200
Message-Id: <1413715184-30196-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413715184-30196-1-git-send-email-richard@nod.at>
References: <1413715184-30196-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.
Currently the code checks not for ERR_PTR and my oops in
ocfs2_dentry_attach_lock().
Fix this by using IS_ERR_OR_NULL().

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ocfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 8add6f1..b931e04 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -158,7 +158,7 @@ bail_add:
 		 * NOTE: This dentry already has ->d_op set from
 		 * ocfs2_get_parent() and ocfs2_get_dentry()
 		 */
-		if (ret)
+		if (!IS_ERR_OR_NULL(ret))
 			dentry = ret;
 
 		status = ocfs2_dentry_attach_lock(dentry, inode,
-- 
2.1.0

