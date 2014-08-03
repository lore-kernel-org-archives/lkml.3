Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaHCChI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 22:37:08 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63094 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaHCChG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 22:37:06 -0400
Message-ID: <1407033419.17812.2.camel@phoenix>
Subject: [PATCH 1/2] gpu: ipu-v3: Select GENERIC_IRQ_CHIP to fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 03 Aug 2014 10:36:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses GENERIC_IRQ_CHIP, so it needs to select GENERIC_IRQ_CHIP to
avoid build error.

Fixes below build errors:
ERROR: "irq_alloc_domain_generic_chips" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_gc_mask_clr_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_gc_mask_set_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_generic_chip_ops" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_gc_ack_set_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_get_domain_generic_chip" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpu/ipu-v3/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/ipu-v3/Kconfig b/drivers/gpu/ipu-v3/Kconfig
index 2f228a2..01864a5 100644
--- a/drivers/gpu/ipu-v3/Kconfig
+++ b/drivers/gpu/ipu-v3/Kconfig
@@ -2,6 +2,7 @@ config IMX_IPUV3_CORE
 	tristate "IPUv3 core support"
 	depends on SOC_IMX5 || SOC_IMX6Q || SOC_IMX6SL || ARCH_MULTIPLATFORM
 	depends on RESET_CONTROLLER
+	select GENERIC_IRQ_CHIP
 	help
 	  Choose this if you have a i.MX5/6 system and want to use the Image
 	  Processing Unit. This option only enables IPU base support.
-- 
1.9.1



