Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab3LTNb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:31:56 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6981 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab3LTNZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:25:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Dec 2013 05:26:26 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <anton@enomsg.org>, <lee.jones@linaro.org>
CC: <dwmw2@infradead.org>, <mark.rutland@arm.com>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/2] mfd: AS3722: add dt node properties for system power controller
Date: Fri, 20 Dec 2013 18:53:59 +0530
Message-ID: <1387545840-2844-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ams AS3722 device supports the power off by turning off its all rails.

Add dt node properties to enable this functionality on this device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
Changes form V1:
- Rephrase sentence and mention that propery is boolean type.
- Added Tested by.

 Documentation/devicetree/bindings/mfd/as3722.txt |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
index fc2191e..8edcb9b 100644
--- a/Documentation/devicetree/bindings/mfd/as3722.txt
+++ b/Documentation/devicetree/bindings/mfd/as3722.txt
@@ -112,6 +112,15 @@ Following are properties of regulator subnode.
 		ams,enable-tracking: Enable tracking with SD1, only supported
 			by LDO3.
 
+Power-off:
+=========
+AS3722 supports the system power off by turning off all its rail. This
+is provided through pm_power_off.
+The device node should have the following properties to enable this
+functionality
+ams,system-power-controller: Boolean, to enable the power off functionality
+        through this device.
+
 Example:
 --------
 #include <dt-bindings/mfd/as3722.h>
@@ -120,6 +129,8 @@ ams3722 {
 	compatible = "ams,as3722";
 	reg = <0x48>;
 
+	ams,system-power-controller;
+
 	interrupt-parent = <&intc>;
 	interrupt-controller;
 	#interrupt-cells = <2>;
-- 
1.7.9.5

