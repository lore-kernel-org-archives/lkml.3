Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3KNTMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:12:49 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2694 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab3KNTLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:11:10 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Chris Ball" <cjb@laptop.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH v3 6/8] Documentation: dt: kona-timer: Add clocks
 property
Date: Thu, 14 Nov 2013 11:10:41 -0800
Message-ID: <1384456243-27053-7-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384456243-27053-1-git-send-email-tim.kryger@linaro.org>
References: <1384456243-27053-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E9BFFA24RS8193357-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frequency for the Kona timer can either be specified through the
device tree or determined by checking the rate of the clock specified
in the device tree.  Update the documentation to reflect both ways.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 Documentation/devicetree/bindings/arm/bcm/kona-timer.txt | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt b/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
index 17d88b2..b84e184 100644
--- a/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
+++ b/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
@@ -8,13 +8,19 @@ Required properties:
 - DEPRECATED: compatible : "bcm,kona-timer"
 - reg : Register range for the timer
 - interrupts : interrupt for the timer
+- clocks: clock specifier for the kona i2c external clock
 - clock-frequency: frequency that the clock operates
 
+Only one of clocks or clock-frequency should be specified.
+
+Refer to clocks/clock-bindings.txt for generic clock consumer
+properties.
+
 Example:
 	timer@35006000 {
 		compatible = "brcm,kona-timer";
 		reg = <0x35006000 0x1000>;
 		interrupts = <0x0 7 0x4>;
-		clock-frequency = <32768>;
+		clocks = <&hub_timer_clk>;
 	};
 
-- 
1.8.0.1


