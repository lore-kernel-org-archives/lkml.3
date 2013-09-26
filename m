Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3IZO4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:56:15 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59637 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3IZO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:08 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Sascha Sommer <saschasommer@freenet.de>
Subject: [PATCH 22/27] mmc: sdricoh_cs: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:47 +0200
Message-Id: <1380207292-16968-23-git-send-email-ulf.hansson@linaro.org>
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

Cc: Sascha Sommer <saschasommer@freenet.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdricoh_cs.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 50adbd1..b7e3057 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -516,9 +516,7 @@ static void sdricoh_pcmcia_detach(struct pcmcia_device *link)
 #ifdef CONFIG_PM
 static int sdricoh_pcmcia_suspend(struct pcmcia_device *link)
 {
-	struct mmc_host *mmc = link->priv;
 	dev_dbg(&link->dev, "suspend\n");
-	mmc_suspend_host(mmc);
 	return 0;
 }
 
@@ -527,7 +525,6 @@ static int sdricoh_pcmcia_resume(struct pcmcia_device *link)
 	struct mmc_host *mmc = link->priv;
 	dev_dbg(&link->dev, "resume\n");
 	sdricoh_reset(mmc_priv(mmc));
-	mmc_resume_host(mmc);
 	return 0;
 }
 #else
-- 
1.7.9.5

