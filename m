Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3AXPBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:01:15 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:35295 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab3AXPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:01:12 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia devices
Date: Thu, 24 Jan 2013 16:00:42 +0100
Message-Id: <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strangely, a couple of MMC commands were never included.  Add them too.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 084b943..ec930f0 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -220,11 +220,14 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x52,           R                    , read);  // READ TRACK INFORMATION
 	sgio_bitmap_set(0x5C,           R                    , read);  // READ BUFFER CAPACITY
 	sgio_bitmap_set(0xA4,           R                    , read);  // REPORT KEY
+	sgio_bitmap_set(0xA5,           R                    , read);  // PLAY AUDIO(12)
+	sgio_bitmap_set(0xAB,           R|            V      , read);  // SERVICE ACTION IN(12)
 	sgio_bitmap_set(0xAC,           R                    , read);  // GET PERFORMANCE
 	sgio_bitmap_set(0xAD,           R                    , read);  // READ DVD STRUCTURE
 	sgio_bitmap_set(0xB9,           R                    , read);  // READ CD MSF
 	sgio_bitmap_set(0xBA,           R                    , read);  // SCAN
 	sgio_bitmap_set(0xBC,           R                    , read);  // PLAY CD
+	sgio_bitmap_set(0xBD,           R                    , read);  // MECHANISM STATUS
 	sgio_bitmap_set(0xBE,           R                    , read);  // READ CD
 
 	sgio_bitmap_set(0x53, D|        R                    , write); // RESERVE TRACK / XDWRITEREAD(10)
-- 
1.7.1


