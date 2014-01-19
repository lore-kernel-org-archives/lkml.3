Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaASJaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 04:30:12 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:46626 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaASJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 04:30:05 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Amarinder Bindra <a-bindra@ti.com>, Balaji T K <balajitk@ti.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mmc: omap_hsmmc: Restrict compilation to ARM
Date: Sun, 19 Jan 2014 10:29:54 +0100
Message-Id: <1390123794-26401-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bcf24e1daa94f4c52ef7a3f657e43cc6bc50d46b ("mmc: omap_hsmmc: use the
generic config for omap2plus devices"), enabled the build for other
platforms for compile testing.

sh-allmodconfig now fails with:

    include/linux/omap-dma.h:171:8: error: expected identifier before numeric constant
    make[4]: *** [drivers/mmc/host/omap_hsmmc.o] Error 1

This happens because sh #defines "CCR", which is one of the enum values in
include/linux/omap-dma.h.

I expect a similar failure on blackfin, which also has #define CCR.

Restrict the build to ARM to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/10477672/

 drivers/mmc/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 7fc5099e44b2..14e94fb39164 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -284,7 +284,7 @@ config MMC_OMAP
 
 config MMC_OMAP_HS
 	tristate "TI OMAP High Speed Multimedia Card Interface support"
-	depends on ARCH_OMAP2PLUS || COMPILE_TEST
+	depends on ARCH_OMAP2PLUS || (COMPILE_TEST && ARM)
 	help
 	  This selects the TI OMAP High Speed Multimedia card Interface.
 	  If you have an omap2plus board with a Multimedia Card slot,
-- 
1.7.9.5

