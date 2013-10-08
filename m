Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3JHAdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:33:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42314 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3JHAdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:33:46 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-6f-525352e93c6c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: avoid unnecessary checkpoints
Date: Tue, 08 Oct 2013 09:33:15 +0900
Message-id: <1381192395-30296-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zQ92XQcFBBoeuKVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfH16S+WgtlsFU+3
	NbI1ME5h7WLk5JAQMJGYu+0rlC0mceHeerYuRi4OIYFljBLH+vuYYYqWrF/ECpGYzihx+vd0
	RginmUlix+1vLF2MHBxsAtoSm/cbgDSICDBLLJh6HqyGWWACo8T/Re9ZQBLCQJOWzTsGNpVF
	QFWi//l0sNW8Au4SHydvgNqmLbHt+USwZgmB+2wS6yddhWoQkPg2+RDYMgkBWYlNB6DqJSUO
	rrjBMoFRcAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkCCcuIPx/gHrQ4zJQOMmMkuJ
	JucDgzivJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYwKW233rt7KMn+d2skJVnF8k1YWLLvbxanFndZc/K9UQSfsu9Fn1jz2WImkFb0fJqyI+T3/
	y13zz1/yTfd2Wix7cVSmf2tknUP4+2XH90s5LVj2xdaL46/SpMiZJ7dWWvqbXDg55x/z2fRA
	nSbtiw8mrj6//XHAwR39G8uk1jE9aKn4+X960LFsJZbijERDLeai4kQA5iacxlgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd2XQcFBBp8a5Cyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8z4+vQXS8Fstoqn2xrZGhinsHYxcnJICJhILFm/CMoWk7hwbz1bFyMXh5DA
	dEaJ07+nM0I4zUwSO25/Y+li5OBgE9CW2LzfAKRBRIBZYsHU82A1zAITGCX+L3rPApIQBpq6
	bN4xZhCbRUBVov/5dLANvALuEh8nb2CG2KYtse35RMYJjNwLGBlWMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgSH+DOpHYwrGywOMQpwMCrx8AocDgoSYk0sK67MPcQowcGsJMIrYBQcJMSb
	klhZlVqUH19UmpNafIgxGWj7RGYp0eR8YPzllcQbGpuYGVkamVkYmZibkyasJM57oNU6UEgg
	PbEkNTs1tSC1CGYLEwenVAOju+L9/633/2zKXugZlFIpWPzqbMJ3jceWyn9vfqsPuvt6fskJ
	PX/F9ccc9HqL06pvhu95OtMzbKXn0oPbWEVq5m3umPe7if/Chi+TNhzV0su2vxZYcntCzV2X
	WYveBKht+2Pwd4356ybJa7YVZW8+LPg4Z1qVj630KSZWd37r3C9xNQ1PeZdZK7EUZyQaajEX
	FScCAEaCFTy1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the f2fs_put_super procedure, we don't need to conduct checkpoint all
the time, since we don't need to do that if superblock is clean.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index fde8e6a..539c009 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -372,7 +372,9 @@ static void f2fs_put_super(struct super_block *sb)
 	f2fs_destroy_stats(sbi);
 	stop_gc_thread(sbi);
 
-	write_checkpoint(sbi, true);
+	/* We don't need to do checkpoint when it's clean */
+	if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
+		write_checkpoint(sbi, true);
 
 	iput(sbi->node_inode);
 	iput(sbi->meta_inode);
-- 
1.8.4.474.g128a96c

