Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaFLS0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:26:09 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:52378 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbaFLS0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:26:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoIAErwmVNbsHy//2dsb2JhbABagw2qdQUBAQEBAQEFAZkegQsXdYQxLyOBGjeIRgG4NJoVF4VciH+ESASaMpNSgz47
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Davidlohr Bueso <davidlohr@hp.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] block/partitions/efi.c: kerneldoc fixing
Date: Thu, 12 Jun 2014 20:26:01 +0200
Message-Id: <1402597561-5010-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding function documentation and fixing kerneldoc warnings
('field: description' uniformization).

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/partitions/efi.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index dc51f46..56d08fd 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -121,7 +121,7 @@ __setup("gpt", force_gpt_fn);
 /**
  * efi_crc32() - EFI version of crc32 function
  * @buf: buffer to calculate crc32 of
- * @len - length of buf
+ * @len: length of buf
  *
  * Description: Returns EFI-style CRC32 value for @buf
  * 
@@ -240,10 +240,10 @@ done:
 
 /**
  * read_lba(): Read bytes from disk, starting at given LBA
- * @state
- * @lba
- * @buffer
- * @size_t
+ * @state: disk parsed partitions
+ * @lba: the Logical Block Address of the partition table
+ * @buffer: destination buffer
+ * @count: bytes to read
  *
  * Description: Reads @count bytes from @state->bdev into @buffer.
  * Returns number of bytes read on success, 0 on error.
@@ -277,8 +277,8 @@ static size_t read_lba(struct parsed_partitions *state,
 
 /**
  * alloc_read_gpt_entries(): reads partition entries from disk
- * @state
- * @gpt - GPT header
+ * @state: disk parsed partitions
+ * @gpt: GPT header
  * 
  * Description: Returns ptes on success,  NULL on error.
  * Allocates space for PTEs based on information found in @gpt.
@@ -312,8 +312,8 @@ static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
 
 /**
  * alloc_read_gpt_header(): Allocates GPT header, reads into it from disk
- * @state
- * @lba is the Logical Block Address of the partition table
+ * @state: disk parsed partitions
+ * @lba: the Logical Block Address of the partition table
  * 
  * Description: returns GPT header on success, NULL on error.   Allocates
  * and fills a GPT header starting at @ from @state->bdev.
@@ -340,10 +340,10 @@ static gpt_header *alloc_read_gpt_header(struct parsed_partitions *state,
 
 /**
  * is_gpt_valid() - tests one GPT header and PTEs for validity
- * @state
- * @lba is the logical block address of the GPT header to test
- * @gpt is a GPT header ptr, filled on return.
- * @ptes is a PTEs ptr, filled on return.
+ * @state: disk parsed partitions
+ * @lba: logical block address of the GPT header to test
+ * @gpt: GPT header ptr, filled on return.
+ * @ptes: PTEs ptr, filled on return.
  *
  * Description: returns 1 if valid,  0 on error.
  * If valid, returns pointers to newly allocated GPT header and PTEs.
@@ -461,8 +461,8 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 
 /**
  * is_pte_valid() - tests one PTE for validity
- * @pte is the pte to check
- * @lastlba is last lba of the disk
+ * @pte:pte to check
+ * @lastlba: last lba of the disk
  *
  * Description: returns 1 if valid,  0 on error.
  */
@@ -478,9 +478,10 @@ is_pte_valid(const gpt_entry *pte, const u64 lastlba)
 
 /**
  * compare_gpts() - Search disk for valid GPT headers and PTEs
- * @pgpt is the primary GPT header
- * @agpt is the alternate GPT header
- * @lastlba is the last LBA number
+ * @pgpt: primary GPT header
+ * @agpt: alternate GPT header
+ * @lastlba: last LBA number
+ *
  * Description: Returns nothing.  Sanity checks pgpt and agpt fields
  * and prints warnings on discrepancies.
  * 
@@ -572,9 +573,10 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
 
 /**
  * find_valid_gpt() - Search disk for valid GPT headers and PTEs
- * @state
- * @gpt is a GPT header ptr, filled on return.
- * @ptes is a PTEs ptr, filled on return.
+ * @state: disk parsed partitions
+ * @gpt: GPT header ptr, filled on return.
+ * @ptes: PTEs ptr, filled on return.
+ *
  * Description: Returns 1 if valid, 0 on error.
  * If valid, returns pointers to newly allocated GPT header and PTEs.
  * Validity depends on PMBR being valid (or being overridden by the
@@ -663,7 +665,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 
 /**
  * efi_partition(struct parsed_partitions *state)
- * @state
+ * @state: disk parsed partitions
  *
  * Description: called from check.c, if the disk contains GPT
  * partitions, sets up partition entries in the kernel.
-- 
1.9.1

