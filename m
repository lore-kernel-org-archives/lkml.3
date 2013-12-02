Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3LBUUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:20:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3LBTRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.12 038/212] ARM: dts: Add max77686 RTC interrupt to cros5250-common
Date: Mon,  2 Dec 2013 11:13:49 -0800
Message-Id: <20131202191252.700742871@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Anderson <dianders@chromium.org>

commit c61248afa8190ae3f47ee67f46e3c9b584a73d31 upstream.

Without the interrupt you'll get problems if you enable
CONFIG_RTC_DRV_MAX77686.  Setup the interrupt properly in the device
tree.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/cros5250-common.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/arm/boot/dts/cros5250-common.dtsi
+++ b/arch/arm/boot/dts/cros5250-common.dtsi
@@ -27,6 +27,13 @@
 		i2c2_bus: i2c2-bus {
 			samsung,pin-pud = <0>;
 		};
+
+		max77686_irq: max77686-irq {
+			samsung,pins = "gpx3-2";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	i2c@12C60000 {
@@ -35,6 +42,11 @@
 
 		max77686@09 {
 			compatible = "maxim,max77686";
+			interrupt-parent = <&gpx3>;
+			interrupts = <2 0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&max77686_irq>;
+			wakeup-source;
 			reg = <0x09>;
 
 			voltage-regulators {


