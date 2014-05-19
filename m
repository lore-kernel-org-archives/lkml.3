Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbaESThE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:37:04 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:3014 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbaESThC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:37:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMVAHlbelNbtAXp/2dsb2JhbABZgwaqdwQBAQEBAQEFAZonAgKBGRd0glMTHCMYgQIkE4hFAdJchVWIe4RHAQOPL4oqAYsRiAmDOTs
Date: Mon, 19 May 2014 21:36:58 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Dave.Kleikamp" <shaggy@kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/jfs/jfs_dmap.c: replace min/casting by min_t
Message-Id: <20140519213658.0bd61b38cbbc1d2dc61f3e42@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jfs/jfs_dmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 370d7b6..2d514c7 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1208,7 +1208,7 @@ static int dbAllocNext(struct bmap * bmp, struct dmap * dp, s64 blkno,
 				 * by this leaf.
 				 */
 				l2size =
-				    min((int)leaf[word], NLSTOL2BSZ(nwords));
+				    min_t(int, leaf[word], NLSTOL2BSZ(nwords));
 
 				/* determine how many words were handled.
 				 */
@@ -1902,7 +1902,7 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 
 		/* determine how many blocks to allocate from this dmap.
 		 */
-		nb = min(n, (s64)BPERDMAP);
+		nb = min_t(s64, n, BPERDMAP);
 
 		/* allocate the blocks from the dmap.
 		 */
@@ -2260,7 +2260,8 @@ static void dbAllocBits(struct bmap * bmp, struct dmap * dp, s64 blkno,
 				 * of bits being allocated and the l2 number
 				 * of bits currently described by this leaf.
 				 */
-				size = min((int)leaf[word], NLSTOL2BSZ(nwords));
+				size = min_t(int, leaf[word],
+					     NLSTOL2BSZ(nwords));
 
 				/* update the leaf to reflect the allocation.
 				 * in addition to setting the leaf value to
@@ -3563,7 +3564,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 					if (mp == NULL)
 						goto errout;
 
-					n = min(nblocks, (s64)BPERDMAP);
+					n = min_t(s64, nblocks, BPERDMAP);
 				}
 
 				dp = (struct dmap *) mp->data;
-- 
1.8.4.5

