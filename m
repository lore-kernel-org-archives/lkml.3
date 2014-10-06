Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaJFImF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:42:05 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:46920 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaJFIlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:41:46 -0400
X-ASG-Debug-ID: 1412584904-0759e7116045290002-xx1T2L
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
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 2/2] power: reset: document LTC2952 poweroff support
Date: Mon, 6 Oct 2014 10:40:36 +0200
X-ASG-Orig-Subj: [PATCH v3 2/2] power: reset: document LTC2952 poweroff support
Message-ID: <1412584836-27677-3-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412584836-27677-1-git-send-email-frans.klaver@xsens.com>
References: <1412584836-27677-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1412584904
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10254
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
 .../bindings/power/reset/ltc2952-poweroff.txt      | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt

diff --git a/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt b/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
new file mode 100644
index 0000000..3d15814
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
@@ -0,0 +1,31 @@
+Binding for the LTC2952 PowerPath controller
+
+This chip is used to externally trigger a system shut down. Once the trigger has
+been sent, the chips' watchdog has to be reset to gracefully shut down.
+If the Linux systems decides to shut down it powers off the platform via the
+kill signal.
+
+Required properties:
+
+- compatible:		Must contain: "lltc,ltc2952"
+- watchdog-gpios:	phandle + gpio-specifier for the GPIO connected to the
+			chip's watchdog line
+- kill-gpios:		phandle + gpio-specifier for the GPIO connected to the
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
+	kill-gpios = <&gpio0 2 GPIO_ACTIVE_LOW>;
+};
-- 
2.1.0

