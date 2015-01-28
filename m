Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbbA1Ul2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:41:28 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62005 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbbA1UlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:41:23 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 2/2] mmc: pwrseq: Update document with multiple gpios support
Date: Wed, 28 Jan 2015 13:17:08 +0000
Message-Id: <1422451028-9417-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422450981-9328-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1422450981-9328-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the text and examples the mmc pwrseq document with multiple
gpios support. Typical example is WLAN and BT chips on SDIO bus.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
index da333d9..1a86efa 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
@@ -8,13 +8,14 @@ Required properties:
 - compatible : contains "mmc-pwrseq-simple".
 
 Optional properties:
-- reset-gpios : contains a GPIO specifier. The reset GPIO is asserted at
-	initialization and prior we start the power up procedure of the card. It
+- reset-gpios : contains list of GPIO specifiers. The reset GPIOs are asserted at
+	initialization and prior we start the power up procedure of the card. They
 	will be de-asserted right after the power has been provided to the card.
 
 Example:
 
 	sdhci0_pwrseq {
 		compatible = "mmc-pwrseq-simple";
-		reset-gpios = <&gpio1 12 0>;
+		/* WLAN and BT reset */
+		reset-gpios = <&gpio1 12 0>, <&gpio1 14 0>;
 	}
-- 
1.9.1

