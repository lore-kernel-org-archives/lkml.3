Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaAVNhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:37:13 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38487 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbaAVNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:37:10 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Siyao <laisiyao@whamcloud.com>,
        Lai Siyao <lai.siyao@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 RESEND 2/8] staging/lustre/llite: don't d_add for create only files
Date: Wed, 22 Jan 2014 21:36:13 +0800
Message-Id: <1390397779-30975-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
References: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Siyao <laisiyao@whamcloud.com>

This is only part of the original Lustre commit. Splitted to remove
d_add() for create only files, because the dentry is fake,
and will be released right after use.

Lustre-change: http://review.whamcloud.com/6797
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3486
Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Peng Tao <bergwolf@gmail.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Alexey Shvetsov <alexxy@gentoo.org>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/namei.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index bc1a644..1d03a6f 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -583,11 +583,8 @@ static struct dentry *ll_lookup_nd(struct inode *parent, struct dentry *dentry,
 	       parent->i_generation, parent, flags);
 
 	/* Optimize away (CREATE && !OPEN). Let .create handle the race. */
-	if ((flags & LOOKUP_CREATE ) && !(flags & LOOKUP_OPEN)) {
-		__d_lustre_invalidate(dentry);
-		d_add(dentry, NULL);
+	if ((flags & LOOKUP_CREATE) && !(flags & LOOKUP_OPEN))
 		return NULL;
-	}
 
 	if (flags & (LOOKUP_PARENT|LOOKUP_OPEN|LOOKUP_CREATE))
 		itp = NULL;
-- 
1.7.9.5

