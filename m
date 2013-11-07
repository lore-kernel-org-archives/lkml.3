Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3KGOoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:44:39 -0500
Received: from shark4.inbox.lv ([89.111.3.84]:46982 "EHLO shark4.inbox.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab3KGOoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:44:38 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 09:44:38 EST
From: Dmitry Artamonow <mad_soft@inbox.lv>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.lv>
Subject: [PATCH] ARM: pxa/colibri: fix build with CONFIG_USB_OHCI_HCD=y
Date: Thu,  7 Nov 2013 18:36:53 +0400
Message-Id: <1383835013-22215-1-git-send-email-mad_soft@inbox.lv>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following build failure observed when support for
OHCI host controller is enabled.

  CC      arch/arm/mach-pxa/colibri-evalboard.o
arch/arm/mach-pxa/colibri-evalboard.c: In function 'colibri_ohci_init':
arch/arm/mach-pxa/colibri-evalboard.c:68: error: implicit declaration of function 'IOMEM'
make[1]: *** [arch/arm/mach-pxa/colibri-evalboard.o] Error 1
make: *** [arch/arm/mach-pxa] Error 2

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.lv>
---
 arch/arm/mach-pxa/colibri-evalboard.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-pxa/colibri-evalboard.c b/arch/arm/mach-pxa/colibri-evalboard.c
index 8404b24..57f661d 100644
--- a/arch/arm/mach-pxa/colibri-evalboard.c
+++ b/arch/arm/mach-pxa/colibri-evalboard.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/io.h>
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <asm/mach/arch.h>
-- 
1.8.1.2

