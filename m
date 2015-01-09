Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbbAIPYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:24:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55120 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892AbbAIPYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:24:35 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-6f-54aff2b175c4
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v10 12/19] DT: Add documentation for the Skyworks AAT1290
Date: Fri, 09 Jan 2015 16:23:02 +0100
Message-id: <1420816989-1808-13-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQd2Nn9aHGPxdZmqxccZ6VoujOycy
	Wcw/co7Vov/NQlaLc69WMlr0Xn3OaHG26Q27xeVdc9gstr5Zx2jRs2Erq8XS6xeZLO6eOspm
	MWH6WhaL1r1H2C1273rKanH4TTurxZn9K9kcBD3WzFvD6HG5r5fJY+esu+weK5d/YfM4/HUh
	i8emVZ1sHnvm/2D16NuyitFjxerv7B6fN8kFcEVx2aSk5mSWpRbp2yVwZfyc+Yu1YC93xed9
	n1kaGK9wdjFyckgImEg0/Z/NBGGLSVy4t56ti5GLQ0hgOqPE5Md7mCCcdiaJBZ2nWECq2AQM
	JX6+eA2U4OAQEYiWuHSsHqSGWWAps8T0zltgNcICvhKf3t9mA7FZBFQlni2ewgpi8wp4SHSf
	PMAC0ishoCAxZ5INiMkJFG757QRiCgm4S7y5ajiBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8
	dL3k/NxNjOAwfya9g3FVg8UhRgEORiUe3g1y60OEWBPLiitzDzFKcDArifA2bAYK8aYkVlal
	FuXHF5XmpBYfYpTmYFES51WybwsREkhPLEnNTk0tSC2CyTJxcEo1MKaccw3eU/83p3H/Zn8P
	9pTGKN3LAqHGzpoHnvHcmZtwYsGPCy8Ll+V6coQxzWY2Y600DV14cr1ztsfJ0qm12iWBM7rN
	btfY2wbYvaytbdjdkL0yuL+iS5U5u5CB69IOLY5Lpxf/U3wWXX7EIGr9GWPJ6OYf6z7c/vhW
	oVeBh2Py2r+nzq9uUGIpzkg01GIuKk4EACpJ6z1vAgAA
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
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..880a21d
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,17 @@
+* Skyworks Solutions, Inc. AAT1290 Current Regulator for Flash LEDs
+
+Required properties:
+
+- compatible : Must be "skyworks,aat1290".
+- gpios : Two gpio pins in order FLEN, EN/SET.
+- flash-timeout-us : Maximum flash timeout in microseconds -
+		     it can be calculated using following formula:
+		     T = 8.82 * 10^9 * Ct.
+
+Example:
+
+flash_led: led {
+	compatible = "skyworks,aat1290";
+	gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+	flash-timeout-us = <1940000>;
+}
-- 
1.7.9.5

