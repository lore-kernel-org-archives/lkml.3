Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3HZM2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:28:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31045 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3HZM2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:28:11 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-c6-521b49d957d1
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix omitting to update inode page
Date: Mon, 26 Aug 2013 21:28:02 +0900
Message-id: <1377520082-20526-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA92bntJBBnfnallc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHxzV6Wgq2sFXee
	hzYw7mLpYuTkkBAwkZjVe5QRwhaTuHBvPVsXIxeHkMAyRomNM+czwxV9Oc4KkZjOKDG5cwMT
	hNPGJLHuzm4gh4ODTUBbYvN+A5AGEQFmiQVTzzOC1DALTGCU+L/oPdg6YQELid8Xj7CB2CwC
	qhLNLe9ZQWxeAXeJNx2noc7QlVh04iDYNgmB+2wS104sYYRoEJD4NvkQC8gyCQFZiU0HoK6T
	lDi44gbLBEbBBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFCQrB/B+PdA9aHGJOBxk1k
	lhJNzgeGcF5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGJuy+mVPF1hqf5SQvBypy5hcP8X2e9IKw5NP56953/1ju36Q5LfJBhPW6E9/E6G4nGG3
	z3c/LQ+HJPY+lmeNmsaPOS40GnGsXeX+60cT1wKlDzoOJ3fePriv9sEEY7E4+3jZa3fPPdBq
	/t7ElBX6XFNmVop/yo2yrMcRGwNT5iXxmv/8feBAgBJLcUaioRZzUXEiABlyunpXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2bntJBBtOWqFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx8c1eloKtrBV3noc2MO5i6WLk5JAQMJGY9eU4K4QtJnHh3nq2LkYuDiGB
	6YwSkzs3MEE4bUwS6+7sBnI4ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96DTRUWsJD4
	ffEIG4jNIqAq0dzyHmwDr4C7xJuO04wQ23QlFp04yDqBkXsBI8MqRtHUguSC4qT0XEO94sTc
	4tK8dL3k/NxNjOAAfya1g3Flg8UhRgEORiUe3sACqSAh1sSy4srcQ4wSHMxKIrzmotJBQrwp
	iZVVqUX58UWlOanFhxiTgbZPZJYSTc4HRl9eSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTS
	E0tSs1NTC1KLYLYwcXBKNTBapfXZtmqZylU/lTrV58xhU23pJVRiembyx+0cKy1NLzU29Pkz
	nfpqGHCMRf21uWq7hlVW3I+sy8+mvuOYfffI5lzVqXyvqtoniDAeDlz0RPqY2oq3m1+eljnz
	fe5c8Tj+36sqHwiJqs+QOBkkaX/ZpzZaPnoFe+3MrlVB3hpnFi6XnTuVM1GJpTgj0VCLuag4
	EQAWjnVgtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The f2fs_set_link updates its parent inode number, so we should sync this to
the inode block.
Otherwise, the data can be lost after sudden-power-off.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 4e47518..9e90d31 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -447,6 +447,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		else
 			release_orphan_inode(sbi);
 
+		update_inode_page(old_inode):
 		update_inode_page(new_inode);
 	} else {
 		err = f2fs_add_link(new_dentry, old_inode);
-- 
1.8.3.1.437.g0dbd812

