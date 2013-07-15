Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3GOME6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:04:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:36816 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab3GOMEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:04:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="345768943"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/6] dma: dw: append MODULE_DEVICE_TABLE for ACPI case
Date: Mon, 15 Jul 2013 15:04:37 +0300
Message-Id: <1373889881-21075-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rare cases (mostly for the testing purposes) the dw_dmac driver might be
compiled as a module as well as the other LPSS device drivers (I2C, SPI,
HSUART). When udev handles the event of the devices appearing the dw_dmac
module is missing. This patch will fix that.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
index 6c9449c..e35d975 100644
--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -253,6 +253,7 @@ static const struct acpi_device_id dw_dma_acpi_id_table[] = {
 	{ "INTL9C60", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, dw_dma_acpi_id_table);
 #endif
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.8.3.2

