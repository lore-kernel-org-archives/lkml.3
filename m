Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3L0EBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:01:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3L0EBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:01:36 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-8f-52bcfb9d0934
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/6] f2fs: don't need to get f2fs_lock_op for the inline_data
 test
Date: Fri, 27 Dec 2013 13:00:15 +0900
Message-id: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zQ925v/cEGax4aWBxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8alvrKCjZwVE39P
	YGpgvMbexcjJISFgIrHkxg0mCFtM4sK99WxdjFwcQgLLGCWuP9zEClP0+88eFojEdEaJo4/m
	MIMkhASamSTaZvJ2MXJwsAloS2zebwASFhFgllgw9TwjSD2zwARGif+L3rOA1AgLhEg82c0D
	UsMioCox4ed+sDG8Au4S7+4cYYTYpS2x7flEsF4JgcdsEt8bWlghGgQkvk0+BDZHQkBWYtMB
	Zoh6SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJPwm7mC8f8D6EGMy
	0LiJzFKiyfnA8M0riTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrx
	IUYmDk6pBsbW+heiARmx78vrjhqWtM3sm/HxQXx3zNfOTfX6m+fN2XcgynSL4EJt00cuamYr
	2apv/XI9tXfnPK5zhR0Pz4T+VPUp+v7J/MHlP6tvL77ydCFz4sIojommbziueU73V7ple/5i
	fT3r+lvek/YXP9zS8Z/X44FGw52TOof2PhXTa3Ep5DdjXeKlxFKckWioxVxUnAgA5XwZPlUC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQd25v/cEGZxr0LW4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjUl9ZwUbOiom/JzA1MF5j72Lk5JAQMJH4/WcPC4QtJnHh3nq2LkYuDiGB
	6YwSRx/NYQZJCAk0M0m0zeTtYuTgYBPQlti83wAkLCLALLFg6nlGkHpmgQmMEv8XvWcBqREW
	CJF4spsHpIZFQFViws/9YGN4Bdwl3t05wgixS1ti2/OJjBMYuRcwMqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECA7uZ9I7GFc1WBxiFOBgVOLhddiwJ0iINbGsuDL3EKMEB7OSCO/nK0Ah
	3pTEyqrUovz4otKc1OJDjMlA2ycyS4km5wMjL68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGONFv379z2Lkkj39ctxhv2D5044sa6z/MgSpu2wTXaqUoT0x
	9m/0xqDpq5Z/Omm4R8Rq1qvKLfYv6uOT1OqWKnZdPzxZ6de6lQsK3Zo4E/ZPKP8588ujPR+3
	bOm+4uFn0tp19bxo2UaZHr+JHnffzswRdZRdL1TkcY//+1k7kdzYbPENjoueJiqxFGckGmox
	FxUnAgBRU6DCsgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch locates checking the inline_data prior to calling f2fs_lock_op()
in truncate_blocks(), since getting the lock is unnecessary.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index dd80e72..7ef2d6a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -261,14 +261,14 @@ static int truncate_blocks(struct inode *inode, u64 from)
 
 	trace_f2fs_truncate_blocks_enter(inode, from);
 
+	if (f2fs_has_inline_data(inode))
+		goto done;
+
 	free_from = (pgoff_t)
 			((from + blocksize - 1) >> (sbi->log_blocksize));
 
 	f2fs_lock_op(sbi);
 
-	if (f2fs_has_inline_data(inode))
-		goto done;
-
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, free_from, LOOKUP_NODE);
 	if (err) {
@@ -295,9 +295,8 @@ static int truncate_blocks(struct inode *inode, u64 from)
 	f2fs_put_dnode(&dn);
 free_next:
 	err = truncate_inode_blocks(inode, free_from);
-done:
 	f2fs_unlock_op(sbi);
-
+done:
 	/* lastly zero out the first data page */
 	truncate_partial_data_page(inode, from);
 
-- 
1.8.4.474.g128a96c

