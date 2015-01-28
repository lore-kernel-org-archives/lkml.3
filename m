Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbbA1EPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:15:19 -0500
Received: from mail.kernel.org ([198.145.29.136]:37324 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933456AbbA1EPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:15:16 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 022/177] spi: dw-mid: terminate ongoing transfers at exit
Date: Wed, 28 Jan 2015 12:06:51 +0800
Message-Id: <1422418236-12852-44-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 8e45ef682cb31fda62ed4eeede5d9745a0a1b1e2 upstream.

Do full clean up at exit, means terminate all ongoing DMA transfers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/spi/spi-dw-mid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 58fa14d..efc494a 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -89,7 +89,10 @@ err_exit:
 
 static void mid_spi_dma_exit(struct dw_spi *dws)
 {
+	dmaengine_terminate_all(dws->txchan);
 	dma_release_channel(dws->txchan);
+
+	dmaengine_terminate_all(dws->rxchan);
 	dma_release_channel(dws->rxchan);
 }
 
-- 
1.9.1

