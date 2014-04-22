Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaDVXvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:51:31 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:53627 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaDVXv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:51:27 -0400
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: yuvaraj.cd@samsung.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: Don't print data errors
Date: Tue, 22 Apr 2014 16:51:21 -0700
Message-Id: <1398210681-22976-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Data errors are completely expected during tuning.  Printing them out
is confusing people looking at the kernel logs.  They see things like:

 [    3.613296] dwmmc_exynos 12200000.dwmmc0: data error, status 0x00000088

...and they think something is wrong with their hardware.

Remove the printouts.  We'll leave it up to a higher level to report
about errors.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index cced599..4c8d423 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1248,7 +1248,7 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
 			data->error = -EIO;
 		}
 
-		dev_err(host->dev, "data error, status 0x%08x\n", status);
+		dev_dbg(host->dev, "data error, status 0x%08x\n", status);
 
 		/*
 		 * After an error, there may be data lingering
-- 
1.9.1.423.g4596e3a

