Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaATLgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:36:24 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:28964
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbaATLgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:36:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h1155h)
From: Robin Gong <b38343@freescale.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <cooloney@gmail.com>, <rpurdie@rpsys.net>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v1 2/2] update binding doc of leds-gpio.txt
Date: Mon, 20 Jan 2014 19:41:27 +0800
Message-ID: <1390218087-14597-2-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1390218087-14597-1-git-send-email-b38343@freescale.com>
References: <1390218087-14597-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the binding doc for new property: "retain-state-suspended"

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 .../devicetree/bindings/leds/leds-gpio.txt         |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-gpio.txt b/Documentation/devicetree/bindings/leds/leds-gpio.txt
index df1b308..f77148f 100644
--- a/Documentation/devicetree/bindings/leds/leds-gpio.txt
+++ b/Documentation/devicetree/bindings/leds/leds-gpio.txt
@@ -21,6 +21,8 @@ LED sub-node properties:
   on).  The "keep" setting will keep the LED at whatever its current
   state is, without producing a glitch.  The default is off if this
   property is not present.
+- retain-state-suspended: (optional) The suspend state can be retained.Such
+  as charge-led gpio.
 
 Examples:
 
@@ -50,3 +52,13 @@ run-control {
 		default-state = "on";
 	};
 };
+
+leds {
+	compatible = "gpio-leds";
+
+	charger-led {
+		gpios = <&gpio1 2 0>;
+		linux,default-trigger = "max8903-charger-charging";
+		retain-state-suspended;
+	};
+};
-- 
1.7.5.4


