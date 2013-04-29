Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab3D2VBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:01:07 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:15991 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab3D2VBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:01:05 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>, Matt Domsch <Matt_Domsch@dell.com>,
        Panagiotis Issaris <takis@issaris.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] partitions/efi.c: replace useless kzalloc's by kmalloc's
Date: Mon, 29 Apr 2013 23:00:18 +0200
Message-Id: <1367269218-17056-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In alloc_read_gpt_entries and alloc_read_gpt_header, the kzalloc'ated
zones are either totally overwritten by the following read_lba call,
or freed.  As kmalloc is cheaper than kzalloc, use kmalloc.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Panagiotis Issaris <takis@issaris.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 block/partitions/efi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index ff5804e..c85fc89 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -238,7 +238,7 @@ static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
                 le32_to_cpu(gpt->sizeof_partition_entry);
 	if (!count)
 		return NULL;
-	pte = kzalloc(count, GFP_KERNEL);
+	pte = kmalloc(count, GFP_KERNEL);
 	if (!pte)
 		return NULL;
 
@@ -267,7 +267,7 @@ static gpt_header *alloc_read_gpt_header(struct parsed_partitions *state,
 	gpt_header *gpt;
 	unsigned ssz = bdev_logical_block_size(state->bdev);
 
-	gpt = kzalloc(ssz, GFP_KERNEL);
+	gpt = kmalloc(ssz, GFP_KERNEL);
 	if (!gpt)
 		return NULL;
 
-- 
1.7.1

