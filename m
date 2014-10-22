Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaJVS3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:29:32 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35569 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaJVS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:27:05 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/9] net: pxa168_eth: Provide phy_interface mode on platform_data
Date: Wed, 22 Oct 2014 20:26:45 +0200
Message-Id: <1414002412-13615-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1414002412-13615-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1414002412-13615-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PXA168 Ethernet IP support MII and RMII connection to its PHY.
Currently, pxa168 platform_data does not provide a way to pass that
and there is one user of pxa168 platform_data (mach-mmp/gplug).
Given the pinctrl settings of gplug it uses RMII, so add and pass
a corresponding phy_interface_t.

Tested-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-mmp/gplugd.c | 2 ++
 include/linux/pxa168_eth.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/mach-mmp/gplugd.c b/arch/arm/mach-mmp/gplugd.c
index d81b2475e67e..3b5794cd0357 100644
--- a/arch/arm/mach-mmp/gplugd.c
+++ b/arch/arm/mach-mmp/gplugd.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/gpio-pxa.h>
+#include <linux/phy.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -158,6 +159,7 @@ struct pxa168_eth_platform_data gplugd_eth_platform_data = {
 	.port_number = 0,
 	.phy_addr    = 0,
 	.speed       = 0, /* Autonagotiation */
+	.intf        = PHY_INTERFACE_MODE_RMII,
 	.init        = gplugd_eth_init,
 };
 
diff --git a/include/linux/pxa168_eth.h b/include/linux/pxa168_eth.h
index 18d75e795606..37c381120bc8 100644
--- a/include/linux/pxa168_eth.h
+++ b/include/linux/pxa168_eth.h
@@ -13,6 +13,7 @@ struct pxa168_eth_platform_data {
 	 */
 	int	speed;		/* 0, SPEED_10, SPEED_100 */
 	int	duplex;		/* DUPLEX_HALF or DUPLEX_FULL */
+	phy_interface_t intf;
 
 	/*
 	 * Override default RX/TX queue sizes if nonzero.
-- 
2.1.1

