Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaHYM3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:29:22 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60169 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaHYM0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:36 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Ian Molton <ian.molton@codethink.co.uk>,
        Chris Ball <chris@printf.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 06/12] mmc: tmio: Mask all IRQs when inactive
Date: Mon, 25 Aug 2014 14:25:58 +0200
Message-Id: <1408969564-6335-7-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make sure we don't receive any spurious IRQs while we are inactive,
mask the IRQs from within the ->runtime_suspend() callback.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tmio_mmc_pio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index 2345177..d52280d 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -1168,6 +1168,8 @@ int tmio_mmc_host_runtime_suspend(struct device *dev)
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	struct tmio_mmc_host *host = mmc_priv(mmc);
 
+	tmio_mmc_disable_mmc_irqs(host, TMIO_MASK_ALL);
+
 	if (host->clk_cache)
 		tmio_mmc_clk_stop(host);
 
-- 
1.9.1

