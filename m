Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbaFYM4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:56:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43808 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbaFYM4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:56:43 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <nm@ti.com>, <rnayak@ti.com>, <balbi@ti.com>, <nsekhar@ti.com>,
        <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH] ARM: DRA7-evm: Enable SATA PHY and USB PHY power supplies
Date: Wed, 25 Jun 2014 15:56:36 +0300
Message-ID: <1403700996-27105-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SATA and USB PHYs need the 1.8V and 3.3V supplies.
The PHY drivers/framework don't yet support regulator
supply so we have to keep these regulators always-on till
then.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 4adc280..99a1f79 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -241,6 +241,7 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-boot-on;
+					regulator-always-on;
 				};
 
 				ldo9_reg: ldo9 {
@@ -266,6 +267,7 @@
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
 					regulator-boot-on;
+					regulator-always-on;
 				};
 			};
 		};
-- 
1.8.3.2

