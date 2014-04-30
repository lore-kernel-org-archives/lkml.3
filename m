Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbaD3GVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:21:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58790 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaD3GVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:21:49 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-e0-5360967c1bbd
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: deactivate inode page if the inode is evicted
Date: Wed, 30 Apr 2014 15:19:36 +0900
Message-id: <1398838776-24672-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zfd2aaQnBBgtv81hc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTHn+xrGglssFYsu
	L2JrYPzF3MXIySEhYCJx+MdvVghbTOLCvfVsXYxcHEICyxglps7+xARTtG3VRhaIxHRGiY8z
	DkI5nUwSPUe62LsYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4AkhAVcJFpm7ANb
	xyKgKvF45Ql2EJtXwF3i0qaNUCdpS2x7PhGsWULgMZvEvqtzWCAaBCS+TT7EArJMQkBWYtMB
	qHpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMkCCfuYLx/wPoQYzLQ
	uInMUqLJ+cAgziuJNzQ2M7IwNTE1NjK3NCNNWEmcN/1RUpCQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGxgMFLC+t7tpZaJxonZXJKPNEfU6W7WuOeqHVmm/kPy9ZtEQxNHdLs/Kn79Lrfgfc
	tJzy/KIlw+4urXzpR5+TVDeVuupYTPgW9ke9c4EO+4adS6Le7dMU27KrI1TeRaR3e35Nr0HJ
	DcbJzE//Hb/5nOkaQ6bzxOZs12zHrXceZW3g9DIOst+0U4mlOCPRUIu5qDgRAPv9NahYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd2aaQnBBjP/clhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5gx5/saxoJbLBWLLi9ia2D8xdzFyMkhIWAisW3VRhYIW0ziwr31bF2MXBxC
	AtMZJT7OOMgC4XQySfQc6WLvYuTgYBPQlti83wCkQUSAWWLB1POMIDXMAhMYJf4veg82SVjA
	RaJlxj5WEJtFQFXi8coT7CA2r4C7xKVNG6E2a0tsez6RcQIj9wJGhlWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwSH+TGoH48oGi0OMAhyMSjy8Alvjg4VYE8uKK3MPMUpwMCuJ8GZ0JAQL
	8aYkVlalFuXHF5XmpBYfYkwG2j6RWUo0OR8Yf3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4U
	EkhPLEnNTk0tSC2C2cLEwSnVwJi/Y993u2XHN/o/eSLnGmi/lPnY4v0tfFcNutj3bDWdbSiY
	ufA7v6Xw1nU+Pt4PK7u61rur3m1Y+dlKvtxOdHekPBcz99vbXh2v95wpjrNaYHbkiVH89yz5
	KZHRV3f7Xpkitp/jY1ggn9901pccxSIHTH+Z93v8tPnh2vIk5a25Gfuah5dPOiixFGckGmox
	FxUnAgBacKUctQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the inode page is clean during its inode eviction, it'd better drop the page
to reduce further memory pressure.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index f7a6553..adc622c 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -295,4 +295,5 @@ void f2fs_evict_inode(struct inode *inode)
 	sb_end_intwrite(inode->i_sb);
 no_delete:
 	clear_inode(inode);
+	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
 }
-- 
1.8.4.474.g128a96c

