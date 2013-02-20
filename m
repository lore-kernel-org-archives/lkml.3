Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935581Ab3BTO7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:59:12 -0500
Received: from mail-ye0-f182.google.com ([209.85.213.182]:54591 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935211Ab3BTO7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:59:11 -0500
From: Fabio Estevam <festevam@gmail.com>
To: akpm@linux-foundation.org
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Peter Jones <pjones@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: partitions: efi: Typecast sizeof(gpt_header)
Date: Wed, 20 Feb 2013 11:52:10 -0300
Message-Id: <1361371930-1520-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Since commit ef25bb0fa6e2 (block/partitions/efi.c: ensure that the GPT header is
at least the size of the structure.) , when building for a 32-bit architecture, 
such as ARM, the following build warning is seen:

block/partitions/efi.c:324:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]

Typecast sizeof(gpt_header) to (unsigned long) to avoid such warning on 32-bit 
systems.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 block/partitions/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index a7475e7..62e05cf 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -323,7 +323,7 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 	if (le32_to_cpu((*gpt)->header_size) < sizeof(gpt_header)) {
 		pr_debug("GUID Partition Table Header size is too small: %u < %lu\n",
 			le32_to_cpu((*gpt)->header_size),
-			sizeof(gpt_header));
+			(unsigned long)sizeof(gpt_header));
 		goto fail;
 	}
 
-- 
1.7.9.5

