Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab3HML14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:27:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34040 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515Ab3HML1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:27:53 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <benoit.cousson@linaro.org>, <tony@atomide.com>, <swarren@wwwdotorg.org>,
        <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <balbi@ti.com>
Subject: [PATCH v2] extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*
Date: Tue, 13 Aug 2013 16:56:51 +0530
Message-ID: <1376393211-23145-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Palmas device contains only a USB VID detector, so added a
compatible type *ti,palmas-usb-vid*. Dint remove the existing compatible
types for backward compatibility.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
rebased on extcon-next

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
+ - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb" or
+   "ti,palmas-usb-vid".
 
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

