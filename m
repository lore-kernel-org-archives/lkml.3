Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaKXNCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:02:35 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:61123 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaKXNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:02:33 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Alban Bedel <alban.bedel@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 1/4] devicetree: add a binding for a regulator that constrains its supply
Date: Mon, 24 Nov 2014 14:02:00 +0100
Message-Id: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.1.3
X-Provags-ID: V02:K0:S7i/xyfr18kNf3Mu6FAoN4OXepY2BEH7vaiFVQ1S/TJ
 ulW4U4xksju4P+tJ3tKUlGMwXpEKq+QCSko9BgEpPMnSZVKMMe
 NAB/DjuXRUWBIc13+fnSIbYs79dnb20gWya+xF8yFvx9/U7/cs
 ZJQEOBgUovuHUY5SGTTKj/TGXmHXVLlzfDRIzHXP70Oi0hEKVL
 hjk9Ltauq75Q2Qp6nx4UrqchwOGwOveqIEehjqpDNCPey6dyQy
 tsz5831NvJ90GUcIQ0m9J/wS9THJX1nMwBDNyYDsum2Qfqu8M+
 WorK9aqy3dzUeB1W2tqYf/63/IRDNn6Y/IFMYRShhEuP9+U83t
 LhUnBtbgN6TEEe9t3S12D7//RLXD7GWaOR6aYGrzfAOstmepKM
 2xNHkpWTgo8qPvRgq0n1N38kXLBKL/fT4ayxn4Heo7FHt23h8/
 Uwe42yXYQ4ZSCgnK/Zrx/y6mEHg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 .../bindings/regulator/constrained-supply.txt      | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/constrained-supply.txt

diff --git a/Documentation/devicetree/bindings/regulator/constrained-supply.txt b/Documentation/devicetree/bindings/regulator/constrained-supply.txt
new file mode 100644
index 0000000..3c85430
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/constrained-supply.txt
@@ -0,0 +1,29 @@
+Constrained Supply Regulator
+
+This binding allow creating a virtual regulator that constrain its
+supply to provides the requested voltage. This is to allow using
+simple drivers that don't explicitly request a voltage on boards
+that have adjustable hardware regulators.
+
+Required properties:
+- compatible : Must be "regulator-constrained-supply".
+- vin-supply : phandle to the parent supply/regulator node
+
+Optional properties:
+- any property defined in regulator.txt
+
+Example:
+
+  /* Adjustable regulator for extension boards */
+  vdd_ext: regulator@0 {
+  	regulator-min-microvolt = <1000000>;
+  	regulator-max-microvolt = <10000000>;
+  };
+
+  /* An extension board that need 3.3V */
+  vdd_ext_board1: regulator@1 {
+	compatible = "regulator-constrained-supply";
+  	regulator-min-microvolt = <3300000>;
+  	regulator-max-microvolt = <3300000>;
+	vin-supply = <&vdd_ext>;
+  };
-- 
2.1.3

