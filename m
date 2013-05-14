Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab3ENHhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:37:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3ENHhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:37:39 -0400
From: Adam Lee <adam.lee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: nico@fluxnic.net, Doug Anderson <dianders@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH] mmc: core: Add a capability for disabling mmc cards
Date: Tue, 14 May 2013 15:38:17 +0800
Message-Id: <1368517100-22243-1-git-send-email-adam.lee@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems we need a way to disable MMC card support in a MMC/SD
card slot due to the legal concern.

Add support in the core SD/MMC code to support this.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/mmc/core/core.c  |    2 +-
 include/linux/mmc/host.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index c40396f..4788b88 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2271,7 +2271,7 @@ static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
 		return 0;
 	if (!mmc_attach_sd(host))
 		return 0;
-	if (!mmc_attach_mmc(host))
+	if (!(host->caps2 & MMC_CAP2_NO_MMC) && !mmc_attach_mmc(host))
 		return 0;
 
 	mmc_power_off(host);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index e326ae2..ffe5c3d 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -281,6 +281,7 @@ struct mmc_host {
 #define MMC_CAP2_PACKED_CMD	(MMC_CAP2_PACKED_RD | \
 				 MMC_CAP2_PACKED_WR)
 #define MMC_CAP2_NO_PRESCAN_POWERUP (1 << 14)	/* Don't power up before scan */
+#define MMC_CAP2_NO_MMC		(1 << 15)	/* Only SD supported, not MMC */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
-- 
1.7.10.4

