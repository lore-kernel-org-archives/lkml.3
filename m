Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaJITPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:15:33 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:52496 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaJITMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:12:32 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>,
        AnilKumar Ch <anilkumar@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 12/12] ARM: dts: am335x-bone-common: enable power off and rtc wake up
Date: Thu,  9 Oct 2014 21:06:34 +0200
Message-Id: <1412881594-25678-13-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1412881594-25678-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure the RTC as system-power controller, which allows the system to
be powered off as well as woken up again on subsequent RTC alarms.

Note that the PMIC needs to be put in SLEEP (rather than OFF) mode to
maintain RTC power. Specifically, this means that the PMIC
ti,pmic-shutdown-controller property must be left unset in order to be
able to wake up on RTC alarms.

Tested on BeagleBone Black (rev A5).

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index bde1777b62be..d0693bea9580 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -298,3 +298,7 @@
 	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
 	cd-inverted;
 };
+
+&rtc {
+	ti,system-power-controller;
+};
-- 
2.0.4

