Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaJSORo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 10:17:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62678 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaJSOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 10:16:30 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        grant.likely@linaro.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, joe@perches.com, mchehab@osg.samsung.com,
        crope@iki.fi
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 1/4] ARM: sun7i: dt: Add Security System to A20 SoC DTS
Date: Sun, 19 Oct 2014 16:16:19 +0200
Message-Id: <1413728182-13569-2-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Security System is a hardware cryptographic accelerator that support
AES/MD5/SHA1/DES/3DES/PRNG algorithms.
It could be found on many Allwinner SoC.

This patch enable the Security System on the Allwinner A20 SoC Device-tree.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 82097c9..ebcdc76 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -577,6 +577,14 @@
 			status = "disabled";
 		};
 
+		crypto: crypto-engine@01c15000 {
+			compatible = "allwinner,sun7i-a20-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <0 86 4>;
+			clocks = <&ahb_gates 5>, <&ss_clk>;
+			clock-names = "ahb", "mod";
+		};
+
 		spi2: spi@01c17000 {
 			compatible = "allwinner,sun4i-a10-spi";
 			reg = <0x01c17000 0x1000>;
-- 
2.0.4

