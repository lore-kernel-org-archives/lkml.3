Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaBJGPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 01:15:24 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:30800 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaBJGPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 01:15:21 -0500
From: Bo Shen <voice.shen@atmel.com>
To: broonie@kernel.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-sound@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mark Brown <broonie@linaro.org>,
        Richard Genoud <richard.genoud@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] Binding: atmel-ssc: add option to choose clock
Date: Mon, 10 Feb 2014 14:09:46 +0800
Message-Id: <1392012586-30790-3-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392012586-30790-1-git-send-email-voice.shen@atmel.com>
References: <1392012586-30790-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the option to choose clock on which pin input to SSC (as slave).
Default is on TK pin to SSC, add "atmel,clk-from-rk-pin" option to
specify the clock is on RK pin to SSC.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
Changes in v3:
  - None
Series-changes: 2
  - using "-" replace "_" in binding document

 Documentation/devicetree/bindings/misc/atmel-ssc.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/misc/atmel-ssc.txt b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
index a45ae08..5c1e14e 100644
--- a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
+++ b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
@@ -14,6 +14,14 @@ Required properties for devices compatible with "atmel,at91sam9g45-ssc":
   See Documentation/devicetree/bindings/dma/atmel-dma.txt for details.
 - dma-names: Must be "tx", "rx".
 
+Optional properties:
+  - atmel,clk-from-rk-pin: bool property.
+     - When SSC works in slave mode, according to the hardware design, the
+       clock can get from TK pin, and also can get from RK pin. So, add
+       this parameter to choose where the clock from.
+     - By default the clock is from TK pin, if the clock from RK pin, this
+       property is needed.
+
 Examples:
 - PDC transfer:
 ssc0: ssc@fffbc000 {
-- 
1.8.5.2

