Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330AbbA1Urp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:47:45 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46228 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934277AbbA1Url (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 3/5] mmc: pwrseq: Document optional clock for the simple power sequence
Date: Wed, 28 Jan 2015 11:10:17 +0100
Message-Id: <1422439819-29854-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some WLAN chips attached to a SDIO interface, need an external clock
to be operational. Since this is very common, extend the simple MMC
power sequence DT binding to support an optional clock.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
index 9a77deb164c7..6b5c10d1144c 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
@@ -11,6 +11,10 @@ Optional properties:
 - reset-gpios : contains a list of GPIO specifiers. The reset GPIOs are asserted
 	at initialization and prior we start the power up procedure of the card.
 	Will be de-asserted right after the power has been provided to the card.
+- clocks : Must contain an entry for the entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names : Must include the following entry:
+  "ext_clock" (External clock provided to the card).
 
 Example:
 
-- 
2.1.3

