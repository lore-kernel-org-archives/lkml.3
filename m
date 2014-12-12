Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966065AbaLLT2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:28:44 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11942 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965940AbaLLT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:28:42 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Ulf Hansson <ulf.hansson@linaro.org>, Anton Vorontsov <anton@enomsg.org>,
        Chris Ball <chris@printf.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SECURE DIGITAL HO..." <linux-mmc@vger.kernel.org>
Subject: [PATCH] mmc: dt: Add property for broken hs200 quirk
Date: Fri, 12 Dec 2014 11:28:36 -0800
Message-ID: <1418412516-10682-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 Documentation/devicetree/bindings/mmc/mmc.txt | 2 ++
 drivers/mmc/host/sdhci-pltfm.c                | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index b52628b..04f80ef 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -22,6 +22,8 @@ Optional properties:
 - wp-inverted: when present, polarity on the WP line is inverted. See the note
   below for the case, when a GPIO is used for the WP line
 - max-frequency: maximum operating clock frequency
+- broken-hs200: when present, denotes that eMMC HS200 modes are not supported on
+  this system, even if the controller claims it is.
 - no-1-8-v: when present, denotes that 1.8v card voltage is not supported on
   this system, even if the controller claims it is.
 - cap-sd-highspeed: SD high-speed timing is supported
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index c5b01d6..570837f 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -90,6 +90,9 @@ void sdhci_get_of_property(struct platform_device *pdev)
 		if (of_get_property(np, "broken-cd", NULL))
 			host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 
+		if (of_get_property(np, "broken-hs200", NULL))
+			host->quirks2 |= SDHCI_QUIRK2_BROKEN_HS200;
+
 		if (of_get_property(np, "no-1-8-v", NULL))
 			host->quirks2 |= SDHCI_QUIRK2_NO_1_8_V;
 
-- 
1.8.2.2

