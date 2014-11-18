Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaKRDSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:18:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64490 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaKRDSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:18:07 -0500
X-AuditID: cbfee61a-f79c06d000004e71-77-546aba6de5e1
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/3] f2fs: remove unneeded check code with option in
 f2fs_remount
Date: Tue, 18 Nov 2014 11:17:20 +0800
Message-id: <006701d002de$45007ec0$cf017c40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAC3eGHvQsS2I6DQiacr3WaiIoIBA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd3cXVkhBp0d1hbX9jUyWTxZP4vZ
	4tIid4vLu+awObB4bFrVyeaxe8FnJo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKmPhwLkvB
	H46KdTc/MzcwzmbvYuTkkBAwkZg9v4MNwhaTuHBvPZDNxSEkMJ1RYvaDDhYI5wejxPypb5lA
	qtgEVCSWd/wHs0UEvCQm7T/BAmIzC3hINHZ8ZwWxhQViJf7s2AoWZxFQlbi05zIziM0rYCnR
	u7UbyhaU+DH5HlSvlsT6nceZIGx5ic1r3jJDXKQgsePsa0aIXXoSx18vZYeoEZfYeOQWywRG
	gVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc1M+kdjCubLA4
	xCjAwajEw5swNStEiDWxrLgy9xCjBAezkgjvuW6gEG9KYmVValF+fFFpTmrxIUZpDhYlcd4D
	rdaBQgLpiSWp2ampBalFMFkmDk6pBkbPJt7T9ULOqfXHq17fFeFhOW7HYuAiv6eU7WLcmXOv
	uW/2LVe6U9a9PEb7xxPxuPzIQOZ7B73c8lufa9x4pZvL0fbc8Uu/47s1byvrczmUKjPdp5do
	ZtvYJL+3viYw6fiTkPijwiZRZ3sunJD83b7HZdrSP2+2x//zOCDjuOBdeBXviTuuk5VYijMS
	DbWYi4oTAUnCtrNmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we have checked the contrary condition in case of "if" judgment, we do
not need to check the condition again in case of "else" judgment. Let's remove
it.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 536d414..f71421d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -669,7 +669,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 			f2fs_sync_fs(sb, 1);
 			need_restart_gc = true;
 		}
-	} else if (test_opt(sbi, BG_GC) && !sbi->gc_thread) {
+	} else if (!sbi->gc_thread) {
 		err = start_gc_thread(sbi);
 		if (err)
 			goto restore_opts;
@@ -682,7 +682,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	 */
 	if ((*flags & MS_RDONLY) || !test_opt(sbi, FLUSH_MERGE)) {
 		destroy_flush_cmd_control(sbi);
-	} else if (test_opt(sbi, FLUSH_MERGE) && !SM_I(sbi)->cmd_control_info) {
+	} else if (!SM_I(sbi)->cmd_control_info) {
 		err = create_flush_cmd_control(sbi);
 		if (err)
 			goto restore_gc;
-- 
2.1.2


