Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3DZMo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:44:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43777 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab3DZMnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:43:10 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCHv4 4/5] arm: dts: am33xx: Remove "ti,no_idle_on_suspend" property.
Date: Fri, 26 Apr 2013 18:12:47 +0530
Message-ID: <1366980168-30566-5-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>
References: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ti,no_idle_on_suspend" property was required to keep ocmcram clocks
running during idle.

But commit 72bb6f9 (ARM: OMAP: omap_device: don't attempt late suspend
if no driver bound), added in v3.6 should prevent any automatic clock
gating for devices without drivers bound.  Since there is no driver for
the OCM RAM block, we are not affected by the automatic idle on suspend
anyways which means "ti,no_idle_on_suspend" can be safely removed since
there are no users for it.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 0957645..729ca24 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -390,7 +390,6 @@
 			compatible = "ti,am3352-ocmcram";
 			reg = <0x40300000 0x10000>;
 			ti,hwmods = "ocmcram";
-			ti,no_idle_on_suspend;
 		};
 
 		wkup_m3: wkup_m3@44d00000 {
-- 
1.7.1

