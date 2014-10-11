Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaJKEQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 00:16:28 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41565 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaJKEQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 00:16:26 -0400
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: Change signal voltage error to dev_dbg()
Date: Fri, 10 Oct 2014 21:16:16 -0700
Message-Id: <1413000976-2038-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (28f92b5 mmc: core: Try other signal levels during power up) we can
see that there are times when it's valid to try several signal
voltages.  Don't print an ugly error in the logs when that happens.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 69f0cc6..c4afbdd 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1075,7 +1075,7 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 		ret = regulator_set_voltage(mmc->supply.vqmmc, min_uv, max_uv);
 
 		if (ret) {
-			dev_err(&mmc->class_dev,
+			dev_dbg(&mmc->class_dev,
 					 "Regulator set error %d: %d - %d\n",
 					 ret, min_uv, max_uv);
 			return ret;
-- 
2.1.0.rc2.206.gedb03e5

