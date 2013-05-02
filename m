Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab3EBPQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053Ab3EBPQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH, RFC 21/22] davinci: vpfe_capture needs i2c
Date: Thu,  2 May 2013 17:16:25 +0200
Message-Id: <1367507786-505303-22-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NcQUxsa4FEdG1wZhKhbsr6pT+drw67OI/sXBSfudRxf
 BO8oLxJWAr+z/0dSAOtcnh1yz1zSnd7UOOQ+RFTbgjDMTRUII9
 1qNae7Jt1FlIxmn9Fr0AuCo++5CdkQUt8drt8fOa0JpLad3aJN
 6R3v95MDichOkMW7eovTZ9YDqay30gAzMLrPKMmyzobHs/gpZV
 3qZsUcE3hQx2JnxECVQP4K8wqOdKh0mkE8WaQyBBglp4egY9BQ
 ES4ul9nPcoyNpsdwQaxSYB1ClHUXQ7v9PG8BwYcqGKrzrLtQcf
 soSzhXXFNw4rlOd8nB/9By2ysSqAcw+syLY6xOZtHvymd5oyUR
 LPOQodZ+M/Z7OID1DAVIvnXmpn0HtBXGRhCWDP9ZU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vpfe_capture driver is implicitly built for three of the davinci
capture drivers but depends on i2c, so we need to add the dependency
in Kconfig for each driver using this.

 drivers/media/platform/davinci/vpfe_capture.c: In function 'vpfe_probe':
 drivers/media/platform/davinci/vpfe_capture.c:1934:2: error: implicit declaration of function 'i2c_get_adapter' [-Werror=implicit-function-declaration]
 drivers/media/platform/davinci/vpfe_capture.c:1934:11: warning: assignment makes pointer from integer without a cast [enabled by default]

Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

