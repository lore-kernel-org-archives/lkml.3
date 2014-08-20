Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaHTNrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:47:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36229 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaHTNop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:45 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0b-53f4a64b7b3d
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v5 04/10] DT: leds: Add flash led devices related properties
Date: Wed, 20 Aug 2014 15:44:13 +0200
Message-id: <1408542259-415-5-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t9jAV2fZV+CDf6sZrXYOGM9q8X8I+dY
	LfrfLGS1eHVmI5vFuVcrGS16rz5ntDjb9Ibd4vKuOWwWW9+sY7To2bCV1WLp9YtMFhOmr2Wx
	aN17hN3ixvQWVgc+jzXz1jB6XO7rZfJYufwLm8emVZ1sHr3N79g8+rasYvT4+VLH4/MmuQCO
	KC6blNSczLLUIn27BK6MbR+usRQcFKxYe0ytgfEYXxcjB4eEgInEhFf5XYycQKaYxIV769m6
	GLk4hAQWMUqs7D/LDuG0M0ms39jFAlLFJmAo8fPFayYQW0SgXKLn/TOwDmaBb0wSL/9uZQZJ
	CAsESKze/4YdxGYRUJW4s+ofWDOvgJvE2mcnmCE2K0jMmWQDYnIKuEtsea8CUiEEVHH63WyW
	CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh+wzqR2MKxssDjEKcDAq8fA2LPgS
	LMSaWFZcmXuIUYKDWUmEt70TKMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZq
	akFqEUyWiYNTqoFRd3b1XvfbRnyy/M/YPDRPOPjmXom85GG46PO2qZtusSqtODA5u+HR1b9V
	11KjHFfwl59slYvQEH+1oGXaihM57e7xL5tagqY9nvRzcsWR3u2zt3RtUVmjy1hzeF/1it6i
	d9v6mib0nFg/a/ZnMeauu2e4j8uGipd+sun/Nu9q9hP+VRPW3z1zS4mlOCPRUIu5qDgRAEaq
	wwxVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addition of a LED Flash Class extension entails the need for flash led
specific device tree properties. The properties being added are:
iout-torch, iout-flash, iout-indicator and flash-timeout.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/leds/common.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
index 2d88816..40f4b9a 100644
--- a/Documentation/devicetree/bindings/leds/common.txt
+++ b/Documentation/devicetree/bindings/leds/common.txt
@@ -3,6 +3,17 @@ Common leds properties.
 Optional properties for child nodes:
 - label : The label for this LED.  If omitted, the label is
   taken from the node name (excluding the unit address).
+- iout-torch : Array of maximum intensities in microamperes of the torch
+	led currents in order from sub-led 0 to N-1, where N is the number
+	of torch sub-leds exposed by the device
+- iout-flash : Array of maximum intensities in microamperes of the flash
+	led currents in order from sub-led 0 to N-1, where N is the number
+	of flash sub-leds exposed by the device
+- iout-indicator : Array of maximum intensities in microamperes of
+	the indicator led currents in order from sub-led 0 to N-1,
+	where N is the number of indicator sub-leds exposed by the device
+- flash-timeout : timeout in microseconds after which flash led
+	is turned off
 
 - linux,default-trigger :  This parameter, if present, is a
     string defining the trigger assigned to the LED.  Current triggers are:
@@ -19,5 +30,10 @@ Examples:
 system-status {
 	label = "Status";
 	linux,default-trigger = "heartbeat";
+	iout-torch = <500 500>;
+	iout-flash = <1000 1000>;
+	iout-indicator = <100 100>;
+	flash-timeout = <1000>;
+
 	...
 };
-- 
1.7.9.5

