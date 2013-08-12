Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3HLH64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:58:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38123 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3HLH6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:58:52 -0400
X-AuditID: cbfee68f-b7f436d000000f81-9b-520895bb11e9
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: check the free space first in new_node_page
Date: Mon, 12 Aug 2013 16:58:53 +0900
Message-id: <1376294334-11699-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA93dUzmCDP5N5be4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PfhQusBX+4Kv59
	O8zewPiVo4uRk0NCwERiYcMrJghbTOLCvfVsXYxcHEICyxglprduZYYp2nHlKwtEYhGjxOHG
	L1BOG5NE17L5jF2MHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUBqhAXcJLqWCIPU
	sAioSky4+AlsAa+Au8T3eSfZIZbpSiw6cZAVpFdC4DGbxOfmHUwQDQIS3yYfApsjISArsekA
	1HGSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZICPbvYLx7wPoQYzLQ
	uInMUqLJ+cAQziuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QD4+zVc6sPrHPbdLo3NeVFxGH9NebZR1oyErOWPO/x+xbd8/cI28zgz46m/ywNk+Y8
	X/Pn9bGTO8UXiK5eP4n5eMnHhxb21UEfcz6LbNBL3xd79YCL9rU/vMYL7+8QSfmRpCaacnvB
	y1mJvSc+Cszt2lJ8YH98eNWh2YEz2P85RxwK/mte8+z/3EwlluKMREMt5qLiRAArZ7PeVwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd3dUzmCDA4c4bS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj34ULrAV/uCr+fTvM3sD4laOLkZNDQsBEYseVrywQtpjEhXvr2boYuTiE
	BBYxShxu/MIC4bQxSXQtm8/YxcjBwSagLbF5vwFIg4gAs8SCqecZQWqYBSYwSvxf9J4FpEZY
	wE2ia4kwSA2LgKrEhIufmEFsXgF3ie/zTrJDLNOVWHTiIOsERu4FjAyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYID/JnUDsaVDRaHGAU4GJV4eD2+sAcJsSaWFVfmHmKU4GBWEuHlbeQI
	EuJNSaysSi3Kjy8qzUktPsSYDLR9IrOUaHI+MPrySuINjU3MjCyNzCyMTMzNSRNWEuc90God
	KCSQnliSmp2aWpBaBLOFiYNTqoHx5KF9Z/+ZBWT+jjKx3iperBFx2u/cLTYzkf+Cx6X/GWbP
	2NTHo/99kcjS5ccrWll2bosxK5hrED/t4kstE9UK2ejUG33tv+vSuF5cPrCr/EGhNk94RNCO
	T3c6I+acP1va1Gas8K8tJMqmdaP39dt5Nt4uja2LW2Yq/jC5MMFc8t/iFtZZ09YqsRRnJBpq
	MRcVJwIAd2XNs7QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's check the free space in prior to the main process of allocating a new node
page.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index bb8fbda..858a333 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -833,29 +833,29 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	get_node_info(sbi, dn->nid, &old_ni);
+	if (!inc_valid_node_count(sbi, dn->inode, 1)) {
+		err = -ENOSPC;
+		goto fail;
+	}
 
-	SetPageUptodate(page);
-	fill_node_footer(page, dn->nid, dn->inode->i_ino, ofs, true);
+	get_node_info(sbi, dn->nid, &old_ni);
 
 	/* Reinitialize old_ni with new node page */
 	BUG_ON(old_ni.blk_addr != NULL_ADDR);
 	new_ni = old_ni;
 	new_ni.ino = dn->inode->i_ino;
-
-	if (!inc_valid_node_count(sbi, dn->inode, 1)) {
-		err = -ENOSPC;
-		goto fail;
-	}
 	set_node_addr(sbi, &new_ni, NEW_ADDR);
+
+	fill_node_footer(page, dn->nid, dn->inode->i_ino, ofs, true);
 	set_cold_node(dn->inode, page);
+	SetPageUptodate(page);
+	set_page_dirty(page);
 
 	dn->node_page = page;
 	if (ipage)
 		update_inode(dn->inode, ipage);
 	else
 		sync_inode_page(dn);
-	set_page_dirty(page);
 	if (ofs == 0)
 		inc_valid_inode_count(sbi);
 
-- 
1.8.3.1.437.g0dbd812

