Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbaBGLuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:50:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41903 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaBGLuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 108/233] spi/pxa2xx: initialize DMA channels to -1 to prevent inadvertent match
Date: Fri,  7 Feb 2014 11:45:27 +0000
Message-Id: <1391773652-25214-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 483c319188c74e82b29a0ed7a7fa7065570f2193 upstream.

Commit cddb339badb0 (spi/pxa2xx: convert to dma_request_slave_channel_compat())
converted the driver to use ACPI provided DMA helpers but it forgot to
initialize the platform data for the channels to -1. Failing to do so will
result inadvertent match in the filter function because 0 is a valid
channel number.

Prevent this from happening by initializing both platform data channels
correctly to -1.

Fixes: cddb339badb0 (spi/pxa2xx: convert to dma_request_slave_channel_compat())
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-pxa2xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 46e481f..b0e1331 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1064,6 +1064,8 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 
 	pdata->num_chipselect = 1;
 	pdata->enable_dma = true;
+	pdata->tx_chan_id = -1;
+	pdata->rx_chan_id = -1;
 
 	return pdata;
 }
-- 
1.8.3.2

