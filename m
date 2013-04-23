Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab3DWNhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:37:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:53232 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab3DWNhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,533,1363158000"; 
   d="scan'208";a="290355435"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/2] pnp: use %*phC to dump small buffers
Date: Tue, 23 Apr 2013 16:37:19 +0300
Message-Id: <1366724239-24734-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1366724239-24734-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1366724239-24734-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of pronting buffer byte-by-byte let's use native specificator to do the
job.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pnp/pnpbios/proc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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

