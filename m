Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaJUJ0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:26:55 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50924 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaJUJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:22:53 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 02/12] mmc: sdhci-pxav3: Respect MMC_DDR52 timing on uhs signaling
Date: Tue, 21 Oct 2014 11:22:34 +0200
Message-Id: <1413883364-681-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: devicetree@vger.kernel.org
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

