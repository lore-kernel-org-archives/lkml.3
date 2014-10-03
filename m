Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaJCP6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:58:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34938 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaJCPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:55:57 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] mmc: sdhci-pxav3: Move private driver data to driver source
Date: Fri,  3 Oct 2014 17:55:38 +0200
Message-Id: <1412351747-4188-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct sdhci_pxa is only used in sdhci_pxa driver itself, so move it
there.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/sdhci-pxav3.c          | 5 +++++
 include/linux/platform_data/pxa_sdhci.h | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index b55c807982fe..48bc8179c8fc 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -58,6 +58,11 @@
 #define SDCE_MISC_INT		(1<<2)
 #define SDCE_MISC_INT_EN	(1<<1)
 
+struct sdhci_pxa {
+	u8	clk_enable;
+	u8	power_mode;
+};
+
 /*
  * These registers are relative to the second register region, for the
  * MBus bridge.
diff --git a/include/linux/platform_data/pxa_sdhci.h b/include/linux/platform_data/pxa_sdhci.h
index 27d3156d093a..9e20c2fb4ffd 100644
--- a/include/linux/platform_data/pxa_sdhci.h
+++ b/include/linux/platform_data/pxa_sdhci.h
@@ -55,9 +55,4 @@ struct sdhci_pxa_platdata {
 	unsigned int	quirks2;
 	unsigned int	pm_caps;
 };
-
-struct sdhci_pxa {
-	u8	clk_enable;
-	u8	power_mode;
-};
 #endif /* _PXA_SDHCI_H_ */
-- 
2.1.1

