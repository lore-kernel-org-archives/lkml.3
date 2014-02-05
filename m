Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaBEUHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:07:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:55413 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaBEUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 163/213] isofs: avoid info leak on export
Date: Wed, 5 Feb 2014 15:01:58 -0500
Message-ID: <1391630568-49251-164-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fe685aabf7c8c9f138e5ea900954d295bf229175 upstream.

For type 1 the parent_offset member in struct isofs_fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/isofs/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index ed752cb38474..344aa606eecd 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -131,6 +131,7 @@ isofs_export_encode_fh(struct dentry *dentry,
 	len = 3;
 	fh32[0] = ei->i_iget5_block;
  	fh16[2] = (__u16)ei->i_iget5_offset;  /* fh16 [sic] */
+	fh16[3] = 0;  /* avoid leaking uninitialized data */
 	fh32[2] = inode->i_generation;
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
-- 
1.8.5.2

