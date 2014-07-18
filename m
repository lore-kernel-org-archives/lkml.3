Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422748AbaGRRVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:21:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030449AbaGRRVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:21:40 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/SAMSUNG ARM
	A...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/4] ARM: dts: exynos5250: cypress,cyapa trackpad is Snow only
Date: Fri, 18 Jul 2014 19:20:07 +0200
Message-Id: <1405704009-8430-3-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405704009-8430-1-git-send-email-afaerber@suse.de>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it from exynos5250-cros-common.dtsi to exynos5250-snow.dts.
Spring does not need it, it uses an Atmel maXTouch instead.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2: New (Doug Anderson)

 arch/arm/boot/dts/exynos5250-cros-common.dtsi |  8 --------
 arch/arm/boot/dts/exynos5250-snow.dts         | 10 ++++++++++
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-cros-common.dtsi b/arch/arm/boot/dts/exynos5250-cros-common.dtsi
index 61128d1..e603e9c 100644
--- a/arch/arm/boot/dts/exynos5250-cros-common.dtsi
+++ b/arch/arm/boot/dts/exynos5250-cros-common.dtsi
@@ -39,14 +39,6 @@
 		status = "okay";
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-max-bus-freq = <378000>;
-
-		trackpad {
-			reg = <0x67>;
-			compatible = "cypress,cyapa";
-			interrupts = <2 0>;
-			interrupt-parent = <&gpx1>;
-			wakeup-source;
-		};
 	};
 
 	i2c@12C80000 {
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 0f867a3..f2b8c41 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -490,6 +490,16 @@
 	};
 };
 
+&i2c_1 {
+	trackpad {
+		reg = <0x67>;
+		compatible = "cypress,cyapa";
+		interrupts = <2 0>;
+		interrupt-parent = <&gpx1>;
+		wakeup-source;
+	};
+};
+
 &pinctrl_0 {
 	max77686_irq: max77686-irq {
 		samsung,pins = "gpx3-2";
-- 
1.9.3

