Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaIKMbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:31:40 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47847 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbaIKM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 9/9] drbd: Add missing newline in resync progress display in /proc/drbd
Date: Thu, 11 Sep 2014 14:29:13 +0200
Message-Id: <1410438553-30440-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was broken in 2010 with commit 4b0715f096

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 06e6147..3b10fa6 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -142,10 +142,12 @@ static void drbd_syncer_progress(struct drbd_device *device, struct seq_file *se
 			    (unsigned long) Bit2KB(rs_left >> 10),
 			    (unsigned long) Bit2KB(rs_total >> 10));
 	else
-		seq_printf(seq, "(%lu/%lu)K\n\t",
+		seq_printf(seq, "(%lu/%lu)K",
 			    (unsigned long) Bit2KB(rs_left),
 			    (unsigned long) Bit2KB(rs_total));
 
+	seq_printf(seq, "\n\t");
+
 	/* see drivers/md/md.c
 	 * We do not want to overflow, so the order of operands and
 	 * the * 100 / 100 trick are important. We do a +1 to be
-- 
1.9.1

