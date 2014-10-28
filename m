Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaJ1DuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:50:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaJ1DuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:50:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.14 057/100] spi: dw-mid: terminate ongoing transfers at exit
Date: Tue, 28 Oct 2014 11:35:42 +0800
Message-Id: <20141028033503.156578680@linuxfoundation.org>
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

commit 8e45ef682cb31fda62ed4eeede5d9745a0a1b1e2 upstream.

Do full clean up at exit, means terminate all ongoing DMA transfers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw-mid.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -91,7 +91,11 @@ static void mid_spi_dma_exit(struct dw_s
 {
 	if (!dws->dma_inited)
 		return;
+
+	dmaengine_terminate_all(dws->txchan);
 	dma_release_channel(dws->txchan);
+
+	dmaengine_terminate_all(dws->rxchan);
 	dma_release_channel(dws->rxchan);
 }
 


