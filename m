Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaJQAri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 20:47:38 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:3441 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaJQArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 20:47:36 -0400
X-IronPort-AV: E=Sophos;i="5.04,735,1406617200"; 
   d="scan'208";a="48414406"
From: Ray Jui <rjui@broadcom.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
CC: Scott Branden <sbranden@broadcom.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ray Jui <rjui@broadcom.com>
Subject: [PATCH] dmaengine: pl330: use subsys_initcall
Date: Thu, 16 Oct 2014 17:48:16 -0700
Message-ID: <1413506896-4536-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of subsystem that many slave drivers depend on, it's more
appropriate for the pl330 DMA driver to be initialized at
subsys_initcall than device_initcall

Signed-off-by: Ray Jui <rjui@broadcom.com>
---
 drivers/dma/pl330.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index d5149aa..abb4cae 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2811,7 +2811,17 @@ static struct amba_driver pl330_driver = {
 	.remove = pl330_remove,
 };
 
-module_amba_driver(pl330_driver);
+static int __init pl330_init(void)
+{
+	return amba_driver_register(&pl330_driver);
+}
+subsys_initcall(pl330_init);
+
+static void __exit pl330_exit(void)
+{
+	amba_driver_unregister(&pl330_driver);
+}
+module_exit(pl330_exit);
 
 MODULE_AUTHOR("Jaswinder Singh <jassi.brar@samsung.com>");
 MODULE_DESCRIPTION("API Driver for PL330 DMAC");
-- 
1.7.9.5

