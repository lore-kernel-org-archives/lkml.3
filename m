Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab3CGWQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:16:10 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:33243 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab3CGWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:16:08 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] ARM: sunxi: hackberry: Add UART muxing
Date: Thu,  7 Mar 2013 23:14:20 +0100
Message-Id: <1362694460-1919-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362694460-1919-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1362694460-1919-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We previously relied on the bootloader to do the muxing of the UART for
the Hackberry. Don't rely on it anymore and use pinctrl.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10-hackberry.dts |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10-hackberry.dts b/arch/arm/boot/dts/sun4i-a10-hackberry.dts
index f84549a..97703fe 100644
--- a/arch/arm/boot/dts/sun4i-a10-hackberry.dts
+++ b/arch/arm/boot/dts/sun4i-a10-hackberry.dts
@@ -24,6 +24,8 @@
 
 	soc {
 		uart0: uart@01c28000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart0_pins_a>;
 			status = "okay";
 		};
 	};
-- 
1.7.10.4

