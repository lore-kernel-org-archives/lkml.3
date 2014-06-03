Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016AbaFCUOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:14:00 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:30307 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932917AbaFCUN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:13:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAOAGorjlNbsmtf/2dsb2JhbABZgwerXgQDAQEBBQGYHIEOF3SCUy8jgRo3iEYB0TEXhVWIGWQdhCoEj0uKP4sdiBaDOjuBMA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/adfs/dir_fplus.c: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue,  3 Jun 2014 22:12:41 +0200
Message-Id: <1401826361-10681-1-git-send-email-fabf@skynet.be>
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

