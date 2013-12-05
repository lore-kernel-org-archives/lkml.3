Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3LETcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:32:20 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:43285 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3LETav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:30:51 -0500
X-IronPort-AV: E=Sophos;i="4.93,835,1378882800"; 
   d="scan'208";a="365453"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH v4 6/8] Documentation: dt: kona-timer: Add clocks property
Date: Thu, 5 Dec 2013 11:20:42 -0800
Message-ID: <1386271244-3927-7-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frequency for the Kona timer can either be specified through the
device tree or determined by checking the rate of the clock specified
in the device tree.  Update the documentation to reflect both ways.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 Documentation/devicetree/bindings/arm/bcm/kona-timer.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt b/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
index 17d88b2..39adf54 100644
--- a/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
+++ b/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
@@ -8,13 +8,18 @@ Required properties:
 - DEPRECATED: compatible : "bcm,kona-timer"
 - reg : Register range for the timer
 - interrupts : interrupt for the timer
+- clocks: phandle + clock specifier pair of the external clock
 - clock-frequency: frequency that the clock operates
 
+Only one of clocks or clock-frequency should be specified.
+
+Refer to clocks/clock-bindings.txt for generic clock consumer properties.
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

