Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbbAAPdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:33:19 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:49443 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbAAPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:33:16 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mn10300: boot: compressed: misc.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 16:36:16 +0100
Message-Id: <1420126576-27792-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
close_output_buffer_if_we_run_high() setup_output_buffer_if_we_run_high()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mn10300/boot/compressed/misc.c |   34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/arch/mn10300/boot/compressed/misc.c b/arch/mn10300/boot/compressed/misc.c
index 42cbd77..6e4a519 100644
--- a/arch/mn10300/boot/compressed/misc.c
+++ b/arch/mn10300/boot/compressed/misc.c
@@ -337,40 +337,6 @@ struct moveparams {
 	int hcount;
 };
 
-void setup_output_buffer_if_we_run_high(struct moveparams *mv)
-{
-	high_buffer_start = (uch *)(((ulg) &end) + HEAP_SIZE);
-#ifdef STANDARD_MEMORY_BIOS_CALL
-	if (EXT_MEM_K < (3 * 1024))
-		error("Less than 4MB of memory.\n");
-#else
-	if ((ALT_MEM_K > EXT_MEM_K ? ALT_MEM_K : EXT_MEM_K) < (3 * 1024))
-		error("Less than 4MB of memory.\n");
-#endif
-	mv->low_buffer_start = output_data = (char *) LOW_BUFFER_START;
-	high_loaded = 1;
-	free_mem_end_ptr = (long) high_buffer_start;
-	if (0x100000 + LOW_BUFFER_SIZE > (ulg) high_buffer_start) {
-		high_buffer_start = (uch *)(0x100000 + LOW_BUFFER_SIZE);
-		mv->hcount = 0; /* say: we need not to move high_buffer */
-	} else {
-		mv->hcount = -1;
-	}
-	mv->high_buffer_start = high_buffer_start;
-}
-
-void close_output_buffer_if_we_run_high(struct moveparams *mv)
-{
-	mv->lcount = bytes_out;
-	if (bytes_out > LOW_BUFFER_SIZE) {
-		mv->lcount = LOW_BUFFER_SIZE;
-		if (mv->hcount)
-			mv->hcount = bytes_out - LOW_BUFFER_SIZE;
-	} else {
-		mv->hcount = 0;
-	}
-}
-
 #undef DEBUGFLAG
 #ifdef DEBUGFLAG
 int debugflag;
-- 
1.7.10.4

