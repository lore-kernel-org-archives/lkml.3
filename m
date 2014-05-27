Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaE0UXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:23:00 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43183 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaE0UW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:22:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: ocfs2: move_extents.c:  Fix to remove null pointer checks that could never happen
Date: Tue, 27 May 2014 22:23:51 +0200
Message-Id: <1401222231-21656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of null pointer checks that could never happen

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/ocfs2/move_extents.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 599eb4c..9ba3a10 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -904,9 +904,6 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (!inode)
-		return -ENOENT;
-
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
 
-- 
1.7.10.4

