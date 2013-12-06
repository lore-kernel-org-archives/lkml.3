Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3LFOLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:11:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43772 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161298Ab3LFNAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@wwwdotorg.org>, Olof Johansson <olof@lixom.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 054/272] ARM: bcm2835: add missing #xxx-cells to I2C nodes
Date: Fri,  6 Dec 2013 12:55:43 +0000
Message-Id: <1386334761-25517-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@wwwdotorg.org>

commit a31ab44ef5d07c6707df4a9ad2c8affd2d62ff4b upstream.

The I2C controller node needs #address-cells and #size-cells properties,
but these are currently missing. Add them. This allows child nodes to be
parsed correctly.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/bcm2835.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 1e12aef..aa537ed 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -85,6 +85,8 @@
 			reg = <0x7e205000 0x1000>;
 			interrupts = <2 21>;
 			clocks = <&clk_i2c>;
+			#address-cells = <1>;
+			#size-cells = <0>;
 			status = "disabled";
 		};
 
@@ -93,6 +95,8 @@
 			reg = <0x7e804000 0x1000>;
 			interrupts = <2 21>;
 			clocks = <&clk_i2c>;
+			#address-cells = <1>;
+			#size-cells = <0>;
 			status = "disabled";
 		};
 
-- 
1.8.3.2

