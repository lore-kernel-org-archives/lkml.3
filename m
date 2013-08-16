Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3HPKWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:22:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48953 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab3HPKVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:21:34 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <swarren@wwwdotorg.org>, <tony@atomide.com>,
        <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <balbi@ti.com>
Subject: [PATCH v2] extcon: palmas: Modified the compatible type to *ti,palmas-usb-vid*
Date: Fri, 16 Aug 2013 15:50:48 +0530
Message-ID: <1376648448-27447-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Palmas device contains only a USB VID detector, so modified the
compatible type to *ti,palmas-usb-vid*.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
* removed the existing compatible types and changed it to *ti,palmas-usb-vid*

 Documentation/devicetree/bindings/extcon/extcon-palmas.txt |    4 ++--
 drivers/extcon/extcon-palmas.c                             |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
index 7dab6a8..00859f6 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
+++ b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
@@ -2,7 +2,7 @@ EXTCON FOR PALMAS/TWL CHIPS
 
 PALMAS USB COMPARATOR
 Required Properties:
- - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
+ - compatible : Should be "ti,palmas-usb-vid".
 
 Optional Properties:
  - ti,wakeup : To enable the wakeup comparator in probe
@@ -10,6 +10,6 @@ Optional Properties:
  - ti,enable-vbus-detection: Perform VBUS detection.
 
 palmas-usb {
-       compatible = "ti,twl6035-usb", "ti,palmas-usb";
+       compatible = "ti,palmas-usb-vid";
        ti,wakeup;
 };
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 89fdd05..f3ed2d7 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -267,8 +267,7 @@ static const struct dev_pm_ops palmas_pm_ops = {
 };
 
 static struct of_device_id of_palmas_match_tbl[] = {
-	{ .compatible = "ti,palmas-usb", },
-	{ .compatible = "ti,twl6035-usb", },
+	{ .compatible = "ti,palmas-usb-vid", },
 	{ /* end */ }
 };
 
-- 
1.7.10.4

