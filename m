Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141Ab3CZPxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:53:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53769 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965037Ab3CZPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 062/150] isofs: avoid info leak on export
Date: Tue, 26 Mar 2013 15:19:21 +0000
Message-Id: <1364311249-14454-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit fe685aabf7c8c9f138e5ea900954d295bf229175 upstream.

For type 1 the parent_offset member in struct isofs_fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/isofs/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index 8cf3f97..2b4f235 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -134,6 +134,7 @@ isofs_export_encode_fh(struct inode *inode,
 	len = 3;
 	fh32[0] = ei->i_iget5_block;
  	fh16[2] = (__u16)ei->i_iget5_offset;  /* fh16 [sic] */
+	fh16[3] = 0;  /* avoid leaking uninitialized data */
 	fh32[2] = inode->i_generation;
 	if (parent) {
 		struct iso_inode_info *eparent;
-- 
1.8.1.2

