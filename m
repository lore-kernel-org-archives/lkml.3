Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaJMIFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:05:54 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:60916 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaJMIFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:05:34 -0400
X-ASG-Debug-ID: 1413187531-0759e7482868d8a0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: =?UTF-8?q?Ren=C3=A9=20Moll?= <linux@r-moll.nl>,
        Tjerk Hofmeijer <tjerk.hofmeijer@xsens.com>,
        Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v5 2/2] power: reset: document LTC2952 poweroff support
Date: Mon, 13 Oct 2014 10:05:13 +0200
X-ASG-Orig-Subj: [PATCH v5 2/2] power: reset: document LTC2952 poweroff support
Message-ID: <1413187513-11178-3-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413187513-11178-1-git-send-email-frans.klaver@xsens.com>
References: <1413187513-11178-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413187531
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10508
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: René Moll <linux@r-moll.nl>

Signed-off-by: René Moll <linux@r-moll.nl>
Signed-off-by: Tjerk Hofmeijer <tjerk.hofmeijer@xsens.com>
Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 .../bindings/power/reset/ltc2952-poweroff.txt      | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt

diff --git a/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt b/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
new file mode 100644
index 0000000..80e58cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
@@ -0,0 +1,30 @@
+Binding for the LTC2952 PowerPath controller
+
+This chip is used to externally trigger a system shut down. Once the trigger
+has been sent, the chip's watchdog has to be reset to gracefully shut down.
+A full power down can be triggered via the poweroff signal.
+
+Required properties:
+
+- compatible:		Should contain: "lltc,ltc2952"
+- watchdog-gpios:	phandle + gpio-specifier for the GPIO connected to the
+			chip's watchdog line
+- poweroff-gpios:	phandle + gpio-specifier for the GPIO connected to the
+			chip's kill line
+
+Optional properties:
+
+- trigger-gpios:	phandle + gpio-specifier for the GPIO connected to the
+			chip's trigger line. If this property is not set, the
+			trigger function is ignored and the chip is kept alive
+			until an explicit kill signal is received
+
+Example:
+
+ltc2952 {
+	compatible = "lltc,ltc2952";
+
+	trigger-gpios = <&gpio0 1 GPIO_ACTIVE_LOW>;
+	watchdog-gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
+	poweroff-gpios = <&gpio0 2 GPIO_ACTIVE_LOW>;
+};
-- 
2.1.0

