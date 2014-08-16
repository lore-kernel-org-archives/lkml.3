Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaHPUdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 16:33:25 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61359 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaHPUdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 16:33:23 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andreas Ruprecht <rupran@einserver.de>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: davinci: remove unneeded dependency ARCH_OMAP3
Date: Sat, 16 Aug 2014 21:33:18 +0100
Message-Id: <1408221198-27458-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch removes unneeded dependency of ARCH_OMAP3
on VIDEO_DM6446_CCDC.
Also the top level platform Makefile descended into
davinci/ without any dependency so just drop the
dependency obj-y, as obj-$(CONFIG_ARCH_DAVINCI)
already exists.

Reported-by: Andreas Ruprecht <rupran@einserver.de>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/Makefile        | 2 --
 drivers/media/platform/davinci/Kconfig | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e5269da..13aef34 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -47,8 +47,6 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 
-obj-y	+= davinci/
-
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
 
 ccflags-y += -I$(srctree)/drivers/media/i2c
diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index afb3aec..298e1ee 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -26,7 +26,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 
 config VIDEO_DM6446_CCDC
 	tristate "TI DM6446 CCDC video capture driver"
-	depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
+	depends on VIDEO_V4L2 && ARCH_DAVINCI
 	select VIDEOBUF_DMA_CONTIG
 	help
 	   Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
-- 
1.9.1

