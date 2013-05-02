Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802Ab3EBPQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053Ab3EBPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH, RFC 08/22] OMAPDSS: DPI needs DSI
Date: Thu,  2 May 2013 17:16:12 +0200
Message-Id: <1367507786-505303-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:URwqjjHGbjVkFxOOvOBx8T8oyI9BPiy+tk0Z7/cZkGl
 fPjK2S4+WVcrKG2VKZexq+zkI+tUpaqvWBNC6T/OShBYboR4Um
 4q6fDfps3GaEApBt4UPD0ei5BiXEPc0rc/ZXjXdipRBaL7nTM2
 Ty3jtB72OYIq5fZjzkwqSdySQNKuAjctze85GRIwiNNnzb5mXw
 xVHK8UOMHlI3Lh58fiqEYg9/JCx8mOzKZct9wmrox4bNwfRtG4
 4SpjB1WkxaC1OztdMmR5fG5d1OUyMVtgQWqPHmNLpmi53u1oBu
 vK8U/JfG8V9y1v4U3Av8+OMhtDZLYD0gr5D4FBYSlfU7a+ltop
 n7UwGWo1le3U/XU9zPyymwFUnRqc1ujaIVI0555ju
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dpi.c file cannot be build correctly when the dsi.c file is
disabled in Kconfig. This clarifies the dependency in Kconfig
to avoid build errors:

drivers/video/omap2/dss/dpi.c: In function 'dpi_calc_pll_cb':
drivers/video/omap2/dss/dpi.c:181:2: error: implicit declaration of function 'dsi_hsdiv_calc' [-Werror=implicit-function-declaration]
drivers/video/omap2/dss/dpi.c: In function 'dpi_dsi_clk_calc':
drivers/video/omap2/dss/dpi.c:201:2: error: implicit declaration of function 'dsi_get_pll_clkin' [-Werror=implicit-function-declaration]

Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/video/omap2/dss/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/omap2/dss/Kconfig b/drivers/video/omap2/dss/Kconfig
index cb0f145..4b30084 100644
--- a/drivers/video/omap2/dss/Kconfig
+++ b/drivers/video/omap2/dss/Kconfig
@@ -35,6 +35,7 @@ config OMAP2_DSS_COLLECT_IRQ_STATS
 
 config OMAP2_DSS_DPI
 	bool "DPI support"
+	depends on OMAP2_DSS_DSI
 	default y
 	help
 	  DPI Interface. This is the Parallel Display Interface.
-- 
1.8.1.2

