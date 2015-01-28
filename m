Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbbA1ViW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:38:22 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46213 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbbA1Umn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:42:43 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Arend van Spriel <arend@broadcom.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 3/6] mmc: pwrseq: Document optional clock for the simple power sequence
Date: Wed, 28 Jan 2015 19:15:50 +0100
Message-Id: <1422468953-7594-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some WLAN chips attached to a SDIO interface, need an external clock
to be operational. Since this is very common, extend the simple MMC
power sequence DT binding to support an optional clock.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v1: None.
---
 Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
index eaae652213ae..a462c50f19a8 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
@@ -12,6 +12,10 @@ Optional properties:
 	at initialization and prior we start the power up procedure of the card.
 	They will be de-asserted right after the power has been provided to the
 	card.
+- clocks : Must contain an entry for the entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names : Must include the following entry:
+  "ext_clock" (External clock provided to the card).
 
 Example:
 
-- 
2.1.3

