Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3HPMXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:23:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58134 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3HPMXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:23:07 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: <akpm@linux-foundation.org>, <khilman@linaro.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
CC: <rob.herring@calxeda.com>, <mark.rutland@arm.com>, <a.zummo@towertech.it>,
        <rob@landley.net>, <grant.likely@linaro.org>,
        <rtc-linux@googlegroups.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>
Subject: [PATCH v4 2/2] ARM: dts: AM33XX: update rtc node compatibility
Date: Fri, 16 Aug 2013 17:51:54 +0530
Message-ID: <1376655714-28947-3-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1376655714-28947-1-git-send-email-gururaja.hebbar@ti.com>
References: <1376655714-28947-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hebbar Gururaja <gururaja.hebbar@ti.com>

Since AM33xx RTC IP has RTC_IRQWAKEEN to support Alarm Wake-up, update
the rtc compatible property to enable handling of this feature inside
rtc-omap driver.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
CC: mark.rutland@arm.com
---
Changes in V4:
	- No change.

Changes in V3:
	- Instead of replacing the old matching string, add new
	  matching compatible as 1st and maintain old compatible string
	  for backwards compatibility 

Changes in V2:
	- Add new compatible to existing one so that when driver
	  supports enhanced features of hardware, they are available
	  to the user else the basic functionality still works
:100644 100644 0aaf8ce... daeafa0... M	arch/arm/boot/dts/am33xx.dtsi
 arch/arm/boot/dts/am33xx.dtsi |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 0aaf8ce..daeafa0 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -317,7 +317,7 @@
 		};
 
 		rtc@44e3e000 {
-			compatible = "ti,da830-rtc";
+			compatible = "ti,am3352-rtc", "ti,da830-rtc";
 			reg = <0x44e3e000 0x1000>;
 			interrupts = <75
 				      76>;
-- 
1.7.0.4

