Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaKKNXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:23:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:22822 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaKKNXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:23:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630128641"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Heiko Stuebner <heiko@sntech.de>, Mark Brown <broonie@kernel.org>
Cc: linux-rockchip@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: [PATCH] spi/rockchip: remove redundant call to spi_master_put()
Date: Tue, 11 Nov 2014 15:22:51 +0200
Message-Id: <1415712171-20951-1-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to spi_master_put() in rockchip_spi_remove() is redundant since
the master is registered using devm_. This patch removes it.

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---
 drivers/spi/spi-rockchip.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 3afc266..e8cfe6c 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -724,8 +724,6 @@ static int rockchip_spi_remove(struct platform_device *pdev)
 	if (rs->dma_rx.ch)
 		dma_release_channel(rs->dma_rx.ch);
 
-	spi_master_put(master);
-
 	return 0;
 }
 
-- 
1.9.1

