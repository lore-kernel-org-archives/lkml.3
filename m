Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaBQTYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:24:55 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16726 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaBQTYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:24:54 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18/ZGB7FqByN2QitpYGeAAQRsofDrxg9wc=
X-DKIM: OpenDKIM Filter v2.0.1 titan B216A52A91F
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: [RESEND PATCH] ARM: dove: dt: revert PMU interrupt controller node
Date: Mon, 17 Feb 2014 19:24:33 +0000
Message-Id: <1392665073-25831-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <20140207180836.GE8533@titan.lakedaemon.net>
References: <20140207180836.GE8533@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The corresponding driver didn't make it into v3.14, so we need to remove
the node.  Dove systems fail to boot with the node present and no
driver.

This node will be re-added when the driver makes it to mainline.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
Sorry for the resend, infradead.org didn't like the way I specified the list
address.

And after more careful reading, I missed a '>' in my cut-n-paste of Andrew's
email address.  Sorry for the unnecessary noise.

Also, I plan to submit this in mvebu/dt-fixes for v3.14

 arch/arm/boot/dts/dove.dtsi | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 2b76524f4aa7..967898528062 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -379,15 +379,6 @@
 				#clock-cells = <1>;
 			};
 
-			pmu_intc: pmu-interrupt-ctrl@d0050 {
-				compatible = "marvell,dove-pmu-intc";
-				interrupt-controller;
-				#interrupt-cells = <1>;
-				reg = <0xd0050 0x8>;
-				interrupts = <33>;
-				marvell,#interrupts = <7>;
-			};
-
 			pinctrl: pin-ctrl@d0200 {
 				compatible = "marvell,dove-pinctrl";
 				reg = <0xd0200 0x10>;
-- 
1.8.5.5

