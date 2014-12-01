Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaLADbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:31:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28510 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaLADbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:31:16 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-df-547be1014851
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: fix to return correct error number in
 f2fs_write_begin
Date: Mon, 01 Dec 2014 11:30:20 +0800
Message-id: <002001d00d17$41d48500$c57d8f00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdANFrftFSJttHyiSgyHzWpOXqfmBw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAV3Gh9UhBm0b5C2u7Wtksniyfhaz
	xaVF7hZ79p5ksbi8aw6bA6vHplWdbB67F3xm8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	51+nMBecYak40LOUrYHxEnMXIyeHhICJxIsrs6BsMYkL99azdTFycQgJLGKUWHPqGiOE84NR
	4syHfrAqNgEVieUd/5lAbBEBL4lJ+0+wgNjMApkS95pmgNUIC0RKXH17jR3EZhFQleh7uQWs
	nlfAUuLmon/MELagxI/J96B6tSTW7zzOBGHLS2xe8xbqIgWJHWdfAx3BAbRLT+LpIRWIEnGJ
	jUdusUxgFJiFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBwf1M
	egfjqgaLQ4wCHIxKPLyS86tDhFgTy4orcw8xSnAwK4nwnvMACvGmJFZWpRblxxeV5qQWH2KU
	5mBREue9cTM3REggPbEkNTs1tSC1CCbLxMEp1cCosyC5WmPvvWRRZuM9+54IbBEUT1y3VnB6
	2l7te2k7/PIf3E7dfur7v79X9jzPXdwRYqcqI7JR+Ovcj+cmilUvbFc4uOyzx+vNK1ZZHkw1
	z9UNZF0fpjWhK4hBpCHxxMa/szoUI8JPs5u+PP9b9igz7xLB8i1/FBsX/mZZ6Bf/ye/Xpg+X
	+Rp2KbEUZyQaajEXFScCANTsjrRqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the wrong error number in error path of f2fs_write_begin.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c7bc626..7ec697b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -960,8 +960,10 @@ repeat:
 
 	/* check inline_data */
 	ipage = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(ipage))
+	if (IS_ERR(ipage)) {
+		err = PTR_ERR(ipage);
 		goto unlock_fail;
+	}
 
 	set_new_dnode(&dn, inode, ipage, ipage, 0);
 
-- 
2.1.2


