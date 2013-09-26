Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3IZPAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:00:37 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:38909 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3IZOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:49 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 15/27] mmc: mxs-mmc: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:40 +0200
Message-Id: <1380207292-16968-16-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are being handled from the protocol layer
and consequently the mmc_suspend|resume_host APIs are deprecated.

This means we can simplify the suspend|resume callbacks by removing the
use of the deprecated APIs.

Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/mxs-mmc.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index e1fa3ef..50fc9df 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -724,13 +724,9 @@ static int mxs_mmc_suspend(struct device *dev)
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	struct mxs_mmc_host *host = mmc_priv(mmc);
 	struct mxs_ssp *ssp = &host->ssp;
-	int ret = 0;
-
-	ret = mmc_suspend_host(mmc);
 
 	clk_disable_unprepare(ssp->clk);
-
-	return ret;
+	return 0;
 }
 
 static int mxs_mmc_resume(struct device *dev)
@@ -738,13 +734,9 @@ static int mxs_mmc_resume(struct device *dev)
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	struct mxs_mmc_host *host = mmc_priv(mmc);
 	struct mxs_ssp *ssp = &host->ssp;
-	int ret = 0;
 
 	clk_prepare_enable(ssp->clk);
-
-	ret = mmc_resume_host(mmc);
-
-	return ret;
+	return 0;
 }
 
 static const struct dev_pm_ops mxs_mmc_pm_ops = {
-- 
1.7.9.5

