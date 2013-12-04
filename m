Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab3LDXfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:35:46 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:49642 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3LDXfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:35:39 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCH 2/7] dt-bindings: Add property calxeda,pll-max-hz for Calxeda clocks
Date: Wed,  4 Dec 2013 17:35:22 -0600
Message-Id: <1386200127-23143-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
References: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Newer versions of PLL h/w have different frequency ranges for the PLLs,
but otherwise have the same programming model. Add an optional property
"calxeda,pll-max-hz" for Calxeda PLL clocks to handle this difference.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
---
 Documentation/devicetree/bindings/clock/calxeda.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/calxeda.txt b/Documentation/devicetree/bindings/clock/calxeda.txt
index 7ebc89c..9ee1b64 100644
--- a/Documentation/devicetree/bindings/clock/calxeda.txt
+++ b/Documentation/devicetree/bindings/clock/calxeda.txt
@@ -1,4 +1,4 @@
-Device Tree Clock bindings for Calxeda highbank platform
+Device Tree Clock bindings for Calxeda platforms
 
 This binding uses the common clock binding[1].
 
@@ -15,3 +15,8 @@ Required properties:
 - clocks : shall be the input parent clock phandle for the clock. This is
 	either an oscillator or a pll output.
 - #clock-cells : from common clock binding; shall be set to 0.
+
+Optional properties:
+- calxeda,pll-max-hz : The maximum output frequency of the PLL in Hz. The
+	default is 2.133GHz if not present. This is only present for
+	"calxeda,hb-pll-clock" nodes.
-- 
1.8.3.2

