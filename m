Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbbAZKXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:23:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbbAZKXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:23:36 -0500
Date: Mon, 26 Jan 2015 11:23:28 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mmc: Add hardware dependencies for sdhci-pxav3 and
 sdhci-pxav2
Message-ID: <20150126112328.318da5e7@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to understand that the sdhci-pxav3 and sdhci-pxav2 drivers are
only needed on the MMP architecture. So add a hardware dependency on
ARCH_MMP, so that other users don't get to build useless drivers.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
This patch was already sent on:
 * 2014-04-23
 * 2014-06-16

 drivers/mmc/host/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-3.19-rc6.orig/drivers/mmc/host/Kconfig	2015-01-26 10:30:56.472182636 +0100
+++ linux-3.19-rc6/drivers/mmc/host/Kconfig	2015-01-26 11:13:33.669863314 +0100
@@ -228,6 +228,7 @@ config MMC_SDHCI_PXAV3
 	tristate "Marvell MMP2 SD Host Controller support (PXAV3)"
 	depends on CLKDEV_LOOKUP
 	depends on MMC_SDHCI_PLTFM
+	depends on ARCH_MMP || COMPILE_TEST
 	default CPU_MMP2
 	help
 	  This selects the Marvell(R) PXAV3 SD Host Controller.
@@ -240,6 +241,7 @@ config MMC_SDHCI_PXAV2
 	tristate "Marvell PXA9XX SD Host Controller support (PXAV2)"
 	depends on CLKDEV_LOOKUP
 	depends on MMC_SDHCI_PLTFM
+	depends on ARCH_MMP || COMPILE_TEST
 	default CPU_PXA910
 	help
 	  This selects the Marvell(R) PXAV2 SD Host Controller.


-- 
Jean Delvare
SUSE L3 Support
