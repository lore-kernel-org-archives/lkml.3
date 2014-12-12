Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934953AbaLLPRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:17:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:2896 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933263AbaLLPRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:17:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622804200"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] libata: export ata_get_cmd_descript()
Date: Fri, 12 Dec 2014 17:16:31 +0200
Message-Id: <1418397391-13668-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver sata_dwc_460ex is using this symbol. To build it as a module we have
to have the symbol exported. This patch adds EXPORT_SYMBOL() macro for that.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ata/libata-eh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 3dbec89..74fef87 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2389,6 +2389,7 @@ const char *ata_get_cmd_descript(u8 command)
 
 	return NULL;
 }
+EXPORT_SYMBOL(ata_get_cmd_descript);
 
 /**
  *	ata_eh_link_report - report error handling to user
-- 
2.1.3

