Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3ILSBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:01:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3ILR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [ 46/46] ARM: at91: dt: sam9260: add i2c gpio pinctrl
Date: Thu, 12 Sep 2013 10:58:57 -0700
Message-Id: <20130912175725.946900261@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit f89ae61bd74ae195c464bdd97a134e30908884d5 upstream.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91sam9260.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -340,6 +340,14 @@
 					};
 				};
 
+				i2c_gpio0 {
+					pinctrl_i2c_gpio0: i2c_gpio0-0 {
+						atmel,pins =
+							<0 23 0x0 0x3   /* PA23 gpio I2C_SDA pin */
+							 0 24 0x0 0x3>; /* PA24 gpio I2C_SCL pin */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
@@ -592,6 +600,8 @@
 		i2c-gpio,delay-us = <2>;	/* ~100 kHz */
 		#address-cells = <1>;
 		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_i2c_gpio0>;
 		status = "disabled";
 	};
 };


