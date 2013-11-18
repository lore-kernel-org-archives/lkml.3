Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3KRRV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:21:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36037 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3KRRVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:21:13 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, Sekhar Nori <nsekhar@ti.com>,
        <linux-watchdog@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Strashko Grygorii <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH 4/6] watchdog: davinci: add "timeout-sec" property
Date: Mon, 18 Nov 2013 19:18:57 +0200
Message-ID: <1384795139-19466-5-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384795139-19466-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1384795139-19466-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Davinci WDT has been switched to use WDT core, it became able
to support timeout-sec property, so add it to it's binding description.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 .../devicetree/bindings/watchdog/davinci-wdt.txt   |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
index 75558cc..e450134 100644
--- a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
@@ -4,9 +4,13 @@ Required properties:
 - compatible : Should be "ti,davinci-wdt"
 - reg : Should contain WDT registers location and length
 
+Optional properties:
+- timeout-sec : Contains the watchdog timeout in seconds
+
 Examples:
 
 wdt: wdt@2320000 {
 	compatible = "ti,davinci-wdt";
 	reg = <0x02320000 0x80>;
+	timeout-sec = <30>;
 };
-- 
1.7.9.5

