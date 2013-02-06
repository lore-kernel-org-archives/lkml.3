Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3BFPTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:19:07 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55365 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab3BFPQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:16:28 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 06/14] sg_io: whitelist another command for multimedia devices
Date: Wed,  6 Feb 2013 16:15:53 +0100
Message-Id: <1360163761-8541-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three MMC commands were never included: PLAY AUDIO(12), SERVICE ACTION
IN(12), MECHANISM STATUS.  Add MECHANISM STATUS, the only one that has
not been obsoleted in recent versions of the standard.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: leave out PLAY AUDIO(12), SERVICE ACTION IN(12)

 block/scsi_ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e71cd42..fa2a1fc 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -221,6 +221,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0xB9,           R                    , read);  /* READ CD MSF */
 	sgio_bitmap_set(0xBA,           R                    , read);  /* SCAN */
 	sgio_bitmap_set(0xBC,           R                    , read);  /* PLAY CD */
+	sgio_bitmap_set(0xBD,           R                    , read);  /* MECHANISM STATUS */
 	sgio_bitmap_set(0xBE,           R                    , read);  /* READ CD */
 
 	sgio_bitmap_set(0x53, D|        R                    , write); /* RESERVE TRACK / XDWRITEREAD(10) */
-- 
1.7.1


