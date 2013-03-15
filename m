Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3COC6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:58:36 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40552 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3COC6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:58:35 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jingoo Han <jg1.han@samsung.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] usb: Document clocks in samsung,exynos4210-ehci/ohci bindings
Date: Thu, 14 Mar 2013 19:58:23 -0700
Message-Id: <1363316303-12736-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363302046-31684-1-git-send-email-dianders@chromium.org>
References: <1363302046-31684-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynox4210-ehci and exynos4210-ohci nodes need a clock specified
using the common clock framework.  Document it.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Fixed embarrassing typo adc=>usb.  Thanks Jingoo!

 Documentation/devicetree/bindings/usb/exynos-usb.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index f66fcdd..b3abde7 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -10,6 +10,8 @@ Required properties:
  - reg: physical base address of the controller and length of memory mapped
    region.
  - interrupts: interrupt number to the cpu.
+ - clocks: from common clock binding: handle to usb clock.
+ - clock-names: from common clock binding: Shall be "usbhost".
 
 Optional properties:
  - samsung,vbus-gpio:  if present, specifies the GPIO that
@@ -22,6 +24,9 @@ Example:
 		reg = <0x12110000 0x100>;
 		interrupts = <0 71 0>;
 		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
+
+		clocks = <&clock 285>;
+		clock-names = "usbhost";
 	};
 
 OHCI
@@ -31,10 +36,15 @@ Required properties:
  - reg: physical base address of the controller and length of memory mapped
    region.
  - interrupts: interrupt number to the cpu.
+ - clocks: from common clock binding: handle to usb clock.
+ - clock-names: from common clock binding: Shall be "usbhost".
 
 Example:
 	usb@12120000 {
 		compatible = "samsung,exynos4210-ohci";
 		reg = <0x12120000 0x100>;
 		interrupts = <0 71 0>;
+
+		clocks = <&clock 285>;
+		clock-names = "usbhost";
 	};
-- 
1.8.1.3

