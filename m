Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaIXIAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:00:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:15425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbaIXIAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:00:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="604520629"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-usb@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [resend PATCH 1/3] ACPI / platform: provide default DMA mask
Date: Wed, 24 Sep 2014 11:00:37 +0300
Message-Id: <1411545639-18741-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most devices are configured for 32-bit DMA addresses.
Setting the mask to 32-bit here removes the need for the
drivers to do it separately.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
---
 drivers/acpi/acpi_platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index 2bf9082..8d099e6 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 
 #include "internal.h"
@@ -102,6 +103,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
 	pdevinfo.res = resources;
 	pdevinfo.num_res = count;
 	pdevinfo.acpi_node.companion = adev;
+	pdevinfo.dma_mask = DMA_BIT_MASK(32);
 	pdev = platform_device_register_full(&pdevinfo);
 	if (IS_ERR(pdev))
 		dev_err(&adev->dev, "platform device creation failed: %ld\n",
-- 
2.1.0

