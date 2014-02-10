Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBJKEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:04:36 -0500
Received: from sauhun.de ([89.238.76.85]:38529 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaBJKE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:28 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/17] Documentation: i2c: describe devicetree method for instantiating devices
Date: Mon, 10 Feb 2014 11:03:55 +0100
Message-Id: <1392026654-5343-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---

 Documentation/i2c/instantiating-devices | 34 +++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/Documentation/i2c/instantiating-devices b/Documentation/i2c/instantiating-devices
index c70e7a7..6df095a 100644
--- a/Documentation/i2c/instantiating-devices
+++ b/Documentation/i2c/instantiating-devices
@@ -8,8 +8,8 @@ reason, the kernel code must instantiate I2C devices explicitly. There are
 several ways to achieve this, depending on the context and requirements.
 
 
-Method 1: Declare the I2C devices by bus number
------------------------------------------------
+Method 1a: Declare the I2C devices by bus number
+------------------------------------------------
 
 This method is appropriate when the I2C bus is a system bus as is the case
 for many embedded systems. On such systems, each I2C bus has a number
@@ -51,6 +51,36 @@ The devices will be automatically unbound and destroyed when the I2C bus
 they sit on goes away (if ever.)
 
 
+Method 1b: Declare the I2C devices via devicetree
+-------------------------------------------------
+
+This method has the same implications as method 1a. The declaration of I2C
+devices is here done via devicetree as subnodes of the master controller.
+
+Example:
+
+	i2c1: i2c@400a0000 {
+		/* ... master properties skipped ... */
+		clock-frequency = <100000>;
+
+		flash@50 {
+			compatible = "atmel,24c256";
+			reg = <0x50>;
+		};
+
+		pca9532: gpio@60 {
+			compatible = "nxp,pca9532";
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <0x60>;
+		};
+	};
+
+Here, two devices are attached to the bus using a speed of 100kHz. For
+additional properties which might be needed to set up the device, please refer
+to its devicetree documentation in Documentation/devicetree/bindings/.
+
+
 Method 2: Instantiate the devices explicitly
 --------------------------------------------
 
-- 
1.8.5.1

