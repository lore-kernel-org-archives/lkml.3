Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaHNSB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:01:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:47929 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaHNSBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:01:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,864,1400050800"; 
   d="scan'208";a="468806448"
From: Dave Jiang <dave.jiang@intel.com>
To: jdmason@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ntb: fix sysfs display of usd vs dsd
Date: Thu, 14 Aug 2014 11:01:33 -0700
Message-Id: <1408039293-163021-1-git-send-email-dave.jiang@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs display is opposite of the discovery printout and what the BIOS
has configured.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/ntb/ntb_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index db0fe8a..ce6680a 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1369,7 +1369,7 @@ static ssize_t ntb_debugfs_read(struct file *filp, char __user *ubuf,
 	offset += snprintf(buf + offset, out_count - offset,
 			   "Device Type - \t\t\t%s\n",
 			   ndev->dev_type == NTB_DEV_USD ?
-			   "DSD/USP" : "USD/DSP");
+			   "USD/DSP" : "DSD/USP");
 	offset += snprintf(buf + offset, out_count - offset,
 			   "Max Number of Callbacks - \t%u\n",
 			   ntb_max_cbs(ndev));
-- 
1.9.3

