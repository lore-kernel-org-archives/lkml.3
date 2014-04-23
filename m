Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaDWF0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:26:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36757 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaDWFZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:25:54 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-cf-53574ed7bfef
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] f2fs: return errors right after checking them
Date: Wed, 23 Apr 2014 14:23:32 +0900
Message-id: <1398230612-7062-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1398230612-7062-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1398230612-7062-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zQ93rfuHBBs82sFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFv83vGgmNsFf+2
	fGFpYJzL2sXIySEhYCLxZtUZNghbTOLCvfVANheHkMAyRonvrfPgig5uOs4MkVjEKPFowysm
	CKeTSWLmu6NADgcHm4C2xOb9BiANIgLMEgumnmcEqWEWmMAo8X/RexaQhLCAk8S/hb/YQWwW
	AVWJ3X9fMILYvAJuErtvzmWG2KYtse35RLA4p4C7xMmN68CuEAKqeTZxPth5EgLf2STmzbvI
	BjFIQOLb5EMsIEdICMhKbDoANUdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dL
	zs/dxAgJ2t4djLcPWB9iTAYaN5FZSjQ5Hxj0eSXxhsZmRhamJqbGRuaWZqQJK4nzJj1MChIS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmD/h06lHcbOu907YGOHaPmdWWT7HhsPMs98JWhbX
	mk+e+Kk5S23ak1tOB1b/1SqMFRI7H583UUkurTOo0O3Xcs5y6Tfbn53+eszXqMazqXTPlz+K
	IXWrlZMD/TJZVodqPGpMSutRa1ls/+pAE6PKuvUX5y/5qsmeK2DQZHbBwSzJk/HNSS1DJZbi
	jERDLeai4kQAkMv8fHACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd3rfuHBBtdvMltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxb/N7xoJjbBX/tnxhaWCcy9rFyMkhIWAicXDTcWYIW0ziwr31bF2MXBxC
	AosYJR5teMUE4XQyScx8dxTI4eBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96zwKSEBZw
	kvi38Bc7iM0ioCqx++8LRhCbV8BNYvfNuVDbtCW2PZ8IFucUcJc4uXEd2EVCQDXPJs5nm8DI
	u4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcEw8k9rBuLLB4hCjAAejEg9vwcqwYCHW
	xLLiytxDjBIczEoivDM/AoV4UxIrq1KL8uOLSnNSiw8xJgNdNZFZSjQ5HxiveSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAyJt4POnbpZB1FxbZhiV9m56x
	k/n4pVW2QUeSHq826tvT6qHEaqClmuHrZRjtsbfRU3i7JLv4v+kZziun3avpum+llHRpT2XE
	bZU7mVs6zTn5uvpXT3du3+LnqBUVFsO77dmTn6k79k1zXvg85eqhNzzpe76Zrd7EO3trvADf
	0y0c1m+k2XXPKLEUZyQaajEXFScCALqkEFvNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two error conditions early in the setxattr operations.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/xattr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index bbe9c2b..6073f9f 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -509,8 +509,16 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	here = __find_xattr(base_addr, index, len, name);
 
 	found = IS_XATTR_LAST_ENTRY(here) ? 0 : 1;
-	last = here;
 
+	if ((flags & XATTR_REPLACE) && !found) {
+		error = -ENODATA;
+		goto exit;
+	} else if ((flags & XATTR_CREATE) && found) {
+		error = -EEXIST;
+		goto exit;
+	}
+
+	last = here;
 	while (!IS_XATTR_LAST_ENTRY(last))
 		last = XATTR_NEXT_ENTRY(last);
 
-- 
1.8.4.474.g128a96c

