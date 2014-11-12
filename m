Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaKLWLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:11:40 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36578 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaKLWLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:11:17 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com,
        gta04-owner@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 5/5] arm: dts: omap3-gta04: Add static configuration for devconf1 register
Date: Wed, 12 Nov 2014 23:10:47 +0100
Message-Id: <1415830247-31633-6-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415830247-31633-1-git-send-email-marek@goldelico.com>
References: <1415830247-31633-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gta04 board need for tvout enabled 2 bits in devconf1 register (tvbypass and acbias).
Add pinctrl single entry and enable it.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index b50dc10..0015316 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -497,3 +497,14 @@
 		};
 	};
 };
+
+&control_devconf1 {
+	pinctrl-name = "default";
+	pinctrl-0 = <&tv_acbias_pins>;
+
+	tv_acbias_pins: pinmux_tv_acbias_pins {
+		pinctrl-single,bits = <
+			0 0x40800 0x40800
+		>;
+	};
+};
-- 
1.9.1

