Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaDDJHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:07:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26105 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaDDJHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:07:30 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-50-533e7650f70f
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: fix wrong statistics of inline data
Date: Fri, 04 Apr 2014 17:06:33 +0800
Message-id: <000001cf4fe5$4e9d4af0$ebd7e0d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9PykJkKsps66fwT0e9yjZXPnQ5hA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd2AMrtgg8UHTC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgylj+7Dx7wRfWiqaZ
	/YwNjM9Yuhg5OSQETCQmTtvODGGLSVy4t56ti5GLQ0hgOqPEiRmvGSGcH4wSsxbdZAOpYhNQ
	kVje8Z8JxBYRUJTY8H4DO4jNLJApca9pBtgkYQFXiXXT7gJt4OBgEVCVWHNPEyTMK2Ap8fLd
	MhYIW1Dix+R7LBCtWhLrdx5ngrDlJTaveQt1kILEjrMgN4Cs0pN4N+8dG0SNuMTGI7dYJjAK
	zEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBAfia1g3Flg8Uh
	RgEORiUeXo5022Ah1sSy4srcQ4wSHMxKIrx9gXbBQrwpiZVVqUX58UWlOanFhxilOViUxHkP
	tFoHCgmkJ5akZqemFqQWwWSZODilGhgXnzs873zXo699oTf3xF5WOamRGHvGv9fmbN/F3rk3
	10xjLZ/l9CP564u6l1vTbr6rf3mYqbyG48+HOyv2c0zOOad+motP+Xzc/Yxe4ct5Db7TeXo5
	TgUVSu3pfOPa7dFrodMbX1v6Rf9S3drbYQfXXBTa9X/P594L5/nWeics8d4yZ2LXlotpSizF
	GYmGWsxFxYkAoiwEFGACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we remove a file that has inline data after mount, our statistics turns to
inaccurate.

cat /sys/kernel/debug/f2fs/status
  - Inline_data Inode: 4294967295

Let's add stat_inc_inline_inode() to stat inline info of the file when lookup.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 0d8e4a2..4f1c225 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -112,6 +112,8 @@ static int do_read_inode(struct inode *inode)
 	get_extent_info(&fi->ext, ri->i_ext);
 	get_inline_info(fi, ri);
 
+	stat_inc_inline_inode(inode);
+
 	/* get rdev by using inline_info */
 	__get_inode_rdev(inode, ri);
 
-- 
1.7.9.5


