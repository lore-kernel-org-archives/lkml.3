Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaHTNpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:45:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25703 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHTNpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:45:15 -0400
X-AuditID: cbfee61b-f79f86d00000144c-dd-53f4a6699a12
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v5 09/10] DT: Add documentation for the Skyworks AAT1290
Date: Wed, 20 Aug 2014 15:44:18 +0200
Message-id: <1408542259-415-10-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jAd3MZV+CDT49kbPYOGM9q8X8I+dY
	LfrfLGS1OPdqJaNF79XnjBZnm96wW1zeNYfNYuubdYwWPRu2slosvX6RyWLC9LUsFq17j7A7
	8HismbeG0eNyXy+Tx8rlX9g8Nq3qZPPo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujO5t31kK
	fnBVLP09gbWBcTZnFyMnh4SAiUTfk3tMELaYxIV769m6GLk4hAQWMUq83HqbGcJpZ5KYfe8D
	I0gVm4ChxM8Xr8E6RATKJXrePwPrYBZYzCQxtecFG0hCWMBHYvqVI8wgNouAqsSUb99Zuxg5
	OHgF3CWWdcWCmBICChJzJtmAmJxA0S3vVUCKhQTcJE6/m80ygZF3ASPDKkbR1ILkguKk9Fwj
	veLE3OLSvHS95PzcTYzgcHwmvYNxVYPFIUYBDkYlHt4bi74EC7EmlhVX5h5ilOBgVhLhbe8E
	CvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamCUrpiaHHq3
	sPZe+6HUd+p8yUc3NP/8deKu47fYVvntEy/17Zc6VMrOoJCwLrrg7U5G782cO/zCOJm//Z4t
	d7rc+tu08F81E0NlPj8J+nOWK+7p4ZitG5ZOvCR7cEnDrCxWs/VLp8UnbRKOtTezFih78/Lq
	RMuWrbJ5AS6H1yYnTazhmJd40CpOiaU4I9FQi7moOBEAuilb+EMCAAA=
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

