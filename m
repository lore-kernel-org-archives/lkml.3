Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3BGPhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:37:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:45078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3BGPhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:37:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,622,1355126400"; 
   d="scan'208";a="259128286"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: add support for Lynxpoint DMA controllers
Date: Thu,  7 Feb 2013 17:36:28 +0200
Message-Id: <1360251388-16075-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Intel Lynxpoint PCH Low Power Subsystem has DMA controller to support general
purpose serial buses like SPI, I2C, and HSUART. This controller is enumerated
from ACPI namespace with ACPI ID INTL9C60.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d6abea8..5feee76 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1977,6 +1977,11 @@ static const struct of_device_id dw_dma_id_table[] = {
 MODULE_DEVICE_TABLE(of, dw_dma_id_table);
 #endif
 
+static const struct platform_device_id dw_dma_ids[] = {
+	{ "INTL9C60", 0 },
+	{ }
+};
+
 static struct platform_driver dw_driver = {
 	.probe		= dw_probe,
 	.remove		= dw_remove,
@@ -1986,6 +1991,7 @@ static struct platform_driver dw_driver = {
 		.pm	= &dw_dev_pm_ops,
 		.of_match_table = of_match_ptr(dw_dma_id_table),
 	},
+	.id_table	= dw_dma_ids,
 };
 
 static int __init dw_init(void)
-- 
1.7.10.4

