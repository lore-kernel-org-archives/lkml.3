Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3LOX2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:28:51 -0500
Received: from ring0.de ([91.143.88.219]:40105 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab3LOX2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:28:45 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv4 07/11] Documentation: DT: nokia-cmt binding documentation
Date: Mon, 16 Dec 2013 00:28:00 +0100
Message-Id: <1387150085-23173-8-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387150085-23173-1-git-send-email-sre@debian.org>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create device tree binding documentation for
Nokia cellular modem GPIO handling.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/misc/nokia-cmt.txt         | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/nokia-cmt.txt

diff --git a/Documentation/devicetree/bindings/misc/nokia-cmt.txt b/Documentation/devicetree/bindings/misc/nokia-cmt.txt
new file mode 100644
index 0000000..1c87793
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/nokia-cmt.txt
@@ -0,0 +1,28 @@
+Nokia Cellular Modem (CMT) bindings
+
+Required properties:
+- compatible:		Should include "nokia,cmt".
+- interrupts:		Interrupt specifier for the cmt reset irq.
+- gpio-names:		Contains the values "cmt_apeslpx", "cmt_rst_rq",
+			"cmt_en", "cmt_rst" and "cmt_bsi".
+- gpios:		Contains gpio information for each entry in gpio-names.
+
+Example for Nokia N900:
+
+cmt: nokia-cmt {
+	compatible = "nokia,cmt";
+
+	interrupt-parent = <&gpio3>;
+	interrupts = <8 IRQ_TYPE_EDGE_FALLING>; /* gpio line 72 */
+
+	gpios = <&gpio3  6 GPIO_ACTIVE_HIGH>, /* 70 */
+		<&gpio3  9 GPIO_ACTIVE_HIGH>, /* 73 */
+		<&gpio3 10 GPIO_ACTIVE_HIGH>, /* 74 */
+		<&gpio3 11 GPIO_ACTIVE_HIGH>, /* 75 */
+		<&gpio5 29 GPIO_ACTIVE_HIGH>; /* 157 */
+	gpio-names = "cmt_apeslpx",
+		     "cmt_rst_rq",
+		     "cmt_en",
+		     "cmt_rst",
+		     "cmt_bsi";
+};
-- 
1.8.5.1

