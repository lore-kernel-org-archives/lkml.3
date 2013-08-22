Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab3HVIcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:32:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56287 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab3HVIcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:32:16 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <swarren@wwwdotorg.org>, <tony@atomide.com>,
        <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <balbi@ti.com>
Subject: [PATCH v4] extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*
Date: Thu, 22 Aug 2013 14:01:23 +0530
Message-ID: <1377160283-26934-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Palmas device contains only a USB VBUS-ID detector, so added a
compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
types for backward compatibility.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v3:
* Fixed commit log message (VID to VBUS-ID).
* Fixed the Documentation to tell "ti,twl6035-usb" and "ti,palmas-usb" is
deprecated

Changes from [1]:
* Since the old compatible values will be in 3.11 kernel, we shouldn't remove
the old compatible values. So retain the old compatible values.

[1] -> http://www.spinics.net/lists/linux-omap/msg95843.html

 Documentation/devicetree/bindings/extcon/extcon-palmas.txt |    3 ++-
 drivers/extcon/extcon-palmas.c                             |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
index 7dab6a8..dc5fab3 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
+++ b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
@@ -2,7 +2,8 @@ EXTCON FOR PALMAS/TWL CHIPS
 
 PALMAS USB COMPARATOR
 Required Properties:
- - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
+ - compatible : Should be "ti,palmas-usb-vid". "ti,twl6035-usb" and
+   "ti,palmas-usb" is deprecated and is kept for backward compatibility.
 
 Optional Properties:
  - ti,wakeup : To enable the wakeup comparator in probe
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 89fdd05..9672f31 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -268,6 +268,7 @@ static const struct dev_pm_ops palmas_pm_ops = {
 
 static struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,palmas-usb", },
+	{ .compatible = "ti,palmas-usb-vid", },
 	{ .compatible = "ti,twl6035-usb", },
 	{ /* end */ }
 };
-- 
1.7.10.4

