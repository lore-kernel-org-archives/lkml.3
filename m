Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbaGCJkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:40:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34570 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaGCJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:40:17 -0400
Message-ID: <53B524FA.2090907@ti.com>
Date: Thu, 3 Jul 2014 12:40:10 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>, <nm@ti.com>
CC: <nsekhar@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH v2 1/6] ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always
 on
References: <1404302638-3003-1-git-send-email-rogerq@ti.com> <1404302638-3003-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1404302638-3003-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

After clarification from the hardware team it was found that
this 1.8V PHY supply can't be switched OFF when SoC is Active.

Since the PHY IPs don't contain isolation logic built in the design to
allow the power rail to be switched off, there is a very high risk
of IP reliability and additional leakage paths which can result in
additional power consumption.

The only scenario where this rail can be switched off is part of Power on
reset sequencing, but it needs to be kept always-on during operation.

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

