Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaCLJJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:09:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36058 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaCLJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:09:35 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-e2-532024456d08
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: check upper bound of ino value in
 f2fs_nfs_get_inode
Date: Wed, 12 Mar 2014 17:08:36 +0800
Message-id: <001601cf3dd2$c17795a0$4466c0e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac890iAi/RDaVZ4STu+IayXtMjytcw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQV1XFYVgg3X7BSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvj7YDZLwX3Wip7d
	F9gaGG+wdDFyckgImEj8//CUDcIWk7hwbz2QzcUhJDCdUWLqncmsEM4PRom2829YQarYBFQk
	lnf8ZwKxRQQUJTa838AOYjMLZErca5rBDGILC0RIbNl/AaiGg4NFQFXiSLsiSJhXwFJiXstb
	NghbUOLH5HssEK1aEut3HmeCsOUlNq95ywxxkILEjrOvGSFW6Un8uz8TapW4xMYjt1gmMArM
	QjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4EB+JrWDcWWDxSFG
	AQ5GJR7eBZrywUKsiWXFlbmHGCU4mJVEeIVEFIKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5o
	tQ4UEkhPLEnNTk0tSC2CyTJxcEo1MO74o7A6/vIMmzUek+0XXTIRtc2fPXPXD4enB/drWc1v
	CHwXKrbywNwsj1nX3q627d736F/I6Qn2beJbnVOuVvRfDZv55teqaWbrdkny3WMWmnK067hp
	TYXoNBa++UJt2ZVNzxIZFiTHTj53OOGY2daTi5L/zFwTt1BHWur+M3WPe7Iqtm17hfqUWIoz
	Eg21mIuKEwGJz7ByYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upper bound checking of ino should be added to f2fs_nfs_get_inode, so unneeded
process before do_read_inode in f2fs_iget could be avoided when ino is invalid.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6e4851c..3a51d7a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -644,6 +644,8 @@ static struct inode *f2fs_nfs_get_inode(struct super_block *sb,
 
 	if (unlikely(ino < F2FS_ROOT_INO(sbi)))
 		return ERR_PTR(-ESTALE);
+	if (unlikely(ino >= NM_I(sbi)->max_nid))
+		return ERR_PTR(-ESTALE);
 
 	/*
 	 * f2fs_iget isn't quite right if the inode is currently unallocated!
-- 
1.7.9.5

