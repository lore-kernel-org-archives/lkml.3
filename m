Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbaCSIEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:04:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64435 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaCSIEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:04:11 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-66-53294f6d4cf8
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/5] f2fs: avoid to drop nat entries due to the negative
 nr_shrink
Date: Wed, 19 Mar 2014 17:02:05 +0900
Message-id: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zQ91cf81gg0VrOCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjj59DJrwV7Wiobn
	1xkbGA+ydDFyckgImEgc6njBDGGLSVy4t56ti5GLQ0hgGaPElCM7GGGKGrtfsEMkpjNKTL33
	iBnC6WSSWDjtJpDDwcEmoC2xeb8BSIOIALPEgqnnGUFqmAUmMEr8X/QebJ2wQIjE2t1fWUFs
	FgFViQWT97GD2LwC7hINl9azQ2zTltj2fCJYs4TAfTaJDxOmsEE0CEh8m3yIBWSZhICsxKYD
	UGdLShxccYNlAqPgAkaGVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxghQdi7g/H2AetDjMlA
	4yYyS4km5wODOK8k3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGGc0S+S1Kn4R+M9yfq1UrPj7UFaj5E9HQr1TF7GltP3Z88WNRS958YZHht+miW7O
	KTp6e6nJM/eXViWzfspwy7sG5udm+77i7KnZrxG7way+2uNl6fI7P+0mzffb+y6dQWYqZyR7
	4f6+z3XSXV2TLRxOZ8pW5i6ZvN8qObvA7VfSvMn6q8MNlViKMxINtZiLihMBC3+WHlgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd1cf81gg49vWSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4+fQya8Fe1oqG59cZGxgPsnQxcnJICJhINHa/YIewxSQu3FvP1sXIxSEk
	MJ1RYuq9R8wQTieTxMJpN4EcDg42AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3YFOFBUIk
	1u7+ygpiswioSiyYvA9sA6+Au0TDpfVQ27Qltj2fyDiBkXsBI8MqRtHUguSC4qT0XEO94sTc
	4tK8dL3k/NxNjOAQfya1g3Flg8UhRgEORiUe3gNRGsFCrIllxZW5hxglOJiVRHiF7wKFeFMS
	K6tSi/Lji0pzUosPMSYDbZ/ILCWanA+Mv7ySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYJwnP71QwMRqU3PGzRNTQxZPbl1Yvsnz88HbGvPEZ0Y15WjMUGTj
	0g0W1ZuVtbBa039Peh7vV6+70bNtuqZ99z+76EBr8Hbz7yuSVBI/8WQH7NJ7dLmQTfPvon/h
	lw1m2F87k7RNX21HeWIeH//j22ePX7o7sX7pXK++K/d2vrgU7K9UeZ9rxnQlluKMREMt5qLi
	RAC/EY7+tQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The try_to_free_nats should not receive the negative nr_shrink.
Otherwise, it can drop all the nat entries by the while loop.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 707fd20..04450a5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -208,7 +208,7 @@ int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
-	if (nm_i->nat_cnt <= NM_WOUT_THRESHOLD)
+	if (nm_i->nat_cnt <= NM_WOUT_THRESHOLD || nr_shrink <= 0)
 		return 0;
 
 	write_lock(&nm_i->nat_tree_lock);
-- 
1.8.4.474.g128a96c

