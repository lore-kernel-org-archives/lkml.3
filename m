Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3LLN3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:29:39 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41703 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3LLN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:26:24 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v5 3/9] usb: gadget: s3c-hsotg: enable build for other platforms
Date: Thu, 12 Dec 2013 08:26:04 -0500
Message-Id: <1386854770-2173-4-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386854770-2173-1-git-send-email-mporter@linaro.org>
References: <1386854770-2173-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused Samsung-specific machine include and Kconfig
dependency on S3C.

Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/usb/gadget/Kconfig     | 7 +++----
 drivers/usb/gadget/s3c-hsotg.c | 2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index a91e642..970bd1a 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -294,11 +294,10 @@ config USB_PXA27X
 	   gadget drivers to also be dynamically linked.
 
 config USB_S3C_HSOTG
-	tristate "S3C HS/OtG USB Device controller"
-	depends on S3C_DEV_USB_HSOTG
+	tristate "Designware/S3C HS/OtG USB Device controller"
 	help
-	  The Samsung S3C64XX USB2.0 high-speed gadget controller
-	  integrated into the S3C64XX series SoC.
+	  The Designware USB2.0 high-speed gadget controller
+	  integrated into the S3C64XX and BCM281xx series SoC.
 
 config USB_S3C2410
 	tristate "S3C2410 USB Device Controller"
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 33eb690..8ceb5ef 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -37,8 +37,6 @@
 #include <linux/usb/phy.h>
 #include <linux/platform_data/s3c-hsotg.h>
 
-#include <mach/map.h>
-
 #include "s3c-hsotg.h"
 
 static const char * const s3c_hsotg_supply_names[] = {
-- 
1.8.4

