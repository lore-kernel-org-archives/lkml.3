Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaGKOFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:05:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59491 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbaGKOFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:50 -0400
X-AuditID: cbfee61a-f79e46d00000134f-d0-53bfef3c894f
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v4 20/21] DT: Add documentation for the Skyworks AAT1290
Date: Fri, 11 Jul 2014 16:04:23 +0200
Message-id: <1405087464-13762-21-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jQV2b9/uDDU7tULTYOGM9q8X8I+dY
	LfrfLGS1OPdqJaNF79XnjBZnm96wW1zeNYfNYuubdYwWPRu2slosvX6RyWLC9LUsFq17j7A7
	8HismbeG0eNyXy+Tx8rlX9g8Nq3qZPPo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujO5t31kK
	fnBVLP09gbWBcTZnFyMnh4SAicSyRweYIWwxiQv31rN1MXJxCAlMZ5SYNmUilNPOJHH4yFNG
	kCo2AUOJny9eM4HYIgLlEj3vn4EVMQssZpKY2vMCyOHgEBbwkejuKwOpYRFQlXjQfYgdxOYV
	8JT4u24hO0iJhICCxJxJNiBhTqDwwf6bbCC2kICHxMO1J9gnMPIuYGRYxSiaWpBcUJyUnmuo
	V5yYW1yal66XnJ+7iREckM+kdjCubLA4xCjAwajEw6uwfl+wEGtiWXFl7iFGCQ5mJRHeq2/2
	BwvxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgZEmqfl12
	6mrYxG3PN1QpMXQlHnHQ/nros77Rcf1sE9Yva7dELnYU7u1+ulJq3lMNx68Rz8/89PUMkTW5
	MWGnXrTz6YK8xbxfVY7EHb7JMP3aKj027u9x7zafZ41hPCa2aNsRIwu17ns1Dv+iVSI39W+p
	KrYye7PPp8t9o7tW1UcdNbsc0Z5NSizFGYmGWsxFxYkAme80EUQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
1.5A Step-Up Current Regulator for Flash LEDs.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..9a9ad15
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,17 @@
+* Skyworks Solutions, Inc. AAT1290 Current Regulator for Flash LEDs
+
+Required properties:
+
+- compatible : should be "skyworks,aat1290"
+- gpios : two gpio pins in order FLEN, EN/SET
+- skyworks,flash-timeout : maximum flash timeout in microseconds -
+			   it can be calculated using following formula:
+			   T = 8.82 * 10^9 * Ct
+
+Example:
+
+flash_led: flash-led {
+	compatible = "skyworks,aat1290";
+	gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+	flash-timeout = <1940000>;
+}
-- 
1.7.9.5

