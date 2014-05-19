Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaESSDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:03:01 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56864 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaESSDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:03:00 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] mmc: dove: fix missing MACH_DOVE dependency
Date: Mon, 19 May 2014 20:02:51 +0200
Message-Id: <1400522571-10799-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT-enabled Dove moved over from ARCH_DOVE in mach-dove to MACH_DOVE in
mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
DT-only MACH_DOVE Kconfig. This slipped through the cracks and now is
a fix to allow to build Dove's SDHCI driver for mach-mvebu on v3.15-rc.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 8aaf8c1f3f63..37665553ef33 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -168,7 +168,7 @@ config MMC_SDHCI_ESDHC_IMX
 
 config MMC_SDHCI_DOVE
 	tristate "SDHCI support on Marvell's Dove SoC"
-	depends on ARCH_DOVE
+	depends on ARCH_DOVE || MACH_DOVE
 	depends on MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
-- 
1.9.1

