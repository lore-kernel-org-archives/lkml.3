Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbbA1Ums (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:42:48 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46211 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934110AbbA1Uml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:42:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Arend van Spriel <arend@broadcom.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 1/6] mmc: pwrseq: Document that simple sequence support more than one GPIO
Date: Wed, 28 Jan 2015 19:15:48 +0100
Message-Id: <1422468953-7594-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many SDIO/MMC attached WLAN chips need more than one ping for their reset
sequence. Extend the pwrseq_simple binding to support more than one pin.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v1:
 - Make the explanation clearer by adding an explicit "they".
   Suggested by Srinivas Kandagatla.
---
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
index da333d9ed94c..eaae652213ae 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
@@ -8,9 +8,10 @@ Required properties:
 - compatible : contains "mmc-pwrseq-simple".
 
 Optional properties:
-- reset-gpios : contains a GPIO specifier. The reset GPIO is asserted at
-	initialization and prior we start the power up procedure of the card. It
-	will be de-asserted right after the power has been provided to the card.
+- reset-gpios : contains a list of GPIO specifiers. The reset GPIOs are asserted
+	at initialization and prior we start the power up procedure of the card.
+	They will be de-asserted right after the power has been provided to the
+	card.
 
 Example:
 
-- 
2.1.3

