Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3FDW4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:56:08 -0400
Received: from 1wt.eu ([62.212.114.60]:35777 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab3FDWnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:42 -0400
Message-Id: <20130604172135.984849121@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 137/184] isofs: avoid info leak on export
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit fe685aabf7c8c9f138e5ea900954d295bf229175 upstream.

For type 1 the parent_offset member in struct isofs_fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/isofs/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index e81a305..caec670 100644
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
1.7.12.2.21.g234cd45.dirty



