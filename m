Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaDAQQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:16:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaDAQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 45/86] spi: coldfire-qspi: Fix getting correct address for *mcfqspi
Date: Tue,  1 Apr 2014 09:07:58 -0700
Message-Id: <1396368519-12728-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit ee73b4c6e3fc0755a91752ab8eebc8e070038b53 upstream.

dev_get_drvdata() returns the address of master rather than mcfqspi.

Fixes: af361079 (spi/coldfire-qspi: Drop extra calls to spi_master_get in suspend/resume functions)
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-coldfire-qspi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index 58466b8..7c23879 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -566,7 +566,8 @@ static int mcfqspi_resume(struct device *dev)
 #ifdef CONFIG_PM_RUNTIME
 static int mcfqspi_runtime_suspend(struct device *dev)
 {
-	struct mcfqspi *mcfqspi = platform_get_drvdata(to_platform_device(dev));
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct mcfqspi *mcfqspi = spi_master_get_devdata(master);
 
 	clk_disable(mcfqspi->clk);
 
@@ -575,7 +576,8 @@ static int mcfqspi_runtime_suspend(struct device *dev)
 
 static int mcfqspi_runtime_resume(struct device *dev)
 {
-	struct mcfqspi *mcfqspi = platform_get_drvdata(to_platform_device(dev));
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct mcfqspi *mcfqspi = spi_master_get_devdata(master);
 
 	clk_enable(mcfqspi->clk);
 
-- 
1.8.3.2

