Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbbAIPXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:23:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24521 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902AbbAIPXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:23:40 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-2d-54aff27a06a7
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
Subject: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
Date: Fri, 09 Jan 2015 16:22:53 +0100
Message-id: <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jQd3qT+tDDB4/YrXYOGM9q8XRnROZ
	LOYfOcdq0f9mIavFuVcrGS16rz5ntDjb9Ibd4vKuOWwWW9+sY7To2bCV1WLp9YtMFndPHWWz
	mDB9LYtF694j7Ba7dz1ltTj8pp3V4sz+lWwOgh5r5q1h9Ljc18vksXPWXXaPlcu/sHkc/rqQ
	xWPTqk42jz3zf7B69G1ZxeixYvV3do/Pm+QCuKK4bFJSczLLUov07RK4MrrPrmMpeM1dcWbd
	I+YGxtecXYycHBICJhLbp29ghLDFJC7cW8/WxcjFISQwnVFi1p3jrBBOO5PEsau/2EGq2AQM
	JX6+eM3UxcjBISIQLXHpWD1IDbPAUmaJ6Z23WEDiwgKOEhNvpIKUswioSsy8vZ0VJMwr4C6x
	/7QmiCkhoCAxZ5INiMkp4CHR8tsJxBQCKnhz1XACI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMEh/kx6B+OqBotDjAIcjEo8vBvk1ocIsSaWFVfmHmKU4GBWEuFt2AwU4k1JrKxK
	LcqPLyrNSS0+xCjNwaIkzqtk3xYiJJCeWJKanZpakFoEk2Xi4JRqYBSNm7Fje4Od/OpLOd/8
	TCc3fpr+4Y+vzYla+bWslrpxL4JSeMMu3TgQVfXi2b0/TUJ8/Pe+9PTzXXDbXBtQKzGJu2WW
	Wch3/au3rJMcHXLES16fb56WFuX6O9phZZLsrwXH7RUEntxfJrVrb6/jpV3LdRQf112W3u/4
	N3r3XImuFQWSN7ZVVCmxFGckGmoxFxUnAgApG6q2bQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a property for defining the device outputs the LED
represented by the DT child node is connected to.

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
 Documentation/devicetree/bindings/leds/common.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
index a2c3f7a..29295bf 100644
--- a/Documentation/devicetree/bindings/leds/common.txt
+++ b/Documentation/devicetree/bindings/leds/common.txt
@@ -1,6 +1,10 @@
 Common leds properties.
 
 Optional properties for child nodes:
+- led-sources : Array of bits signifying the LED current regulator outputs the
+		LED represented by the child node is connected to (1 - the LED
+		is connected to the output, 0 - the LED isn't connected to the
+		output).
 - label : The label for this LED.  If omitted, the label is
   taken from the node name (excluding the unit address).
 
@@ -33,6 +37,7 @@ system-status {
 
 camera-flash {
 	label = "Flash";
+	led-sources = <1 0>;
 	max-microamp = <50000>;
 	flash-max-microamp = <320000>;
 	flash-timeout-us = <500000>;
-- 
1.7.9.5

