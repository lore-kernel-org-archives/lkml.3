Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3H3EaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:30:07 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35665 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab3H3EaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:30:05 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 6/6] extcon-gpio: Describe possible properties to support multi-type cables
Date: Thu, 29 Aug 2013 21:29:38 -0700
Message-Id: <1377836978-24082-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is purely a possible description and an RFC; there is no code (yet).

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 .../devicetree/bindings/extcon/extcon-gpio         |   26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio b/Documentation/devicetree/bindings/extcon/extcon-gpio
index 091ddc6..5836ac2 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-gpio
+++ b/Documentation/devicetree/bindings/extcon/extcon-gpio
@@ -21,3 +21,29 @@ Example node:
 		state-on = "connected";
 		state-on = "disconnected";
 	};
+
+---
+TBD: Add support for multiple connectors
+
+An example node with multiple connectors might look as follows.
+
+	some-connector {
+		#size-cells = <1>;
+		compatible = "gpio-connector";
+		presence-detect-gpios = <&gpio1 7 1>;
+		id-gpios = <&gpio1 8 0>;
+		debounce-interval = <1>;
+		state-on = "connected";
+		state-on = "disconnected";
+
+		USB {
+			reg = <0>;
+		};
+		USB-Host {
+			reg = <1>;
+		};
+	};
+
+This describes a cable with a (low-active) presence detect pin and an ID pin.
+If the value returned by the ID pin is 0, the connected cable type is "USB".
+If the value is 1, the connected cable type is "USB-Host".
-- 
1.7.9.7

