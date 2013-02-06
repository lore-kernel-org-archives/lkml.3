Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3BFPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:16:58 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:41452 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3BFPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:16:50 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 12/14] sg_io: remove remnants of sysfs SG_IO filters
Date: Wed,  6 Feb 2013 16:15:59 +0100
Message-Id: <1360163761-8541-13-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some defines and structs remained when support was removed for SG_IO
filters in sysfs.  Remove them.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/genhd.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 79b8bba..d3bc249 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -144,15 +144,6 @@ enum {
 	DISK_EVENT_EJECT_REQUEST		= 1 << 1, /* eject requested */
 };
 
-#define BLK_SCSI_MAX_CMDS	(256)
-#define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
-
-struct blk_scsi_cmd_filter {
-	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
-	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-	struct kobject kobj;
-};
-
 struct disk_part_tbl {
 	struct rcu_head rcu_head;
 	int len;
-- 
1.7.1


