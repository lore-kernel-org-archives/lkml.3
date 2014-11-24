Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKXNDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:03:11 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:57667 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaKXNCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:02:34 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Alban Bedel <alban.bedel@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 3/4] devicetree: add a binding for a group of regulator
Date: Mon, 24 Nov 2014 14:02:02 +0100
Message-Id: <1416834123-23139-3-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
References: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:gYFXx/ugjoqLJwJQUDBI8vH+XP0JPTTZ872FywIiGPE
 IVuide8gGYs1fG4ohCOK2MXVML1fCKdNO+qXqi6nTs0IA58XhN
 +d//GvZ8CBNE5xUax61/+1FRfpz8AdWRF7vICZ5WY8afCesnWF
 upGz/k+uDpeO4M5hlykxvY51iwP02nLLIxW8iBd/XWZZck10UO
 sbjAjglyuTIE4P7tP5hMwkr/ymqQd33AD6pQPjerEQoWzD0VPI
 CMZ9RaVv4issur0JjNzwpsAZnGMu9a+CruJN74yXxU9Ckk9EE3
 5X9xv3YURj8+/CgnfozABby5/F3Y5Y7z7VVRXrcv6GhDMryyFC
 FxqwJ5SYMjMdHn9dYkynhiZ02W1wDcILRmZz4EpvX5feb7d3MC
 peIFrxeoO2KlTHIqWnKpT2J3x7NHa8Xtdl1hzS2aiA8N4O4oNO
 SsSg2LqhxQobca4wxnJZYvRkX4w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 .../devicetree/bindings/regulator/group.txt        | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/group.txt

diff --git a/Documentation/devicetree/bindings/regulator/group.txt b/Documentation/devicetree/bindings/regulator/group.txt
new file mode 100644
index 0000000..5f811cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/group.txt
@@ -0,0 +1,26 @@
+Regulator Group
+
+This binding allow creating a group of regulators for use with simple
+drivers that only expect a single power supply. Additionally it is
+possible to enforce the enable ordering to create simple power up
+sequences.
+
+Required properties:
+- compatible : Must be "regulator-group".
+- regulator-supplies : List of the supplies names.
+- <name>-supply : One entry for each supply defined in regulator-supplies.
+
+Optional properties:
+- ordered-supplies : set if the supplies should be enabled in order,
+   otherwise they are all enable or disabled in parallel.
+- any property defined in regulator.txt
+
+Example:
+
+  regulator {
+	compatible = "regulator-group";
+	regulator-supplies = "vcc_a", "vcc_b";
+	vcc_a-supply = <&vcc_a>;
+	vcc_b-supply = <&vcc_b>;
+	ordered-supplies;
+  };
-- 
2.1.3

