Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaHAE5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 00:57:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbaHAE45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 00:56:57 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 05/10] ARM: dts: Move dp_hpd from exynos5250 into smdk5250 and snow
Date: Fri,  1 Aug 2014 06:54:52 +0200
Message-Id: <1406868897-26874-6-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406868897-26874-1-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spring uses a different GPIO, so this is not a generic SoC piece.

Suggested-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v5: New (Tomasz Figa)
 Frees dp_hpd for Spring.

 arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 7 -------
 arch/arm/boot/dts/exynos5250-smdk5250.dts | 9 +++++++++
 arch/arm/boot/dts/exynos5250-snow.dts     | 7 +++++++
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index 886cfca044ac..ed0e5230514b 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -581,13 +581,6 @@
 			samsung,pin-pud = <0>;
 			samsung,pin-drv = <0>;
 		};
-
-		dp_hpd: dp_hpd {
-			samsung,pins = "gpx0-7";
-			samsung,pin-function = <3>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
 	};
 
 	pinctrl@13400000 {
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index aaa055ac0fe3..5d30fe1dcda4 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -414,3 +414,12 @@
 		};
 	};
 };
+
+&pinctrl_0 {
+	dp_hpd: dp_hpd {
+		samsung,pins = "gpx0-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index c4b0c73c736d..a9a2f2743794 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -547,6 +547,13 @@
 };
 
 &pinctrl_0 {
+	dp_hpd: dp_hpd {
+		samsung,pins = "gpx0-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	ec_irq: ec-irq {
 		samsung,pins = "gpx1-6";
 		samsung,pin-function = <0>;
-- 
1.9.3

