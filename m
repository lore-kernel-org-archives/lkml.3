Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaAWARz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:17:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18759 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaAWARx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:17:53 -0500
X-AuditID: cbfee690-b7f266d00000287c-9e-52e05fafd796
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: drop obsolete node page when it is truncated
Date: Thu, 23 Jan 2014 09:16:27 +0900
Message-id: <1390436188-3237-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zI9318Q+CDC7ONbK4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6N9TT97wQrWimvd
	3SwNjNtYuhg5OSQETCQa/3ewQ9hiEhfurWfrYuTiEBJYxijxd8J7uKLuYzuYIBLTGSVWbnnD
	CuE0MUksvXsaKMPBwSagLbF5vwFIg4gAs8SCqecZQWqYBSYwSvxfBDKJg0NYwFnizWFGkBoW
	AVWJF72TwTbzCrhJXDhwlhVimbbEtucTwXolBO6zScxv+8YK0SAg8W3yIbA5EgKyEpsOMEPU
	S0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYISE4YQfjvQPWhxiTgcZN
	ZJYSTc4HhnBeSbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEy
	cXBKNTDOr/dfx1uvPZNxg9/6fX254ga1hx+oPFyw6bmnReSPY5Xpjf01jHrWdusitk3ft/Dd
	foPImTsmat57/t/cQP3d2pvXWTdNvGH5rDOCoSzk0u6Nm3z+rIpguSNsZyuvO3/ht0q7qvXe
	az8tYYvvTE09YLi461qg1eRzuw86ZKdMfGbXeFblC/MEJZbijERDLeai4kQAGEYlGlcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd318Q+CDDbc17O4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjGjfU0/e8EK1opr3d0sDYzbWLoYOTkkBEwkuo/tYIKwxSQu3FvP1sXIxSEk
	MJ1RYuWWN6wQThOTxNK7p4GqODjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4DUCAs4
	S7w5zAhSwyKgKvGidzI7iM0r4CZx4cBZVohl2hLbnk9knMDIvYCRYRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGcIA/k9rBuLLB4hCjAAejEg9vwpf7QUKsiWXFlbmHGCU4mJVEeJMiHwQJ
	8aYkVlalFuXHF5XmpBYfYkwG2j6RWUo0OR8YfXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4U
	EkhPLEnNTk0tSC2C2cLEwSnVwCj+YQN7Zol27ONtO+6zf17RHrB0bY2X15egqUbn5n1a3c0e
	1txgcvVZkImwoftcy3f/pGzfHV0r2Prtb7CGQuXcA6037ILOLg7ad1k14eOSKc1/f8/ZYjrl
	nM1MmXcS/Gx63yzj0npLn+QpZLDwu9m2iZVWXumWehTlMTsqsPTVD6M7UZ29bUosxRmJhlrM
	RcWJAGEGP8u0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a node page is trucated, we'd better drop the page in the node_inode's page
cache for better memory footprint.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index bbfc655..b0649b7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -518,6 +518,10 @@ invalidate:
 	F2FS_SET_SB_DIRT(sbi);
 
 	f2fs_put_page(dn->node_page, 1);
+
+	invalidate_mapping_pages(NODE_MAPPING(sbi),
+			dn->node_page->index, dn->node_page->index);
+
 	dn->node_page = NULL;
 	trace_f2fs_truncate_node(dn->inode, dn->nid, ni.blk_addr);
 }
-- 
1.8.4.474.g128a96c

