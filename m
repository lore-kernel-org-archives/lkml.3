Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161147Ab3BNWsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:48:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161102Ab3BNWsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:48:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 7/9] remoteproc: omap: depend on OMAP_MBOX_FWK
Date: Thu, 14 Feb 2013 23:47:49 +0100
Message-Id: <1360882071-4072668-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Rj7WFOvnwBdFxGVxelGAohTpIJ8wJvr0ccgRRlYQh6R
 bPxjv82OHyl2QiDuxREc0XI6txMjk0lRBdj35K87eAu71o8r3B
 VeeRDbzNAEGdcmohSiz5mG/Mn8PEWZlG3Lve+hDijJB9JO33mU
 NP0hJ/84RUfOMtzz7ab9gqhUSqukH6Ws23UOhmr8DiPSNJd6Kw
 tNIdv57O/NXNvTnmTBF7BPUtVGeYYI8RRWZ1YPcYyZgZx2gLql
 2pXsBxDS+OcmQXyrL36/xNu/xQ4mR5ou1X8HitL9R1bzyIUR4g
 QczBEZZsszMsLjSZFTEaMjxoQlXqjGLZo979oWhUXEEBBoRZ+f
 Zw1popLXt53PQQpx5zBRmCJ/SLj5P/YCGMMkYYq6+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch a62a6e98 "ARM: OMAP2+: Disable code that currently does not work
with multiplaform" makes the OMAP_MBOX_FWK option depend on !MULTIPLATFORM,
which means we cannot simply select that symbol from OMAP_REMOTEPROC.

Turning the 'select' into 'depends on' ensures that all dependencies
are correct until OMAP_MBOX_FWK loses its dependency.

Without this patch, building allmodconfig results in:

drivers/remoteproc/omap_remoteproc.c:31:26: fatal error: plat/mailbox.h: No such file or directory

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 0b24108..cc1f7bf 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -12,8 +12,8 @@ config OMAP_REMOTEPROC
 	depends on HAS_DMA
 	depends on ARCH_OMAP4
 	depends on OMAP_IOMMU
+	depends on OMAP_MBOX_FWK
 	select REMOTEPROC
-	select OMAP_MBOX_FWK
 	select RPMSG
 	help
 	  Say y here to support OMAP's remote processors (dual M3
-- 
1.8.1.2

