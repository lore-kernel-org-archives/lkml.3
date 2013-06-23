Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3FWWvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 18:51:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59482 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3FWWvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 18:51:51 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-42-51c77c0095f9
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix an endian conversion bug detected by sparse
Date: Mon, 24 Jun 2013 07:51:45 +0900
Message-id: <1372027905-24393-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zI12GmuOBButecFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbHjwTu2gh08Fa+n
	LWNqYFzL1cXIySEhYCJxevtPJghbTOLCvfVsXYxcHEICyxglFu3YxghT9HfFLqjEdEaJa23z
	WSGcNiaJJ1NvAFVxcLAJaEts3m8A0iAiwCyxYOp5RpAaZoEJjBL/F71nAakRFnCTODRfE6SG
	RUBVYs7Si+wgNq+Au8T0Ra+glulKLDpxEGy+hMB9NolZH/czQzQISHybfAhsjoSArMSmA8wQ
	9ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkgI9u5gvH3A+hBjMtC4
	icxSosn5wBDOK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAPjzPVzp0813nQx6Ljn6Zfzb/VnBh08qxR4y9Phi5b1ZuM37xwtp+w68DTG2H9Z7Lb4
	tdaT3de7ue2PSnjLdFU7mN3zQVPl8hefj226l/smurBjcdXGluQ4v0Pv+T99+a2puPbSsk3P
	jmnttjrRFjHht/6ExYwFFkdjTi/uZTkuGKb9Y+ETpxdn7iixFGckGmoxFxUnAgAoV1vpVwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV2GmuOBBqe/sllc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix48E7toIdPBWvpy1jamBcy9XFyMkhIWAi8XfFLjYIW0ziwr31QDYXh5DA
	dEaJa23zWSGcNiaJJ1NvMHYxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwGpERZw
	kzg0XxOkhkVAVWLO0ovsIDavgLvE9EWvGCGW6UosOnGQdQIj9wJGhlWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwQH+THoH46oGi0OMAhyMSjy8C8yPBwqxJpYVV+YeYpTgYFYS4e21Agrx
	piRWVqUW5ccXleakFh9iTAbaPpFZSjQ5Hxh9eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQS
	SE8sSc1OTS1ILYLZwsTBKdXAaLiV63tm6y/tjXkbq7dfdKsOOBD1vt7jud71VL0kHYObO+eu
	O8DUmJLFk3GT0TDYfGoff2rRHeHkioaCqGX6EYZv5GSi9Of13j2cuSplV+mkaEO3Gy/3yjKz
	zL5tdv7V1CliOtr6Xzbm5U1/f0s2RJstWTXjp/B8g+KQH5nLGN+eSI1St9NVYinOSDTUYi4q
	TgQA2EQ8nbQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should fix the following bug reported by kbuild test robot.

fs/f2fs/recovery.c:233:33: sparse: incorrect type in assignment
(different base types)

parse warnings: (new ones prefixed by >>)

>> fs/f2fs/recovery.c:233:33: sparse: incorrect type in assignment (different base types)
   fs/f2fs/recovery.c:233:33:    expected unsigned int [unsigned] [assigned] ofs_in_node
   fs/f2fs/recovery.c:233:33:    got restricted __le16 [assigned] [usertype] ofs_in_node
>> fs/f2fs/recovery.c:238:33: sparse: incorrect type in assignment (different base types)
   fs/f2fs/recovery.c:238:33:    expected unsigned int [unsigned] ofs_in_node
   fs/f2fs/recovery.c:238:33:    got restricted __le16 [assigned] [usertype] ofs_in_node

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index ddde14f..9db8239 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -246,12 +246,12 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 		struct dnode_of_data tdn = *dn;
 		tdn.nid = nid;
 		tdn.node_page = dn->inode_page;
-		tdn.ofs_in_node = sum.ofs_in_node;
+		tdn.ofs_in_node = le16_to_cpu(sum.ofs_in_node);
 		truncate_data_blocks_range(&tdn, 1);
 		return 0;
 	} else if (dn->nid == nid) {
 		struct dnode_of_data tdn = *dn;
-		tdn.ofs_in_node = sum.ofs_in_node;
+		tdn.ofs_in_node = le16_to_cpu(sum.ofs_in_node);
 		truncate_data_blocks_range(&tdn, 1);
 		return 0;
 	}
-- 
1.8.3.1.437.g0dbd812

