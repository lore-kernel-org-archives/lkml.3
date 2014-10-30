Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbaJ3GhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:37:24 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:60240 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbaJ3GhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:37:09 -0400
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="49699559"
From: Scott Branden <sbranden@broadcom.com>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Chris Ball <chris@printf.net>,
        Piotr Krol <pietrushnic@gmail.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, <linux-rpi-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCHv2 5/5] mmc: sdhci-bcm2835: add sdhci quirk SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12
Date: Wed, 29 Oct 2014 23:36:57 -0700
Message-ID: <1414651017-3545-6-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 is missing and needed for this controller.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/mmc/host/sdhci-bcm2835.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
index 11af27f..2a4c10b 100644
--- a/drivers/mmc/host/sdhci-bcm2835.c
+++ b/drivers/mmc/host/sdhci-bcm2835.c
@@ -159,7 +159,8 @@ static const struct sdhci_ops bcm2835_sdhci_ops = {
 };
 
 static const struct sdhci_pltfm_data bcm2835_sdhci_pdata = {
-	.quirks = SDHCI_QUIRK_BROKEN_CARD_DETECTION |
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
+		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK,
 	.ops = &bcm2835_sdhci_ops,
 };
-- 
1.7.9.5

