Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaBKVCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:02:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaBKTFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 040/120] spi/pxa2xx: initialize DMA channels to -1 to prevent inadvertent match
Date: Tue, 11 Feb 2014 11:04:41 -0800
Message-Id: <20140211184824.742549898@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pxa2xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1066,6 +1066,8 @@ pxa2xx_spi_acpi_get_pdata(struct platfor
 
 	pdata->num_chipselect = 1;
 	pdata->enable_dma = true;
+	pdata->tx_chan_id = -1;
+	pdata->rx_chan_id = -1;
 
 	return pdata;
 }


