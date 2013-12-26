Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3LZISh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 03:18:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62315 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3LZISf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 03:18:35 -0500
X-AuditID: cbfee68f-b7f156d00000276c-bb-52bbe6597c6c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: should put the dnode when NEW_ADDR is detected
Date: Thu, 26 Dec 2013 17:17:21 +0900
Message-id: <1388045841-32165-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1388045841-32165-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1388045841-32165-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zA93IZ7uDDE7v0LO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6N/whXGghk8FV1T
	TrI3MF7l7GLk5JAQMJFo657DBGGLSVy4t56ti5GLQ0hgGaPEo0/TGWGKtp5fyQ6RWMQoMf3n
	DEYIp5lJ4nLrIaAMBwebgLbE5v0GIA0iAswSC6aeB6thFpjAKPF/0XsWkISwgKfEgdbtYFNZ
	BFQl/m2+BLaaV8Bd4t3Va8wQ27Qltj2fCFbDKeAhsa9hG5gtBFSzZdc8sKESAt/ZJP7s2cQO
	MUhA4tvkQywgR0gIyEpsOgA1R1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtYrTswtLs1L10vO
	z93ECAna/h2Mdw9YH2JMBho3kVlKNDkfGPR5JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoGxxpBNrspm7ac8n0jFe1IayQwhHxrk2nZtFVP94/Vy
	ZWrq13lqDEvWaSh8PNn4K7xjQvTX5VvnXZsjJCMSPi3C+I3vR9mry03l+zVdbW88miUntVF7
	45KMvOTyNH6DD72C5doxZeJMH+NuS0Q96ph9uzWmh33yKdavqw84LOm66rPq/V2GtWJKLMUZ
	iYZazEXFiQCh9e/ucAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd3IZ7uDDPb807K4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjGjf8IVxoIZPBVdU06yNzBe5exi5OSQEDCR2Hp+JTuELSZx4d56ti5GLg4h
	gUWMEtN/zmCEcJqZJC63HgKq4uBgE9CW2LzfAKRBRIBZYsHU82A1zAITGCX+L3rPApIQFvCU
	ONC6nRHEZhFQlfi3+RITiM0r4C7x7uo1Zoht2hLbnk8Eq+EU8JDY17ANzBYCqtmyax7jBEbe
	BYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY+KZ1A7GlQ0WhxgFOBiVeHg7dHcHCbEm
	lhVX5h5ilOBgVhLh3dUNFOJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YLzmlcQbGpuYGVka
	mVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOjEOOsudb3GC782uh8O+6MsLXD
	ZKU/X6+WtEUdYZi74D/v1WypmcZR2kefnipUv3HW48XNt7bnf99elXXk2i8h8xvta5WvT/58
	0aOmp1Rlt+rka965DUf0Nt64n311ztWIXLHseIv5EZkbd83TC17NNqsjbEn8vYU13ImyMy7s
	vuTEb/tPyJrttxJLcUaioRZzUXEiAKXhsJXNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When get_dnode_of_data() in get_data_block() returns a successful dnode, we
should put the dnode.
But, previously, if its data block address is equal to NEW_ADDR, we didn't do
that, resulting in a deadlock condition.
So, this patch splits original error conditions with this case, and then calls
f2fs_put_dnode before finishing the function.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 0879d2a..991e368 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -626,11 +626,13 @@ static int get_data_block(struct inode *inode, sector_t iblock,
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, pgofs, mode);
-	if (err || dn.data_blkaddr == NEW_ADDR) {
+	if (err) {
 		if (err == -ENOENT)
 			err = 0;
 		goto unlock_out;
 	}
+	if (dn.data_blkaddr == NEW_ADDR)
+		goto put_out;
 
 	if (dn.data_blkaddr != NULL_ADDR) {
 		map_bh(bh_result, inode->i_sb, dn.data_blkaddr);
@@ -659,11 +661,14 @@ get_next:
 
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		err = get_dnode_of_data(&dn, pgofs, mode);
-		if (err || dn.data_blkaddr == NEW_ADDR) {
+		if (err) {
 			if (err == -ENOENT)
 				err = 0;
 			goto unlock_out;
 		}
+		if (dn.data_blkaddr == NEW_ADDR)
+			goto put_out;
+
 		end_offset = IS_INODE(dn.node_page) ?
 			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
 	}
-- 
1.8.4.474.g128a96c

