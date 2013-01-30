Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3A3UL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:11:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50903 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3A3ULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:11:25 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Chris Ball <cjb@laptop.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdhci-esdhc-imx: Remove unused variables
Date: Wed, 30 Jan 2013 21:11:21 +0100
Message-Id: <1359576681-14797-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:chDgFi7/mlT7XEjXRvrBpPfbZ2XOALOWe/ZY4LBrd+o
 6OLG5aIegjld11I4ZjVqt3PwkQJpWeFMs7ZR8F3w9EpMCV/xaP
 EEoyYih2B5gzeM0qtVp7/KNIKtIM501/uym/SsjK+XkNmRUkzF
 SNcmtc4VRGRkZIu6z7fltRD0alLhC7GJAGmgHmdGdVYyqz7/H6
 TV8i9J+X6+LFZBDyBzuZ3tm7CA8Y5bvt9yTF3BA/fUkkPGX97i
 K/VPTrJNuAgJfWLoAEY7PgutTiuMyrSLhMV4PFRoTBIG1xtw/x
 0Hgn4vpzXeoIMQfDDXEvI6tYh1mUC1KdaKog6RXX4E/SEifRJ5
 1ObvYfz7R2gl2zAPAb+tbyKYLN7MhTIGOkXk8rca+0ZKZk2qO3
 vrKqWJo8p3jpG1ib0P3tj+ZtsTGfg8YlJ+ZUK42v8b1JXxhrzc
 8M6Sk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3f175a6 (mmc: sdhci-esdhc-imx: remove ESDHC_CD_GPIO handling from
IO accessory) removed all the code that was using these variables, so it
is safe to drop them.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index ae68bc9..509be3a 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -144,10 +144,6 @@ static inline void esdhc_clrset_le(struct sdhci_host *host, u32 mask, u32 val, i
 
 static u32 esdhc_readl_le(struct sdhci_host *host, int reg)
 {
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct pltfm_imx_data *imx_data = pltfm_host->priv;
-	struct esdhc_platform_data *boarddata = &imx_data->boarddata;
-
 	u32 val = readl(host->ioaddr + reg);
 
 	if (unlikely(reg == SDHCI_CAPABILITIES)) {
@@ -178,7 +174,6 @@ static void esdhc_writel_le(struct sdhci_host *host, u32 val, int reg)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = pltfm_host->priv;
-	struct esdhc_platform_data *boarddata = &imx_data->boarddata;
 	u32 data;
 
 	if (unlikely(reg == SDHCI_INT_ENABLE || reg == SDHCI_SIGNAL_ENABLE)) {
-- 
1.8.1.2

