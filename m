Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbaKTXy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:54:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35141 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbaKTXy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:54:56 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 2/2] gpio: Document GPIO hogging mechanism
Date: Thu, 20 Nov 2014 17:54:44 -0600
Message-ID: <1416527684-19017-3-git-send-email-bparrot@ti.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1416527684-19017-1-git-send-email-bparrot@ti.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPIO hogging documentation to gpio.txt

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
Changes since v1:
 * Split the devicetree bindings documentation in its own patch.

 Documentation/devicetree/bindings/gpio/gpio.txt | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 3fb8f53..82755e2 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -103,6 +103,24 @@ Every GPIO controller node must contain both an empty "gpio-controller"
 property, and a #gpio-cells integer property, which indicates the number of
 cells in a gpio-specifier.
 
+The GPIO chip may contain GPIO hog definitions. GPIO hogging is a mechanism
+providing automatic GPIO request and configuration as part of the
+gpio-controller's driver probe function.
+
+Each GPIO hog definition is represented as a child node of the GPIO controller.
+Required properties:
+- gpio-hog: a property specifying that this child node represent a gpio-hog.
+- gpios: store the gpio information (id, flags, ...). Shall contain the
+  number of cells specified in its parent node (GPIO controller node).
+- input: a property specifying to set the GPIO direction as input.
+- output-high: a property specifying to set the GPIO direction to output with
+  the value high.
+- output-low: a property specifying to set the GPIO direction to output with
+  the value low.
+
+Optional properties:
+- line-name: the GPIO label name. If not present the node name is used.
+
 Example of two SOC GPIO banks defined as gpio-controller nodes:
 
 	qe_pio_a: gpio-controller@1400 {
@@ -110,6 +128,13 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
 		reg = <0x1400 0x18>;
 		gpio-controller;
 		#gpio-cells = <2>;
+
+		line_b: line_b {
+			gpio-hog;
+			gpios = <6 0>;
+			output-low;
+			line-name = "foo-bar-gpio";
+		};
 	};
 
 	qe_pio_e: gpio-controller@1460 {
-- 
1.8.5.1

