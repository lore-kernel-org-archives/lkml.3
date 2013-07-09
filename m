Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3GIM3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:29:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61341 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3GIM3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:29:16 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v3 2/7] Documentation: DT: add sam9x5ek-wm8731 machine driver
Date: Tue,  9 Jul 2013 14:28:44 +0200
Message-Id: <1373372929-17800-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the sound DT binding for sam9x5ek-wm8731 machine driver

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 .../bindings/sound/atmel-sam9x5-wm8731-audio.txt   |   30 ++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt

diff --git a/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
new file mode 100644
index 0000000..fd03dfd
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
@@ -0,0 +1,30 @@
+* Atmel at91sam9x5ek wm8731 audio complex
+
+Required properties:
+  - compatible: "atmel,at91sam9x5ek-wm8731-audio"
+  - atmel,model: The user-visible name of this sound complex.
+  - atmel,audio-routing: A list of the connections between audio components.
+  - atmel,ssc-controller: The phandle of the SSC controller
+  - atmel,audio-codec: The phandle of the WM8731 audio codec
+  - atmel,format: DAI format. Must be "i2s"
+  - atmel,bitclock-master:  DAI clock master
+  - atmel,frame-master: DAI frame master
+
+Example:
+sound {
+	compatible = "atmel,sam9x5-wm8731-audio";
+
+	atmel,model = "wm8731 @ AT91SAM9X5EK";
+
+	atmel,audio-routing =
+		"Headphone Jack", "RHPOUT",
+		"Headphone Jack", "LHPOUT",
+		"LLINEIN", "Line In Jack",
+		"RLINEIN", "Line In Jack";
+
+	atmel,ssc-controller = <&ssc0>;
+	atmel,audio-codec = <&wm8731>;
+	atmel,format = "i2s";
+	atmel,bitclock-master;
+	atmel,frame-master;
+};
-- 
1.7.10.4

