Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbaHFTPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:15:46 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:34213 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbaHFTPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:15:45 -0400
From: Evgeny Budilovsky <budevg@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <green@linuxhacker.ru>, Peng Tao <bergwolf@gmail.com>,
        Lai Siyao <lai.siyao@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/lustre: use rcu_dereference to access rcu protected current->real_parent field
Date: Wed, 6 Aug 2014 21:22:43 +0300
Message-ID: <87k36ltoob.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Evgeny Budilovsky <budevg@gmail.com>
---
 drivers/staging/lustre/lustre/llite/lproc_llite.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 77f68b5..7e61468 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -910,7 +910,8 @@ void ll_stats_ops_tally(struct ll_sb_info *sbi, int op, int count)
 		 sbi->ll_stats_track_id == current->pid)
 		lprocfs_counter_add(sbi->ll_stats, op, count);
 	else if (sbi->ll_stats_track_type == STATS_TRACK_PPID &&
-		 sbi->ll_stats_track_id == current->real_parent->pid)
+		 sbi->ll_stats_track_id ==
+			rcu_dereference(current->real_parent)->pid)
 		lprocfs_counter_add(sbi->ll_stats, op, count);
 	else if (sbi->ll_stats_track_type == STATS_TRACK_GID &&
 		 sbi->ll_stats_track_id ==
-- 
1.8.1.2

