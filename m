Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaFOGbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:31:15 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:30455 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbaFOGbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:31:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEGAC49nVNXQzGY/2dsb2JhbABagw2rDgYBAwEGmSSBAxd1hDEvI4EaN4hGAc8LF4VjiC9kHYQtBI9sileLMIgogX6BRDuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 RESEND] fs/adfs/dir_fplus.c: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Sun, 15 Jun 2014 08:29:57 +0200
Message-Id: <1402813797-2920-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel.h definition.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/adfs/dir_fplus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/adfs/dir_fplus.c b/fs/adfs/dir_fplus.c
index d9e3bee..7673c1f 100644
--- a/fs/adfs/dir_fplus.c
+++ b/fs/adfs/dir_fplus.c
@@ -55,7 +55,7 @@ adfs_fplus_read(struct super_block *sb, unsigned int id, unsigned int sz, struct
 	}
 
 	size >>= sb->s_blocksize_bits;
-	if (size > sizeof(dir->bh)/sizeof(dir->bh[0])) {
+	if (size > ARRAY_SIZE(dir->bh)) {
 		/* this directory is too big for fixed bh set, must allocate */
 		struct buffer_head **bh_fplus =
 			kzalloc(size * sizeof(struct buffer_head *),
-- 
1.8.4.5

