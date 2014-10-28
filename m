Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbaJ1Dsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:48:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaJ1Dsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:48:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.14 018/100] spi: dw-mid: check that DMA was inited before exit
Date: Tue, 28 Oct 2014 11:35:03 +0800
Message-Id: <20141028033501.453685233@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit fb57862ead652454ceeb659617404c5f13bc34b5 upstream.

If the driver was compiled with DMA support, but DMA channels weren't acquired
by some reason, mid_spi_dma_exit() will crash the kernel.

Fixes: 7063c0d942a1 (spi/dw_spi: add DMA support)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw-mid.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -89,6 +89,8 @@ err_exit:
 
 static void mid_spi_dma_exit(struct dw_spi *dws)
 {
+	if (!dws->dma_inited)
+		return;
 	dma_release_channel(dws->txchan);
 	dma_release_channel(dws->rxchan);
 }


