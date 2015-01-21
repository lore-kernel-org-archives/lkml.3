Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbbAUIbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:31:39 -0500
Received: from linuxhacker.ru ([217.76.32.60]:51461 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbbAUIbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:31:34 -0500
X-Greylist: delayed 1217 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 03:31:33 EST
From: green@linuxhacker.ru
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org,
        "<linux-kernel@vger.kernel.org> Mailing List" 
	<linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Christoph Hellwig <hch@lst.de>, Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH] staging/lustre/llite: get rid of backing_dev_info
Date: Wed, 21 Jan 2015 03:10:47 -0500
Message-Id: <1421827847-8371-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20150121144558.79cb2056@canb.auug.org.au>
References: <20150121144558.79cb2056@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Drokin <green@linuxhacker.ru>

With removal of backing_dev_info from struct address_space,
we don't need to assign it in Lustre either.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index d5b149c..45aaa1c 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1812,10 +1812,6 @@ void ll_read_inode2(struct inode *inode, void *opaque)
 
 	/* OIDEBUG(inode); */
 
-	/* initializing backing dev info. */
-	inode->i_mapping->backing_dev_info = &s2lsi(inode->i_sb)->lsi_bdi;
-
-
 	if (S_ISREG(inode->i_mode)) {
 		struct ll_sb_info *sbi = ll_i2sbi(inode);
 
-- 
2.1.0

