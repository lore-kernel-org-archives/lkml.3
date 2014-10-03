Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaJCP6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:58:04 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54499 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaJCPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:55:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] mmc: sdhci-pxav3: Try to get named I/O clock first
Date: Fri,  3 Oct 2014 17:55:42 +0200
Message-Id: <1412351747-4188-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With support for more than one clock, we'll need to distinguish between
the clock by name. Change clock probing to first try to get "io" clock
before falling back to unnamed clock.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/sdhci-pxav3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index a34a589670e6..3dfd97977515 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -309,7 +309,9 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 	pltfm_host = sdhci_priv(host);
 	pltfm_host->priv = pxa;
 
-	pxa->clk_io = devm_clk_get(dev, NULL);
+	pxa->clk_io = devm_clk_get(dev, "io");
+	if (IS_ERR(pxa->clk_io))
+		pxa->clk_io = devm_clk_get(dev, NULL);
 	if (IS_ERR(pxa->clk_io)) {
 		dev_err(dev, "failed to get io clock\n");
 		ret = PTR_ERR(pxa->clk_io);
-- 
2.1.1

