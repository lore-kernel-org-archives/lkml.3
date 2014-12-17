Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLQScO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:32:14 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42679 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750900AbaLQScL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:32:11 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] mmc: core: stop trying to switch width when only one bit is supported
Date: Wed, 17 Dec 2014 19:32:06 +0100
Message-Id: <1418841126-13695-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_select_bus_width() will try to switch to MMC_BUS_WIDTH_4 even if
MMC_CAP_4_BIT_DATA and MMC_CAP_8_BIT_DATA are not set in host->caps.
Return as soon as possible when those flags are not set

Fixes: 577fb13199b11d8cd75609183649be4b5561243f (mmc: rework
selection of bus speed mode)

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: <stable@vger.kernel.org> # 3.17
---
 drivers/mmc/core/mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 02ad79229f65..7466ce098e60 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -886,7 +886,7 @@ static int mmc_select_bus_width(struct mmc_card *card)
 	unsigned idx, bus_width = 0;
 	int err = 0;
 
-	if (!mmc_can_ext_csd(card) &&
+	if (!mmc_can_ext_csd(card) ||
 	    !(host->caps & (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA)))
 		return 0;
 
-- 
2.1.0

