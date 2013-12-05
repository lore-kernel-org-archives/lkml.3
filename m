Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab3LEAum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:50:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59291 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3LEAu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:50:26 -0500
From: Nishanth Menon <nm@ti.com>
To: Rob Herring <rob.herring@calxeda.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 1/2] Documentation: dt: OMAP: explicitly state SoC compatible strings
Date: Wed, 4 Dec 2013 18:49:36 -0600
Message-ID: <1386204578-6018-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386204578-6018-1-git-send-email-nm@ti.com>
References: <1386204578-6018-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC family definitions at the moment are reactive to board needs.
This results in potentially wrong matches taking place for board types.

Eventually, we will have descriptors match only with SoC types and
should not contain anything specific to board handling and pave the
way to getting rid of soc_is_XYZ checks and allow this determination
done with matches at of level.

Existing implicit definitions(as part of board descriptions) are
explicitly documented.

NOTE: Even though we prefer to have dt compatibility to explicit,
"ti,dra7xx", "ti,am33xx", "ti,omap36xx" preexist in current dts and
are maintained for backward compatibility. It is also expected that
any future SoC addition will keep this documentation updated.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../devicetree/bindings/arm/omap/omap.txt          |   53 ++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index 808c154..34dc40c 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -31,6 +31,59 @@ spinlock@1 {
     ti,hwmods = "spinlock";
 };
 
+SoC Type (optional):
+
+- General Purpose devices
+  compatible = "ti,gp"
+- High Security devices
+  compatible = "ti,hs"
+
+SoC Families:
+
+- OMAP2 generic - defaults to OMAP2420
+  compatible = "ti,omap2"
+- OMAP3 generic - defaults to OMAP3430
+  compatible = "ti,omap3"
+- OMAP4 generic - defaults to OMAP4430
+  compatible = "ti,omap4"
+- OMAP5 generic - defaults to OMAP5430
+  compatible = "ti,omap5"
+- DRA7 generic - defaults to DRA742
+  compatible = "ti,dra7"
+- AM43x generic - defaults to AM4372
+  compatible = "ti,am43"
+
+SoCs:
+
+- OMAP2420
+  compatible = "ti,omap2420", "ti,omap2"
+- OMAP2430
+  compatible = "ti,omap2430", "ti,omap2"
+
+- OMAP3430
+  compatible = "ti,omap3430", "ti,omap3"
+- AM3517
+  compatible = "ti,am3517", "ti,omap3"
+- OMAP3630
+  compatible = "ti,omap36xx", "ti,omap3"
+- AM33xx
+  compatible = "ti,am33xx", "ti,omap3"
+
+- OMAP4430
+  compatible = "ti,omap4430", "ti,omap4"
+- OMAP4460
+  compatible = "ti,omap4460", "ti,omap4"
+
+- OMAP5430
+  compatible = "ti,omap5430", "ti,omap5"
+- OMAP5432
+  compatible = "ti,omap5432", "ti,omap5"
+
+- DRA742
+  compatible = "ti,dra7xx", "ti,dra7"
+
+- AM4372
+  compatible = "ti,am4372", "ti,am43"
 
 Boards:
 
-- 
1.7.9.5

