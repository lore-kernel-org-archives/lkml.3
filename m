Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaBQNAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:00:13 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:64550 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753285AbaBQNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:00:10 -0500
Message-ID: <1392642008.32049.3.camel@ultrabook>
Subject: [PATCH] hfsplus: remove unused variable in hfsplus_get_block
From: Sougata Santra <sougata@tuxera.com>
Reply-To: <sougata@tuxera.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vyacheslav Dubeyko <slava@dubeyko.com>, Joe Perches <joe@perches.com>,
        Sougata Santra <sougata@tuxera.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 17 Feb 2014 15:00:08 +0200
Organization: Tuxera
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [194.100.106.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The variable is defined but not used. Generally it
compiles away with -O2 optimization hence it does not
show a warning.

Signed-off-by: Sougata Santra <sougata@tuxera.com>
---
 fs/hfsplus/extents.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index fbb212f..136d860 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -227,10 +227,8 @@ int hfsplus_get_block(struct inode *inode, sector_t iblock,
 	u32 ablock, dblock, mask;
 	sector_t sector;
 	int was_dirty = 0;
-	int shift;
 
 	/* Convert inode block to disk allocation block */
-	shift = sbi->alloc_blksz_shift - sb->s_blocksize_bits;
 	ablock = iblock >> sbi->fs_shift;
 
 	if (iblock >= hip->fs_blocks) {
-- 
1.8.1.4



