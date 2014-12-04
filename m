Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaLDVCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:02:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46355 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbaLDVCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:02:40 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v3 2/2] gpio: Document GPIO hogging mechanism
Date: Thu, 4 Dec 2014 15:02:02 -0600
Message-ID: <1417726922-10376-3-git-send-email-bparrot@ti.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1417726922-10376-1-git-send-email-bparrot@ti.com>
References: <1417726922-10376-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPIO hogging documentation to gpio.txt

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
Changes since v2:
 * Updated to the latest hog syntax.

Changes since v1:
 * Split the devicetree bindings documentation in its own patch.

 Documentation/devicetree/bindings/gpio/gpio.txt | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 3fb8f53..6d88133 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -103,6 +103,22 @@ Every GPIO controller node must contain both an empty "gpio-controller"
 property, and a #gpio-cells integer property, which indicates the number of
 cells in a gpio-specifier.
 
+The GPIO chip may contain GPIO hog definitions. GPIO hogging is a mechanism
+providing automatic GPIO request and configuration as part of the
+gpio-controller's driver probe function.
+
+Each GPIO hog definition is represented as a child node of the GPIO controller.
+Required properties:
+- gpio-hog:  A property specifying that this child node represent a gpio-hog.
+- gpios:     Store the gpio information (id, flags, ...). Shall contain the
+	     number of cells specified in its parent node (GPIO controller
+	     node).
+- direction: A property specifying the direction/value needed. This property
+	     can take the folowing values: input, output-high, output-low.
+
+Optional properties:
+- line-name: The GPIO label name. If not present the node name is used.
+
 Example of two SOC GPIO banks defined as gpio-controller nodes:
 
 	qe_pio_a: gpio-controller@1400 {
@@ -110,6 +126,13 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
 		reg = <0x1400 0x18>;
 		gpio-controller;
 		#gpio-cells = <2>;
+
+		line_b {
+			gpio-hog;
+			gpios = <6 0>;
+			direction = "output-low";
+			line-name = "foo-bar-gpio";
+		};
 	};
 
 	qe_pio_e: gpio-controller@1460 {
-- 
1.8.5.1

