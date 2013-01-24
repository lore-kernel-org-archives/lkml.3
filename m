Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3AXPHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:07:31 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:37746 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3AXPH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:07:29 -0500
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2013 10:07:29 EST
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/13] sg_io: whitelist a few more commands for rare & obsolete device types
Date: Thu, 24 Jan 2013 16:00:41 +0100
Message-Id: <1359039649-17734-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start cleaning up the table, moving out of the way four
rare & obsolete device types: "processor devices", printers,
communication devices (network cards) and scanners.  Add
missing commands for these four device types.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |   49 ++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index c266546..084b943 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -141,7 +141,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x03, -1                             , read);  // REQUEST SENSE
 	sgio_bitmap_set(0x12, -1                             , read);  // INQUIRY
 	sgio_bitmap_set(0x1A, -1                             , read);  // MODE SENSE(6)
-	sgio_bitmap_set(0x1B, D|T|L|  W|R|O|M|A|  B|K|V|F|  S, read);  // START STOP UNIT
+	sgio_bitmap_set(0x1B, D|T|    W|R|O|M|A|  B|K|V|F    , read);  // START STOP UNIT
 	sgio_bitmap_set(0x1C,                    ~B          , read);  // RECEIVE DIAGNOSTIC RESULTS
 	sgio_bitmap_set(0x2B, D|T|    W|R|O|M|      K        , read);  // SEEK(10)
 	sgio_bitmap_set(0x3C,                    ~B          , read);  // READ BUFFER
@@ -163,21 +163,21 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	/* input */
 
-	sgio_bitmap_set(0x08, D|T|  P|W|  O|              C  , read);  // READ(6)
-	sgio_bitmap_set(0x25, D|      W|R|O|      B|K|      S, read);  // READ CAPACITY(10)
-	sgio_bitmap_set(0x28, D|      W|R|O|      B|K|    C  , read);  // READ(10)
+	sgio_bitmap_set(0x08, D|T|    W|  O                  , read);  // READ(6)
+	sgio_bitmap_set(0x25, D|      W|R|O|      B|K        , read);  // READ CAPACITY(10)
+	sgio_bitmap_set(0x28, D|      W|R|O|      B|K        , read);  // READ(10)
 	sgio_bitmap_set(0x2F, D|      W|R|O                  , read);  // VERIFY(10)
 	sgio_bitmap_set(0x37, D|          O|M                , read);  // READ DEFECT DATA(10)
 	sgio_bitmap_set(0x3E, D|      W|  O                  , read);  // READ LONG(10)
 	sgio_bitmap_set(0x88, D|T|    W|  O|      B          , read);  // READ(16)
 	sgio_bitmap_set(0x8F, D|T|    W|  O|      B          , read);  // VERIFY(16)
-	sgio_bitmap_set(0xA8, D|      W|R|O|              C  , read);  // READ(12)
+	sgio_bitmap_set(0xA8, D|      W|R|O                  , read);  // READ(12)
 
 	/* write */
 
-	sgio_bitmap_set(0x04, D|T|L|    R|O                  , write); // FORMAT UNIT
-	sgio_bitmap_set(0x0A, D|T|L|P|W|  O|              C  , write); // WRITE(6)
-	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K|    C|S, write); // WRITE(10)
+	sgio_bitmap_set(0x04, D|T|      R|O                  , write); // FORMAT UNIT
+	sgio_bitmap_set(0x0A, D|T|    W|  O                  , write); // WRITE(6)
+	sgio_bitmap_set(0x2A, D|      W|R|O|      B|K        , write); // WRITE(10)
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K        , write); // WRITE AND VERIFY(10)
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K        , write); // SYNCHRONIZE CACHE(10)
 	sgio_bitmap_set(0x3F, D|      W|  O                  , write); // WRITE LONG(10)
@@ -185,11 +185,24 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x48, D|                  B          , write); // SANITIZE
 	sgio_bitmap_set(0x51, D                              , write); // XPWRITE(10)
 	sgio_bitmap_set(0x8A, D|T|    W|  O|      B          , write); // WRITE(16)
-	sgio_bitmap_set(0xAA, D|      W|R|O|              C  , write); // WRITE(12)
+	sgio_bitmap_set(0xAA, D|      W|R|O                  , write); // WRITE(12)
 	sgio_bitmap_set(0xAC,             O                  , write); // ERASE(12)
 	sgio_bitmap_set(0xAE, D|      W|  O                  , write); // WRITE AND VERIFY(12)
 	sgio_bitmap_set(0xEA, D|      W|  O                  , write); // WRITE_LONG_2 ??
 
+	/* processor device */
+
+	sgio_bitmap_set(0x08,       P                        , read);  // RECEIVE
+	sgio_bitmap_set(0x0A,       P                        , write); // SEND(6)
+
+	/* printer */
+
+	sgio_bitmap_set(0x04,     L                          , write); // FORMAT
+	sgio_bitmap_set(0x0A,     L                          , write); // PRINT
+	sgio_bitmap_set(0x0B,     L                          , write); // SLEW AND PRINT
+	sgio_bitmap_set(0x10,     L                          , write); // SYNCHRONIZE BUFFER
+	sgio_bitmap_set(0x1B,     L                          , write); // STOP PRINT
+
 	/* (mostly) MMC */
 
 	sgio_bitmap_set(0x23,           R                    , read);  // READ FORMAT CAPACITIES
@@ -232,6 +245,24 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 
 	sgio_bitmap_set(0x19,   T                            , write); // ERASE(6)
 
+	/* communication devices (obsolete) */
+
+	sgio_bitmap_set(0x08,                             C  , write); // GET MESSAGE(6)
+	sgio_bitmap_set(0x0A,                             C  , write); // SEND MESSAGE(6)
+	sgio_bitmap_set(0x28,                             C  , write); // GET MESSAGE(10)
+	sgio_bitmap_set(0x2A,                             C  , write); // SEND MESSAGE(10)
+	sgio_bitmap_set(0xA8,                             C  , write); // GET MESSAGE(12)
+	sgio_bitmap_set(0xAA,                             C  , write); // SEND MESSAGE(12)
+
+	/* scanners (obsolete) */
+
+	sgio_bitmap_set(0x1B,                               S, write); // SCAN
+	sgio_bitmap_set(0x24,                               S, write); // SET WINDOW
+	sgio_bitmap_set(0x25,                               S, write); // GET WINDOW
+	sgio_bitmap_set(0x2A,                               S, write); // SEND(10)
+	sgio_bitmap_set(0x31,                               S, write); // OBJECT POSITION
+	sgio_bitmap_set(0x34,                               S, write); // GET DATA BUFFER STATUS
+
 #undef D
 #undef T
 #undef L
-- 
1.7.1


