Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaEHPCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:02:16 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49214 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaEHO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:56:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, dmaengine@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/2] dmaengine: sa11x0: remove broken #ifdef
Date: Thu,  8 May 2014 16:56:13 +0200
Message-Id: <1399560990-1402858-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:U6CjbzaXs6rkqeJos9rhbdwMPJuW+ZfsMujI4AzwgP8
 enoRCKdbcFLrwGboc7y3lE24npzUBstGu7sur8f4YLVhSXRUZl
 DeYXJ/Fffb8hpasbT+5ajwkjdU0EOV2YSrz+oTUrFKKnuG9fxd
 DrY3QtDo5bXRuP0k2M7qCg/ELIKv3sM24ilNGZ+BJlTh4HjAQ+
 slrE5NqgRfhLBq/t3CbLeXrABc1VVDVD6lhfe7J8rSUIJhpg7f
 GfjyWKxJql4UOSzxRmYeUzXn9gq4QE0PIxi7X1RsI9mszjJG2u
 axHAyV5b5+dHP9IrbQIbm2ok5GfOHw0PPuQaopvhQinlSmHnLu
 smxAGaoYg7rDjYTEOMOeYmDUbhKol038jHzLhMOY7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sa11x0_dma_pm_ops unconditionally reference sa11x0_dma_resume
and sa11x0_dma_suspend, which currently breaks if CONFIG_PM_SLEEP
is disabled.

There is probably a better way to remove the reference in this
case, but the safe choice is to have the suspend/resume code always
built in the driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/sa11x0-dma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/sa11x0-dma.c b/drivers/dma/sa11x0-dma.c
index ab26d46..5ebdfbc 100644
--- a/drivers/dma/sa11x0-dma.c
+++ b/drivers/dma/sa11x0-dma.c
@@ -113,11 +113,9 @@ struct sa11x0_dma_phy {
 	struct sa11x0_dma_desc	*txd_load;
 	unsigned		sg_done;
 	struct sa11x0_dma_desc	*txd_done;
-#ifdef CONFIG_PM_SLEEP
 	u32			dbs[2];
 	u32			dbt[2];
 	u32			dcsr;
-#endif
 };
 
 struct sa11x0_dma_dev {
@@ -984,7 +982,6 @@ static int sa11x0_dma_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int sa11x0_dma_suspend(struct device *dev)
 {
 	struct sa11x0_dma_dev *d = dev_get_drvdata(dev);
@@ -1054,7 +1051,6 @@ static int sa11x0_dma_resume(struct device *dev)
 
 	return 0;
 }
-#endif
 
 static const struct dev_pm_ops sa11x0_dma_pm_ops = {
 	.suspend_noirq = sa11x0_dma_suspend,
-- 
1.8.3.2

