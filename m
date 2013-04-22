Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3DVNBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:01:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:51984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3DVNBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,526,1363158000"; 
   d="scan'208";a="326184280"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] pnp: use %*phC to dump small buffers
Date: Mon, 22 Apr 2013 16:01:05 +0300
Message-Id: <1366635665-11365-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pnp/isapnp/core.c  | 5 +----
 drivers/pnp/pnpbios/proc.c | 5 ++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index 918d5f0..f380bcf 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -814,10 +814,7 @@ static int __init isapnp_build_device_list(void)
 			continue;
 
 #if 0
-		dev_info(&card->dev,
-		       "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-		       header[0], header[1], header[2], header[3], header[4],
-		       header[5], header[6], header[7], header[8]);
+		dev_info(&card->dev, "vendor: %9phC\n", header);
 		dev_info(&card->dev, "checksum = %#x\n", checksum);
 #endif
 		INIT_LIST_HEAD(&card->devices);
diff --git a/drivers/pnp/pnpbios/proc.c b/drivers/pnp/pnpbios/proc.c
index 8dafd65..c212db0 100644
--- a/drivers/pnp/pnpbios/proc.c
+++ b/drivers/pnp/pnpbios/proc.c
@@ -185,10 +185,9 @@ static int pnp_devices_proc_show(struct seq_file *m, void *v)
 
 		if (pnp_bios_get_dev_node(&nodenum, PNPMODE_DYNAMIC, node))
 			break;
-		seq_printf(m, "%02x\t%08x\t%02x:%02x:%02x\t%04x\n",
+		seq_printf(m, "%02x\t%08x\t%3phC\t%04x\n",
 			     node->handle, node->eisa_id,
-			     node->type_code[0], node->type_code[1],
-			     node->type_code[2], node->flags);
+			     node->type_code, node->flags);
 		if (nodenum <= thisnodenum) {
 			printk(KERN_ERR
 			       "%s Node number 0x%x is out of sequence following node 0x%x. Aborting.\n",
-- 
1.8.2.rc0.22.gb3600c3

