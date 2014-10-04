Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaJDJss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 05:48:48 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48264 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaJDJsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 05:48:46 -0400
Message-ID: <542FC3D9.4080607@gmail.com>
Date: Sat, 04 Oct 2014 17:54:33 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: f.fainelli@gmail.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, richard@nod.at
Subject: [PATCH] drivers/net/phy/Kconfig: Let MDIO_BCM_UNIMAC depend on HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MDIO_BCM_UNIMAC needs HAS_IOMEM, so depend on it, the related error (
with allmodconfig under um):

    MODPOST 1205 modules
  ERROR: "devm_ioremap" [drivers/net/phy/mdio-bcm-unimac.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 14afa4f..75472cf7 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -205,6 +205,7 @@ config MDIO_BUS_MUX_MMIOREG
 
 config MDIO_BCM_UNIMAC
 	tristate "Broadcom UniMAC MDIO bus controller"
+	depends on HAS_IOMEM
 	help
 	  This module provides a driver for the Broadcom UniMAC MDIO busses.
 	  This hardware can be found in the Broadcom GENET Ethernet MAC
-- 
1.9.3
