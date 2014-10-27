Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaJ0TDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaJ0TDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 040/105] spi: dw-mid: terminate ongoing transfers at exit
Date: Mon, 27 Oct 2014 11:56:15 -0700
Message-Id: <1414436240-13879-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 8e45ef682cb31fda62ed4eeede5d9745a0a1b1e2 upstream.

Do full clean up at exit, means terminate all ongoing DMA transfers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-dw-mid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 48c170c..c8b5bbe 100644
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

