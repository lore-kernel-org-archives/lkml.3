Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaLLWIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:08:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48808 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbaLLWIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:08:09 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v4 2/2] gpio: Document GPIO hogging mechanism
Date: Fri, 12 Dec 2014 16:07:31 -0600
Message-ID: <1418422051-9471-3-git-send-email-bparrot@ti.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1418422051-9471-1-git-send-email-bparrot@ti.com>
References: <1418422051-9471-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPIO hogging documentation to gpio.txt

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
Changes since v3:
 * Renamed the "direction" DT properties to "state".

 Documentation/devicetree/bindings/gpio/gpio.txt | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 3fb8f53..a38da91 100644
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
+- state:     A property specifying the direction/value needed. This property
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
+			state = "output-low";
+			line-name = "foo-bar-gpio";
+		};
 	};
 
 	qe_pio_e: gpio-controller@1460 {
-- 
1.8.5.1

