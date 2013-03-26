Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3CZR3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:29:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:62611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab3CZR3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:29:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="219093994"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2.2] dw_dmac: remove unnecessary ENODEV check
Date: Tue, 26 Mar 2013 19:29:13 +0200
Message-Id: <1364318953-5219-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <CAKohponTj8iHTZqs2pS9m1mOqgbGX5WUDa7B2-xcDP_0sN7ZsQ@mail.gmail.com>
References: <CAKohponTj8iHTZqs2pS9m1mOqgbGX5WUDa7B2-xcDP_0sN7ZsQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_OF is not set the of_node of the device will always be NULL.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 274fd7d..736cffa 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1846,7 +1846,7 @@ static int dw_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node) {
 		err = of_dma_controller_register(pdev->dev.of_node,
 						 dw_dma_of_xlate, dw);
-		if (err && err != -ENODEV)
+		if (err)
 			dev_err(&pdev->dev,
 				"could not register of_dma_controller\n");
 	}
-- 
1.8.2.rc0.22.gb3600c3

