Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3LBVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:16:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3LBTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.10 030/173] ARM: bcm2835: add missing #xxx-cells to I2C nodes
Date: Mon,  2 Dec 2013 11:10:13 -0800
Message-Id: <20131202191146.213662678@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@wwwdotorg.org>

commit a31ab44ef5d07c6707df4a9ad2c8affd2d62ff4b upstream.

The I2C controller node needs #address-cells and #size-cells properties,
but these are currently missing. Add them. This allows child nodes to be
parsed correctly.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/bcm2835.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

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
 


