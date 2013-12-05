Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3LETa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:30:58 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:52527 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3LETaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:30:55 -0500
X-IronPort-AV: E=Sophos;i="4.93,835,1378882800"; 
   d="scan'208";a="161132"
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
Subject: [PATCH v4 3/8] Documentation: dt: kona-sdhci: Add clocks property
Date: Thu, 5 Dec 2013 11:20:39 -0800
Message-ID: <1386271244-3927-4-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kona SDHCI block requires a clock that must be specified in the
device tree.  Update the documentation to reflect this requirement.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 Documentation/devicetree/bindings/mmc/kona-sdhci.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/kona-sdhci.txt b/Documentation/devicetree/bindings/mmc/kona-sdhci.txt
index 789fb07..aaba248 100644
--- a/Documentation/devicetree/bindings/mmc/kona-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/kona-sdhci.txt
@@ -6,12 +6,16 @@ and the properties present in the bcm281xx SDHCI
 Required properties:
 - compatible : Should be "brcm,kona-sdhci"
 - DEPRECATED: compatible : Should be "bcm,kona-sdhci"
+- clocks: phandle + clock specifier pair of the external clock
+
+Refer to clocks/clock-bindings.txt for generic clock consumer properties.
 
 Example:
 
 sdio2: sdio@0x3f1a0000 {
 	compatible = "brcm,kona-sdhci";
 	reg = <0x3f1a0000 0x10000>;
+	clocks = <&sdio3_clk>;
 	interrupts = <0x0 74 0x4>;
 };
 
-- 
1.8.0.1

