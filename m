Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3HFFdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:33:49 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:47514 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3HFFds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:33:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 8/8] partitions/efi: some style cleanups
Date: Mon,  5 Aug 2013 22:21:16 -0700
Message-Id: <1375766476-4204-9-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial coding style cleanups - still plenty left.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 9a81c3b..8e6d77e 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -25,6 +25,9 @@
  * TODO:
  *
  * Changelog:
+ * Mon August 5th, 2013 Davidlohr Bueso <davidlohr@hp.com>
+ * - detect hybrid MBRs, tighter pMBR checking & cleanups.
+ *
  * Mon Nov 09 2004 Matt Domsch <Matt_Domsch@dell.com>
  * - test for valid PMBR and valid PGPT before ever reading
  *   AGPT, allow override with 'gpt' kernel command line option.
@@ -288,8 +291,7 @@ static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
 		return NULL;
 
 	if (read_lba(state, le64_to_cpu(gpt->partition_entry_lba),
-                     (u8 *) pte,
-		     count) < count) {
+                     (u8 *) pte, count) < count) {
 		kfree(pte);
                 pte=NULL;
 		return NULL;
@@ -613,8 +615,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
         if (good_pgpt)
-		good_agpt = is_gpt_valid(state,
-					 le64_to_cpu(pgpt->alternate_lba),
+		good_agpt = is_gpt_valid(state, le64_to_cpu(pgpt->alternate_lba),
 					 &agpt, &aptes);
         if (!good_agpt && force_gpt)
                 good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
@@ -632,9 +633,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
                 kfree(agpt);
                 kfree(aptes);
                 if (!good_agpt) {
-                        printk(KERN_WARNING 
-			       "Alternate GPT is invalid, "
-                               "using primary GPT.\n");
+                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");
                 }
                 return 1;
         }
@@ -643,8 +642,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
                 *ptes = aptes;
                 kfree(pgpt);
                 kfree(pptes);
-                printk(KERN_WARNING 
-                       "Primary GPT is invalid, using alternate GPT.\n");
+                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");
                 return 1;
         }
 
@@ -706,8 +704,7 @@ int efi_partition(struct parsed_partitions *state)
 		put_partition(state, i+1, start * ssz, size * ssz);
 
 		/* If this is a RAID volume, tell md */
-		if (!efi_guidcmp(ptes[i].partition_type_guid,
-				 PARTITION_LINUX_RAID_GUID))
+		if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
 
 		info = &state->parts[i + 1].info;
-- 
1.7.11.7

