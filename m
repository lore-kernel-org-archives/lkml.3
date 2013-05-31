Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3EaWZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:25:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616Ab3EaWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 12/15] [media] davinci: vpfe_capture needs i2c
Date: Sat,  1 Jun 2013 00:22:49 +0200
Message-Id: <1370038972-2318779-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ZRtku/Oa8WuKnn7g6CvPjyxnNj4+datBLJVjpXLv/dy
 ZFJ6oi6JRcyiRl0oM70plEE2OstvNBEZzbf2HxUidTjU08opEg
 Fmy7US1Ca1IeDaL1nzQGq3PeBtNofXELiNaViBtWF4b+Ecekv9
 G/a3GZrRrK2rJrvcE52TRX4Ivf7qlVzAWT4XBlfcmfZYanMkoh
 5WeMa9lGOHsK98OuxGMyb4guITh7sKwtFZsElTqVsqK+O6L+M/
 IWnCyd2A7ZAAjGCcFtbTWKegpIVzuZmqrVBssDYLGE73zcQmwI
 k0Mk8b1g8HBH57AbgbwqEerGfNhOap0wxkt12IGTWMxpNeGRf4
 npyVZvGQLK45v6GqcWyiUshiJlijvlSQrTOrFHHMk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vpfe_capture driver is implicitly built for three of the davinci
capture drivers but depends on i2c, so we need to add the dependency
in Kconfig for each driver using this.

 drivers/media/platform/davinci/vpfe_capture.c: In function 'vpfe_probe':
 drivers/media/platform/davinci/vpfe_capture.c:1934:2: error: implicit declaration of function 'i2c_get_adapter' [-Werror=implicit-function-declaration]
 drivers/media/platform/davinci/vpfe_capture.c:1934:11: warning: assignment makes pointer from integer without a cast [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/davinci/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index afb3aec..02da88b 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -27,6 +27,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 config VIDEO_DM6446_CCDC
 	tristate "TI DM6446 CCDC video capture driver"
 	depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
+	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
@@ -41,6 +42,7 @@ config VIDEO_DM6446_CCDC
 config VIDEO_DM355_CCDC
 	tristate "TI DM355 CCDC video capture driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI
+	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables DM355 CCD hw module. DM355 CCDC hw interfaces
@@ -55,6 +57,7 @@ config VIDEO_DM355_CCDC
 config VIDEO_DM365_ISIF
 	tristate "TI DM365 ISIF video capture driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI
+	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables ISIF hw module. This is the hardware module for
-- 
1.8.1.2

