Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaJCP4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:56:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56265 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaJCPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:55:57 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] mmc: sdhci-pxav3: Respect MMC_DDR52 timing on uhs signaling
Date: Fri,  3 Oct 2014 17:55:37 +0200
Message-Id: <1412351747-4188-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bb8175a8aa42d731a840cd474e348ac3367eb5a0
  ("mmc: sdhci: clarify DDR timing mode between SD-UHS and eMMC")
added MMC_DDR52 as eMMC's DDR mode to be distinguished from SD-UHS.

While the differentation may be useful, pxav3 SDHCI controller lacks
a corresponding check in its custom .set_uhs_signaling callback for
MMC_DDR52. This patch adds a new switch case for MMC_TIMING_MMC_DDR52
to MMC_TIMING_UHS_DDR50 case.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net> 
Cc: Ulf Hansson <ulf.hansson@linaro.org> 
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/sdhci-pxav3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 5036d7d39529..b55c807982fe 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -211,6 +211,7 @@ static void pxav3_set_uhs_signaling(struct sdhci_host *host, unsigned int uhs)
 	case MMC_TIMING_UHS_SDR104:
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR104 | SDHCI_CTRL_VDD_180;
 		break;
+	case MMC_TIMING_MMC_DDR52:
 	case MMC_TIMING_UHS_DDR50:
 		ctrl_2 |= SDHCI_CTRL_UHS_DDR50 | SDHCI_CTRL_VDD_180;
 		break;
-- 
2.1.1

