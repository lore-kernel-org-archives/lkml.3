Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3AVHvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:51:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:48084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab3AVHvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:51:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,513,1355126400"; 
   d="scan'208";a="250582552"
Subject: [PATCH] serial:ifx6x60: Remove memset for SPI frame
From: channing <chao.bi@intel.com>
To: alan@linux.intel.com, gregkh@linuxfoundation.org
Cc: jun.d.chen@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jan 2013 16:08:46 +0800
Message-ID: <1358842126.31133.7.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is no need to memset 0 to SPI frame memory before preparing
transfer frame bits, because SPI frame header are encoded with valid
data size, so don't need to worry about adopting dirty bits, more,
memset zero for each SPI frame may impact the spi throughput efficiency.

Signed-off-by: Chen Jun <jun.d.chen@intel.com>
Signed-off-by: channing <chao.bi@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 8cb6d8d..fa4ec7e 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -481,7 +481,6 @@ static int ifx_spi_prepare_tx_buffer(struct ifx_spi_device *ifx_dev)
 	unsigned char *tx_buffer;
 
 	tx_buffer = ifx_dev->tx_buffer;
-	memset(tx_buffer, 0, IFX_SPI_TRANSFER_SIZE);
 
 	/* make room for required SPI header */
 	tx_buffer += IFX_SPI_HEADER_OVERHEAD;
-- 
1.7.1



