Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3ETDer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:34:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3ETDdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:40 -0400
X-AuditID: cbfee690-b7efc6d000006d92-15-5199998e8de0
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 06/15] f2fs: skip get_node_page if locked node page is passed
Date: Mon, 20 May 2013 12:32:20 +0900
Message-id: <1369020743-18520-6-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zA92+mTMDDdrvaFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbGr+ydTwWb2isuP
	VjM1MHaydTFyckgImEhs3zuBCcIWk7hwbz1YXEhgGaPE8z1WMDUTj31l7mLkAoovYpTYNnUh
	K4TTxiSxseEIUAcHB5uAtsTm/QYgDSICzBILpp5nBKlhFpjAKPF/0XsWkISwgK/EytsvwDaw
	CKhKfPnUDbaZV8BdYt2LBSwQ23QlVv9/zg5icwp4SGy9e4oRZL4QUM3rcyUgMyUEfrNJPJuz
	FmqOgMS3yYdYQGokBGQlNh1ghhgjKXFwxQ2WCYzCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXr
	JefnbmKEBOyEHYz3DlgfYkwGGjeRWUo0OR8Y8Hkl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcK
	CaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDR3WCw6ae8DdhGdC9PEw/lYjH3FtjO+DfYpDVj4
	XnLjmse28RImy76nJjK+U3yX+TAl2HZH47qQ3WGF6w+dO7bTJWCbu4NfR5zb9ccCN6+rTecy
	T5T/XLTxh4uT2VJfLqPVbSV+Z12XeiT6Fcivn8a9fotB2pzmVZKPo57vXBDYfOdHqtr7T0os
	xRmJhlrMRcWJAFCei91uAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDb6tVrO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFjV/dPpoLN7BWXH61mamDsZOti5OSQEDCRmHjsKzOELSZx4d56oDgXh5DA
	IkaJbVMXskI4bUwSGxuOAGU4ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96zgCSEBXwl
	Vt5+AbaBRUBV4sunbiYQm1fAXWLdiwUsENt0JVb/f84OYnMKeEhsvXuKEWS+EFDN63MlExh5
	FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjohn0jsYVzVYHGIU4GBU4uEVCJgZKMSa
	WFZcmXuIUYKDWUmEN7obKMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wGjNK4k3NDYxM7I0
	MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGubUrb848q5r0a0HKL+HuGZWT
	luaFXDfyfr+lrelElX6LyPvFDze57FtyumGLSapI8wHN7Nf77nvNNHWLSD2sP3vVhuWKZpxx
	LU/1N7vP/1Zb+yiZ9+fEM3OT7ivdunkj8Os7Dv1Nqw90vDB34nuXu3DxI8VCzz2L19VeXzv5
	ce2dJZpaWZuVryixFGckGmoxFxUnAgB+6ZB3zAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If get_dnode_of_data gets a locked node page, let's skip redundant
get_node_page calls.
This is for the futher enhancement.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9641534..f63f0a4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -408,10 +408,13 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 	level = get_node_path(index, offset, noffset);
 
 	nids[0] = dn->inode->i_ino;
-	npage[0] = get_node_page(sbi, nids[0]);
-	if (IS_ERR(npage[0]))
-		return PTR_ERR(npage[0]);
+	npage[0] = dn->inode_page;
 
+	if (!npage[0]) {
+		npage[0] = get_node_page(sbi, nids[0]);
+		if (IS_ERR(npage[0]))
+			return PTR_ERR(npage[0]);
+	}
 	parent = npage[0];
 	if (level != 0)
 		nids[1] = get_nid(parent, offset[0], true);
-- 
1.8.1.3.566.gaa39828

