Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaGBMFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:05:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33855 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaGBMEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:04:12 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 1/6] ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always on
Date: Wed, 2 Jul 2014 15:03:53 +0300
Message-ID: <1404302638-3003-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404302638-3003-1-git-send-email-rogerq@ti.com>
References: <1404302638-3003-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After clarification from the hardware team it was found that
this 1.8V PHY supply can't be switched OFF when SoC is Active.
It can only be switched off when in PORz (power on reset).

This patch is required for proper functionality of USB, SATA
and PCIe on DRA7-evm.

CC: Rajendra Nayak <rnayak@ti.com>
CC: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 4adc280..8308954 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -240,6 +240,7 @@
 					regulator-name = "ldo3";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
 					regulator-boot-on;
 				};
 
-- 
1.8.3.2

