Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbbANHaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:30:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbANHah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:30:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 3.18 120/150] ARM: dts: Enable PWM node by default for s3c64xx
Date: Tue, 13 Jan 2015 23:23:11 -0800
Message-Id: <20150114072101.287372415@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Figa <tomasz.figa@gmail.com>

commit 5e794de514f56de1e78e979ca09c56a91aa2e9f1 upstream.

The PWM block is required for system clock source so it must be always
enabled. This patch fixes boot issues on SMDK6410 which did not have
the node enabled explicitly for other purposes.

Fixes: eeb93d02 ("clocksource: of: Respect device tree node status")

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/s3c6410-mini6410.dts |    4 ----
 arch/arm/boot/dts/s3c64xx.dtsi         |    1 -
 2 files changed, 5 deletions(-)

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
--- a/arch/arm/boot/dts/s3c64xx.dtsi
+++ b/arch/arm/boot/dts/s3c64xx.dtsi
@@ -172,7 +172,6 @@
 			clocks = <&clocks PCLK_PWM>;
 			samsung,pwm-outputs = <0>, <1>;
 			#pwm-cells = <3>;
-			status = "disabled";
 		};
 
 		pinctrl0: pinctrl@7f008000 {


