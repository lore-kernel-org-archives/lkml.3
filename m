Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaIKKkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:40:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42250 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaIKKks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:40:48 -0400
Date: Thu, 11 Sep 2014 12:40:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, matti.vaittinen@nsn.com,
        robh+dt@kernel.org, akpm@linux-foundation.org,
        ijc+devicetree@hellion.org.uk, a.zummo@towertech.it,
        linux@roeck-us.net
Cc: jason@lakedaemon.net
Subject: rtc: bq32000: add trickle charger device tree binding
Message-ID: <20140911104045.GA16478@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BQ32000 have "trickle chargers".  Introduce a device tree
binding for specifying the trickle charger configuration for that.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/Documentation/devicetree/bindings/i2c/ti,bq32k.txt b/Documentation/devicetree/bindings/i2c/ti,bq32k.txt
new file mode 100644
index 0000000..e204906
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/ti,bq32k.txt
@@ -0,0 +1,18 @@
+* TI BQ32000                I2C Serial Real-Time Clock
+
+Required properties:
+- compatible: Should contain "ti,bq32000".
+- reg: I2C address for chip
+
+Optional properties:
+- trickle-resistor-ohms : Selected resistor for trickle charger
+       Values usable are 1120 and 20180
+       Should be given if trickle charger should be enabled
+- trickle-diode-disable : Do not use internal trickle charger diode
+       Should be given if internal trickle charger diode should be disabled
+Example:
+       bq32000: rtc@68 {
+               compatible = "ti,bq32000";
+               trickle-resistor-ohms = <1120>;
+               reg = <0x68>;
+       };

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
