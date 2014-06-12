Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaFLSRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:17:07 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:26413 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbaFLSRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:17:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoIAG7tmVNbsHy//2dsb2JhbABagw2qdQUBAQEBAQEFAZkegQsXdYQxLyOBGjeIRgG4PpouhVyIKFcdhCsEj2iKSpNSgz47gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] block/partitions/msdos.c: code clean-up
Date: Thu, 12 Jun 2014 20:16:57 +0200
Message-Id: <1402597017-4586-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch fixing:
WARNING: Missing a blank line after declarations
WARNING: space prohibited between function name and open parenthesis '('
ERROR: spaces required around that '<' (ctx:VxV)

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/partitions/msdos.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
index 9123f25..93e7c1b 100644
--- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -159,8 +159,9 @@ static void parse_extended(struct parsed_partitions *state,
 		/*
 		 * First process the data partition(s)
 		 */
-		for (i=0; i<4; i++, p++) {
+		for (i = 0; i < 4; i++, p++) {
 			sector_t offs, size, next;
+
 			if (!nr_sects(p) || is_extended_partition(p))
 				continue;
 
@@ -194,7 +195,7 @@ static void parse_extended(struct parsed_partitions *state,
 		 * It should be a link to the next logical partition.
 		 */
 		p -= 4;
-		for (i=0; i<4; i++, p++)
+		for (i = 0; i < 4; i++, p++)
 			if (nr_sects(p) && is_extended_partition(p))
 				break;
 		if (i == 4)
@@ -243,8 +244,8 @@ static void parse_solaris_x86(struct parsed_partitions *state,
 		return;
 	}
 	/* Ensure we can handle previous case of VTOC with 8 entries gracefully */
-	max_nparts = le16_to_cpu (v->v_nparts) > 8 ? SOLARIS_X86_NUMSLICE : 8;
-	for (i=0; i<max_nparts && state->next<state->limit; i++) {
+	max_nparts = le16_to_cpu(v->v_nparts) > 8 ? SOLARIS_X86_NUMSLICE : 8;
+	for (i = 0; i < max_nparts && state->next < state->limit; i++) {
 		struct solaris_x86_slice *s = &v->v_slice[i];
 		char tmp[3 + 10 + 1 + 1];
 
@@ -409,7 +410,7 @@ static void parse_minix(struct parsed_partitions *state,
 	/* The first sector of a Minix partition can have either
 	 * a secondary MBR describing its subpartitions, or
 	 * the normal boot sector. */
-	if (msdos_magic_present (data + 510) &&
+	if (msdos_magic_present(data + 510) &&
 	    SYS_IND(p) == MINIX_PARTITION) { /* subpartition table present */
 		char tmp[1 + BDEVNAME_SIZE + 10 + 9 + 1];
 
@@ -527,6 +528,7 @@ int msdos_partition(struct parsed_partitions *state)
 	for (slot = 1 ; slot <= 4 ; slot++, p++) {
 		sector_t start = start_sect(p)*sector_size;
 		sector_t size = nr_sects(p)*sector_size;
+
 		if (!size)
 			continue;
 		if (is_extended_partition(p)) {
@@ -537,6 +539,7 @@ int msdos_partition(struct parsed_partitions *state)
 			 * sector, although it may not be enough/proper.
 			 */
 			sector_t n = 2;
+
 			n = min(size, max(sector_size, n));
 			put_partition(state, slot, start, n);
 
-- 
1.9.1

