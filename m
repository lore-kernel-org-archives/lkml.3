Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbbANI3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:29:45 -0500
Received: from filter1.ibarracuda.nl ([83.247.7.10]:42395 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbbANI3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:29:42 -0500
X-ASG-Debug-ID: 1421223559-0759e7543ba842f0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?q?Ren=C3=A9=20Moll?= <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH RESEND 13/13] power: reset: ltc2952: document optional trigger behavior
Date: Wed, 14 Jan 2015 09:15:46 +0100
X-ASG-Orig-Subj: [PATCH RESEND 13/13] power: reset: ltc2952: document optional trigger behavior
Message-ID: <1421223346-27410-14-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421223346-27410-1-git-send-email-frans.klaver@xsens.com>
References: <1421223346-27410-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.149]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1421223559
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: https://filter1.ibarracuda.nl:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.14271
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the fact that the trigger signal is now optional, and describe
the behavior when this is used.

While at it, fix a typo, and paraphrase a sentence to be less platform
specific.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 .../devicetree/bindings/power/reset/ltc2952-poweroff.txt    | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt b/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
index 0c94c63..cd2d7f5 100644
--- a/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
+++ b/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
@@ -1,20 +1,23 @@
 Binding for the LTC2952 PowerPath controller
 
 This chip is used to externally trigger a system shut down. Once the trigger has
-been sent, the chips' watchdog has to be reset to gracefully shut down.
-If the Linux systems decides to shut down it powers off the platform via the
-kill signal.
+been sent, the chip's watchdog has to be reset to gracefully shut down.
+A full powerdown can be triggered via the kill signal.
 
 Required properties:
 
 - compatible:		Must contain: "lltc,ltc2952"
-- trigger-gpios:	phandle + gpio-specifier for the GPIO connected to the
-			chip's trigger line
 - watchdog-gpios:	phandle + gpio-specifier for the GPIO connected to the
 			chip's watchdog line
 - kill-gpios:		phandle + gpio-specifier for the GPIO connected to the
 			chip's kill line
 
+Optional properties:
+- trigger-gpios:	phandle + gpio-specifier for the GPIO connected to the
+			chip's trigger line. If this property is not set, the
+			trigger function is ignored and the chip is kept alive
+			until an explicit kill signal is received
+
 Example:
 
 ltc2952 {
-- 
2.1.0

