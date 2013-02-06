Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab3BFPQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:16:51 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:48440 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab3BFPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:16:40 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 11/14] sg_io: mark blk_set_cmd_filter_defaults as __init
Date: Wed,  6 Feb 2013 16:15:58 +0100
Message-Id: <1360163761-8541-12-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 4942314..3830faf 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -113,7 +113,7 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 	return put_user(1, p);
 }
 
-static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
+static void __init blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
 #define sgio_bitmap_set(cmd, mask, rw) \
 	filter->rw##_ok[(cmd)] |= (mask);
-- 
1.7.1


