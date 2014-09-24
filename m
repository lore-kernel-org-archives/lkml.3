Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaIXQu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:50:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:49692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbaIXQr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749722"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH 21/27] spi: omap2-mcspi: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:11 +0530
Message-Id: <1411575342-31048-22-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/spi/spi-omap2-mcspi.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 68441fa..fa2aae8 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1020,8 +1020,7 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 		return ret;
 
 	ret = omap2_mcspi_setup_transfer(spi, NULL);
-	pm_runtime_mark_last_busy(mcspi->dev);
-	pm_runtime_put_autosuspend(mcspi->dev);
+	pm_runtime_last_busy_and_autosuspend(mcspi->dev);
 
 	return ret;
 }
@@ -1282,8 +1281,7 @@ static int omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
 	ctx->wakeupenable = OMAP2_MCSPI_WAKEUPENABLE_WKEN;
 
 	omap2_mcspi_set_master_mode(master);
-	pm_runtime_mark_last_busy(mcspi->dev);
-	pm_runtime_put_autosuspend(mcspi->dev);
+	pm_runtime_last_busy_and_autosuspend(mcspi->dev);
 	return 0;
 }
 
@@ -1504,8 +1502,7 @@ static int omap2_mcspi_resume(struct device *dev)
 			writel_relaxed(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
 		}
 	}
-	pm_runtime_mark_last_busy(mcspi->dev);
-	pm_runtime_put_autosuspend(mcspi->dev);
+	pm_runtime_last_busy_and_autosuspend(mcspi->dev);
 	return 0;
 }
 #else
-- 
1.7.0.4

