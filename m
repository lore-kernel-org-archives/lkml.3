Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaBIWtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:49:17 -0500
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:47738 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752463AbaBIWtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:49:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3350:3867:4321:5007:6261:6642:8603:10004:10026:10848:11026:11473:11658:11914:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stew09_148cec4b25d25
X-Filterd-Recvd-Size: 1855
From: Joe Perches <joe@perches.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ncpfs: inode: Fix mismatch printk formats and arguments
Date: Sun,  9 Feb 2014 14:48:49 -0800
Message-Id: <657527db716fde052f68a9cbc626d10b731bd039.1391985629.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1391985629.git.joe@perches.com>
References: <cover.1391985629.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conversions to ncp_dbg showed some format/argument mismatches
so fix them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ncpfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 513b5cf..a65b974 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -682,7 +682,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	ncp_unlock_server(server);
 	if (error < 0)
 		goto out_rxbuf;
-	ncp_dbg(1, "NCP_SBP(sb) = %x\n", (int) NCP_SBP(sb));
+	ncp_dbg(1, "NCP_SBP(sb) = %p\n", NCP_SBP(sb));
 
 	error = -EMSGSIZE;	/* -EREMOTESIDEINCOMPATIBLE */
 #ifdef CONFIG_NCPFS_PACKET_SIGNING
@@ -985,7 +985,7 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
 	if ((attr->ia_valid & ATTR_SIZE) != 0) {
 		int written;
 
-		ncp_dbg(1, "trying to change size to %ld\n", attr->ia_size);
+		ncp_dbg(1, "trying to change size to %llu\n", attr->ia_size);
 
 		if ((result = ncp_make_open(inode, O_WRONLY)) < 0) {
 			result = -EACCES;
-- 
1.8.1.2.459.gbcd45b4.dirty

