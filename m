Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3JWNNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:13:07 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:46027 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3JWNNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:13:06 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdhci: dove: Fix build breakage
Date: Wed, 23 Oct 2013 15:10:32 +0200
Message-Id: <1382533832-21085-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2d7c51f (mmc: sdhci: Use work structs instead of tasklets)
converts tasklets to work structs, but typos the conversion in the Dove
driver.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/mmc/host/sdhci-dove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index 45c7f25..95f1076 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -39,7 +39,7 @@ static irqreturn_t sdhci_dove_carddetect_irq(int irq, void *data)
 {
 	struct sdhci_host *host = data;
 
-	schedule_schedule(&host->card_detect_work);
+	schedule_work(&host->card_detect_work);
 	return IRQ_HANDLED;
 }
 
-- 
1.8.4

