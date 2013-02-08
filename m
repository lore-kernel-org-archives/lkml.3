Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946609Ab3BHPZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:25:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:58901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946070Ab3BHPZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:25:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,630,1355126400"; 
   d="scan'208";a="284536575"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Eric Miao <eric.miao@marvell.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] platform: fall-back to driver name check if there is no id found
Date: Fri,  8 Feb 2013 17:24:44 +0200
Message-Id: <1360337084-9901-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the platform devices rely on the name of their driver to match with. In
the current implementation, if platform id table is needed, they have to add
the name to the platform id table which sounds alogical. The patch adjustes the
logic of the id table matching to make sure we will fall-back to match by the
driver name. This will make it similar to the DT or ACPI cases.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c0b8df3..452ba4b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -732,8 +732,8 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 		return 1;
 
 	/* Then try to match against the id table */
-	if (pdrv->id_table)
-		return platform_match_id(pdrv->id_table, pdev) != NULL;
+	if (pdrv->id_table && platform_match_id(pdrv->id_table, pdev))
+		return 1;
 
 	/* fall-back to driver name match */
 	return (strcmp(pdev->name, drv->name) == 0);
-- 
1.7.10.4

