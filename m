Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaHNQpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:45:33 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:57889 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaHNQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:45:32 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alim Akhtar <alim.akhtar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 1/2] mmc: dw_mmc: Add dependency on DMA
Date: Thu, 14 Aug 2014 09:45:27 -0700
Message-Id: <1408034728-4952-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_mmc drivers rely on the DMA API, so update the Kconfig entry
to depend on HAS_DMA.  Since the drivers should build on any platform
with DMA, allow the driver to compile tested on non-ARC/ARM platforms.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/mmc/host/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index a565254..385674b 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -563,7 +563,8 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
 
 config MMC_DW
 	tristate "Synopsys DesignWare Memory Card Interface"
-	depends on ARC || ARM
+	depends on HAS_DMA
+	depends on ARC || ARM || COMPILE_TEST
 	help
 	  This selects support for the Synopsys DesignWare Mobile Storage IP
 	  block, this provides host support for SD and MMC interfaces, in both
-- 
2.1.0.rc2.206.gedb03e5

