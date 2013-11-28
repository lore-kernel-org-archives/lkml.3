Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab3K1KMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:12:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:58427 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab3K1KMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:12:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,790,1378882800"; 
   d="scan'208";a="443615413"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] spi/pxa2xx: Restore private register bits.
Date: Fri, 29 Nov 2013 02:13:11 +0800
Message-Id: <1385662391-27573-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

The Intel LPSS SPI private register bits have to be restored
when system resume from S3 suspend.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 7028180..7765b19 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1293,6 +1293,9 @@ static int pxa2xx_spi_resume(struct device *dev)
 	/* Enable the SSP clock */
 	clk_prepare_enable(ssp->clk);
 
+	/* Restore LPSS private register bits */
+	lpss_ssp_setup(drv_data);
+
 	/* Start the queue running */
 	status = spi_master_resume(drv_data->master);
 	if (status != 0) {
-- 
1.7.4.4

