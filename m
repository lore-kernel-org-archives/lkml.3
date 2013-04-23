Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab3DWNhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:37:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:42962 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab3DWNht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:37:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,533,1363158000"; 
   d="scan'208";a="299696397"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/2] isapnp: remove debug leftovers
Date: Tue, 23 Apr 2013 16:37:18 +0300
Message-Id: <1366724239-24734-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are couple of #if 0's to avoid debug printing. Let's remove them as
Rafael suggested.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pnp/isapnp/core.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index 918d5f0..cf88f9b6 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -379,10 +379,6 @@ static int __init isapnp_read_tag(unsigned char *type, unsigned short *size)
 		*type = (tag >> 3) & 0x0f;
 		*size = tag & 0x07;
 	}
-#if 0
-	printk(KERN_DEBUG "tag = 0x%x, type = 0x%x, size = %i\n", tag, *type,
-	       *size);
-#endif
 	if (*type == 0xff && *size == 0xffff)	/* probably invalid data */
 		return -1;
 	return 0;
@@ -813,13 +809,6 @@ static int __init isapnp_build_device_list(void)
 		if (!card)
 			continue;
 
-#if 0
-		dev_info(&card->dev,
-		       "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-		       header[0], header[1], header[2], header[3], header[4],
-		       header[5], header[6], header[7], header[8]);
-		dev_info(&card->dev, "checksum = %#x\n", checksum);
-#endif
 		INIT_LIST_HEAD(&card->devices);
 		card->serial =
 		    (header[7] << 24) | (header[6] << 16) | (header[5] << 8) |
-- 
1.8.2.rc0.22.gb3600c3

