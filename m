Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3JHKe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:34:26 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34748 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3JHKeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:34:25 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nataraja.km@lge.com, Majunath Goudar <csmanjuvijay@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Shawn Guo <shawn.guo@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexander Shiyan <shc_work@mail.ru>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] BUS: CCI : Fix arm-cci implicit declarations dependence errors.
Date: Tue,  8 Oct 2013 16:04:09 +0530
Message-Id: <1381228449-19575-1-git-send-email-csmanjuvijay@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a OF dependency to configure the ARM_CCI in drivers/bus/Kconfig.
Without this patch, build system can lead to build failure. This was observed
during randconfig testing, in which ARM_CCI was enabled w/o OF being enabled.
Following was the error:

CC      drivers/bus/arm-cci.o
drivers/bus/arm-cci.c: In function ‘cci_ace_init_ports’:
drivers/bus/arm-cci.c:131:2: error: implicit declaration of function
‘of_find_node_by_path’ [-Werror=implicit-function-declaration]
  cpus = of_find_node_by_path("/cpus");
  ^
drivers/bus/arm-cci.c:131:7: warning: assignment makes pointer from integer
without a cast [enabled by default]
  cpus = of_find_node_by_path("/cpus");
       ^
cc1: some warnings being treated as errors
make[2]: *** [drivers/bus/arm-cci.o] Error 1
make[1]: *** [drivers/bus] Error 2

Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org
---
 drivers/bus/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 552373c..e522bd6 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -37,7 +37,7 @@ config OMAP_INTERCONNECT
 
 config ARM_CCI
 	bool "ARM CCI driver support"
-	depends on ARM
+	depends on ARM && OF
 	help
 	  Driver supporting the CCI cache coherent interconnect for ARM
 	  platforms.
-- 
1.7.9.5

