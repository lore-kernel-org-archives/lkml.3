Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3IZPDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:03:06 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52248 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3IZOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:06 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>
Subject: [PATCH 02/27] mmc: au1xmmc: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:27 +0200
Message-Id: <1380207292-16968-3-git-send-email-ulf.hansson@linaro.org>
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

Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/au1xmmc.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index df9becd..f5443a6 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1157,11 +1157,6 @@ static int au1xmmc_remove(struct platform_device *pdev)
 static int au1xmmc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct au1xmmc_host *host = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = mmc_suspend_host(host->mmc);
-	if (ret)
-		return ret;
 
 	au_writel(0, HOST_CONFIG2(host));
 	au_writel(0, HOST_CONFIG(host));
@@ -1178,7 +1173,7 @@ static int au1xmmc_resume(struct platform_device *pdev)
 
 	au1xmmc_reset_controller(host);
 
-	return mmc_resume_host(host->mmc);
+	return 0;
 }
 #else
 #define au1xmmc_suspend NULL
-- 
1.7.9.5

