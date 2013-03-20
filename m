Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3CTW4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:56:34 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44566 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3CTWyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:54:35 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 06/11] ARM: dts: vexpress: disable CA9 core tile sp804 timer
Date: Wed, 20 Mar 2013 17:54:06 -0500
Message-Id: <1363820051-24428-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The motherboard sp804 timer is used, but core tile sp804 timer is not.
According to Russell King, the clock configuration is undocumented and
defaults to 32kHz which is not desireable. So mark core tile sp804 timer
as disabled.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/boot/dts/vexpress-v2p-ca9.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca9.dts b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
index 1420bb1..62d9b22 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca9.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
@@ -98,6 +98,7 @@
 			     <0 49 4>;
 		clocks = <&oscclk2>, <&oscclk2>;
 		clock-names = "timclk", "apb_pclk";
+		status = "disabled";
 	};
 
 	watchdog@100e5000 {
-- 
1.7.10.4

