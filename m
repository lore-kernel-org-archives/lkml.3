Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaCJOhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:37:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51086 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaCJOhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:37:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, ARM Maintainers <arm@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Boris BREZILLON <b.brezillon@overkiz.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH for 3.14] ARM: at91: fix network interface ordering for sama5d36
Date: Mon, 10 Mar 2014 15:37:18 +0100
Message-ID: <1394462238-22313-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon.dev@gmail.com>

On the newly introduced sama5d36, Gigabit and 10/100 Ethernet network
interfaces are probed in a different order than for the sama5d35.
Moreover, users are accustomed to this order in bootloaders and backports
for older kernel revisions.
So this patch switches DT node order as it is done for the other dual-Ethernet
sama5d3 SoC.
Better interface numbering which does not depend on DT node order is being
developed for stronger interface identification.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Olof, Arnd and Kevin,

I would like to include this fix in 3.14-final.
I do not have anymore patch for an at91-3.14-fixes branch so I only send this
single patch to you. Can you still take it?

Thanks, best regards,

 arch/arm/boot/dts/sama5d36.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d36.dtsi b/arch/arm/boot/dts/sama5d36.dtsi
index 6c31c26e6cc0..db58cad6acd3 100644
--- a/arch/arm/boot/dts/sama5d36.dtsi
+++ b/arch/arm/boot/dts/sama5d36.dtsi
@@ -8,8 +8,8 @@
  */
 #include "sama5d3.dtsi"
 #include "sama5d3_can.dtsi"
-#include "sama5d3_emac.dtsi"
 #include "sama5d3_gmac.dtsi"
+#include "sama5d3_emac.dtsi"
 #include "sama5d3_lcd.dtsi"
 #include "sama5d3_mci2.dtsi"
 #include "sama5d3_tcb1.dtsi"
-- 
1.8.2.2

