Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbbAUVfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:35:00 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:39443 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbbAUVeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:34:18 -0500
From: Olliver Schinagl <o.schinagl@ultimaker.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Alexander Shiyan <shc_work@mail.ru>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: [PATCH v2 3/4] leds: Let the binding document example for leds-gpio follow the gpio bindings
Date: Wed, 21 Jan 2015 22:33:47 +0100
Message-Id: <1421876028-22799-4-git-send-email-o.schinagl@ultimaker.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com>
References: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

In the gpio bindings documents it is requested to use the marco's in
include/dt-bindings/gpio/gpio.h whenever possible. The gpios in the led
drivers don't seem to form an exception, so update the example in the
document bindings.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/devicetree/bindings/leds/leds-gpio.txt | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-gpio.txt b/Documentation/devicetree/bindings/leds/leds-gpio.txt
index f77148f..fea1ebf 100644
--- a/Documentation/devicetree/bindings/leds/leds-gpio.txt
+++ b/Documentation/devicetree/bindings/leds/leds-gpio.txt
@@ -26,16 +26,18 @@ LED sub-node properties:
 
 Examples:
 
+#include <dt-bindings/gpio/gpio.h>
+
 leds {
 	compatible = "gpio-leds";
 	hdd {
 		label = "IDE Activity";
-		gpios = <&mcu_pio 0 1>; /* Active low */
+		gpios = <&mcu_pio 0 GPIO_ACTIVE_LOW>;
 		linux,default-trigger = "ide-disk";
 	};
 
 	fault {
-		gpios = <&mcu_pio 1 0>;
+		gpios = <&mcu_pio 1 GPIO_ACTIVE_HIGH>;
 		/* Keep LED on if BIOS detected hardware fault */
 		default-state = "keep";
 	};
@@ -44,11 +46,11 @@ leds {
 run-control {
 	compatible = "gpio-leds";
 	red {
-		gpios = <&mpc8572 6 0>;
+		gpios = <&mpc8572 6 GPIO_ACTIVE_HIGH>;
 		default-state = "off";
 	};
 	green {
-		gpios = <&mpc8572 7 0>;
+		gpios = <&mpc8572 7 GPIO_ACTIVE_HIGH>;
 		default-state = "on";
 	};
 };
@@ -57,7 +59,7 @@ leds {
 	compatible = "gpio-leds";
 
 	charger-led {
-		gpios = <&gpio1 2 0>;
+		gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
 		linux,default-trigger = "max8903-charger-charging";
 		retain-state-suspended;
 	};
-- 
2.1.4

