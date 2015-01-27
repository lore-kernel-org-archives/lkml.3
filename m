Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbbA0MmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:42:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504AbbA0MSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 048/126] ARM: dts: Enable PWM node by default for s3c64xx
Date: Tue, 27 Jan 2015 12:15:53 +0000
Message-Id: <1422361031-19364-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Figa <tomasz.figa@gmail.com>

commit 5e794de514f56de1e78e979ca09c56a91aa2e9f1 upstream.

The PWM block is required for system clock source so it must be always
enabled. This patch fixes boot issues on SMDK6410 which did not have
the node enabled explicitly for other purposes.

Fixes: eeb93d02 ("clocksource: of: Respect device tree node status")

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/s3c6410-mini6410.dts | 4 ----
 arch/arm/boot/dts/s3c64xx.dtsi         | 1 -
 2 files changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/s3c6410-mini6410.dts b/arch/arm/boot/dts/s3c6410-mini6410.dts
index 57e00f9bce99..a25debb50401 100644
--- a/arch/arm/boot/dts/s3c6410-mini6410.dts
+++ b/arch/arm/boot/dts/s3c6410-mini6410.dts
@@ -198,10 +198,6 @@
 	status = "okay";
 };
 
-&pwm {
-	status = "okay";
-};
-
 &pinctrl0 {
 	gpio_leds: gpio-leds {
 		samsung,pins = "gpk-4", "gpk-5", "gpk-6", "gpk-7";
diff --git a/arch/arm/boot/dts/s3c64xx.dtsi b/arch/arm/boot/dts/s3c64xx.dtsi
index 4e3be4d3493d..4f1eff3420f6 100644
--- a/arch/arm/boot/dts/s3c64xx.dtsi
+++ b/arch/arm/boot/dts/s3c64xx.dtsi
@@ -168,7 +168,6 @@
 			clocks = <&clocks PCLK_PWM>;
 			samsung,pwm-outputs = <0>, <1>;
 			#pwm-cells = <3>;
-			status = "disabled";
 		};
 
 		pinctrl0: pinctrl@7f008000 {
-- 
2.1.4

