Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaGKOFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:05:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49193 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGKOFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:12 -0400
X-AuditID: cbfee61a-f79e46d00000134f-99-53bfef1790c5
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
Subject: [PATCH/RFC v4 11/21] DT: leds: Add flash led devices related properties
Date: Fri, 11 Jul 2014 16:04:14 +0200
Message-id: <1405087464-13762-12-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQV3x9/uDDX7+57XYOGM9q8X8I+dY
	LfrfLGS1eHVmI5vFuVcrGS16rz5ntDjb9Ibd4vKuOWwWW9+sY7To2bCV1WLp9YtMFhOmr2Wx
	aN17hN3ixvQWVgc+jzXz1jB6XO7rZfJYufwLm8emVZ1sHr3N79g8+rasYvT4+VLH4/MmuQCO
	KC6blNSczLLUIn27BK6MbR+usRQcFKxYe0ytgfEYXxcjJ4eEgInE9AfXWSBsMYkL99azdTFy
	cQgJTGeUaG3ZDOW0M0ls/nWbHaSKTcBQ4ueL10wgtohAuUTP+2dgRcwC35gkXv7dytzFyMEh
	LBAgMWNzDEgNi4CqxLazi8E28Ap4Snxa/pQRpERCQEFiziQbkDAnUPhg/002EFtIwEPi4doT
	7BMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7aZ1I7GFc2WBxiFOBgVOLhVVi/
	L1iINbGsuDL3EKMEB7OSCO/VN/uDhXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJ
	zU5NLUgtgskycXBKNTBeUrDzaY5+HzBDI23Rp9ZvvqvmxHBlpPyO3mvaf+Ce4uNDP0Q7/ZZ/
	2fj3U02YwQZLuQD2jtgLtwqPhylyTtGeWLiz4qcpd/JKhZlJ0x3nMDK+/z9v16xfEY4SJ/Rn
	pPR7BhrePdQb1vn63QYV+3bBY5osmhK2rDx2YhP0mcS+5Ab63172TUqJpTgj0VCLuag4EQBu
	I91nVgIAAA==
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

