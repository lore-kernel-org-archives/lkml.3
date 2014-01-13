Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaAMJRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:17:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:36799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaAMJRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:17:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,651,1384329600"; 
   d="scan'208";a="465729358"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-spi@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] spi/pxa2xx: initialize DMA channels to -1 to prevent inadvertent match
Date: Mon, 13 Jan 2014 11:17:04 +0200
Message-Id: <1389604624-8412-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cddb339badb0 (spi/pxa2xx: convert to dma_request_slave_channel_compat())
converted the driver to use ACPI provided DMA helpers but it forgot to
initialize the platform data for the channels to -1. Failing to do so will
result inadvertent match in the filter function because 0 is a valid
channel number.

Prevent this from happening by initializing both platform data channels
correctly to -1.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 7765b1999537..cbc68848789d 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1066,6 +1066,8 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 
 	pdata->num_chipselect = 1;
 	pdata->enable_dma = true;
+	pdata->tx_chan_id = -1;
+	pdata->rx_chan_id = -1;
 
 	return pdata;
 }
-- 
1.8.5.2

