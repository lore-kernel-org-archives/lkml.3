Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaLCQIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:08:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65404 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaLCQIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:18 -0500
X-AuditID: cbfee61a-f79c06d000004e71-9a-547f35707698
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        devicetree@vger.kernel.org
Subject: [PATCH/RFC v9 10/19] DT: Add documentation for the Skyworks AAT1290
Date: Wed, 03 Dec 2014 17:06:45 +0100
Message-id: <1417622814-10845-11-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQd0C0/oQg6OzhCw2zljPanF050Qm
	i/lHzrFa9L9ZyGpx7tVKRoveq88ZLc42vWG3uLxrDpvF1jfrGC16NmxltVh6/SKTxd1TR9ks
	Jkxfy2LRuvcIu8XuXU9ZLQ6/aWe1OLN/JZuDoMeaeWsYPS739TJ57Jx1l91j5fIvbB6Hvy5k
	8di0qpPNY8/8H6wefVtWMXqsWP2d3ePzJrkArigum5TUnMyy1CJ9uwSujJ0317IUvOSuePl4
	PksD43/OLkZODgkBE4m5/6+yQdhiEhfurQeyuTiEBKYzSmz8/oUVJCEk0M4kseRDNojNJmAo
	8fPFa6YuRg4OEYFoiUvH6kHqmQXuMknM2/CNEaRGWMBH4ui1o2A2i4CqxP4tO5hAbF4BT4n2
	xRMZQXolBBQk5kyyAQlzAoWf/rjPDhIWEvCQODjRfwIj7wJGhlWMoqkFyQXFSem5hnrFibnF
	pXnpesn5uZsYwWH+TGoH48oGi0OMAhyMSjy8FnF1IUKsiWXFlbmHGCU4mJVEeJ99AwrxpiRW
	VqUW5ccXleakFh9ilOZgURLnvXEzN0RIID2xJDU7NbUgtQgmy8TBKdXAqMpos9xc/Na62ys7
	Li1VVl/2Zv2BeTd8DbYYXN5t8on/4JLtrkZBq3fWzzp078jO1eaC3WW/Xi7d49vofUH23Tez
	x+r7G9exFX61ylE9c3ljf6Ps2XzVHYvaV/hNWhTI1DbNcY9yjvhi/0Cftrc7vl1a0CmqetEw
	MefjfKOld3NtpxgqPH15+JgSS3FGoqEWc1FxIgCVMDLxbwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
1.5A Step-Up Current Regulator for Flash LEDs.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..17b8f05
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,17 @@
+* Skyworks Solutions, Inc. AAT1290 Current Regulator for Flash LEDs
+
+Required properties:
+
+- compatible : Must be "skyworks,aat1290".
+- gpios : Two gpio pins in order FLEN, EN/SET.
+- flash-timeout-microsec : Maximum flash timeout in microseconds -
+			   it can be calculated using following formula:
+			   T = 8.82 * 10^9 * Ct.
+
+Example:
+
+flash_led: led {
+	compatible = "skyworks,aat1290";
+	gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+	flash-timeout-microsec = <1940000>;
+}
-- 
1.7.9.5

