Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3KORYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:24:38 -0500
Received: from mx.kvy.fi ([83.143.60.202]:33207 "EHLO mx.kvy.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3KORYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:24:33 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Nov 2013 12:24:33 EST
X-IronPort-AV: E=Sophos;i="4.93,709,1378846800"; 
   d="scan'208";a="29664"
Date: Fri, 15 Nov 2013 19:14:22 +0200 (EET)
Message-Id: <20131115.191422.1787913255098350249.apm@brigitte.kvy.fi>
To: axboe@kernel.dk, akpm@linux-foundation.org, davidlohr@hp.com,
        matt.fleming@intel.com, kzak@redhat.com
Cc: linux-kernel@vger.kernel.org
From: Antti P Miettinen <amiettinen@nvidia.com>
Reply-To: amiettinen@nvidia.com
X-Mailer: Mew version 6.5 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 83.143.58.51
X-SA-Exim-Mail-From: amiettinen@nvidia.com
Subject: [PATCH] fs: partitions: efi: Fix bound check
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 02:25:50 +0000)
X-SA-Exim-Scanned: Yes (on brigitte.kvy.fi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ARRAY_SIZE instead of sizeof to get proper max for label
length.

Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
Reviewed-by: Hiroshi Doyu <hdoyu@nvidia.com>
Tested-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 block/partitions/efi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index a8287b4..dc51f46 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -96,6 +96,7 @@
  * - Code works, detects all the partitions.
  *
  ************************************************************/
+#include <linux/kernel.h>
 #include <linux/crc32.h>
 #include <linux/ctype.h>
 #include <linux/math64.h>
@@ -715,8 +716,8 @@ int efi_partition(struct parsed_partitions *state)
 		efi_guid_unparse(&ptes[i].unique_partition_guid, info->uuid);
 
 		/* Naively convert UTF16-LE to 7 bits. */
-		label_max = min(sizeof(info->volname) - 1,
-				sizeof(ptes[i].partition_name));
+		label_max = min(ARRAY_SIZE(info->volname) - 1,
+				ARRAY_SIZE(ptes[i].partition_name));
 		info->volname[label_max] = 0;
 		while (label_count < label_max) {
 			u8 c = ptes[i].partition_name[label_count] & 0xff;
-- 
1.8.3.2
