Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3CEOWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:22:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39630 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3CEOWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:22:32 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <s-guiriec@ti.com>, <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 4/4] usb: musb: omap2430: replace *_* with *-* in property names
Date: Tue, 5 Mar 2013 19:52:00 +0530
Message-ID: <1362493320-13913-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362493320-13913-1-git-send-email-kishon@ti.com>
References: <1362493320-13913-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Replace *_* with *-* in property names of otg to
follow the general convention.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |   12 ++++++------
 drivers/usb/musb/omap2430.c                        |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 1b9f55f..662f0f1 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -8,10 +8,10 @@ OMAP MUSB GLUE
    and disconnect.
  - multipoint : Should be "1" indicating the musb controller supports
    multipoint. This is a MUSB configuration-specific setting.
- - num_eps : Specifies the number of endpoints. This is also a
+ - num-eps : Specifies the number of endpoints. This is also a
    MUSB configuration-specific setting. Should be set to "16"
- - ram_bits : Specifies the ram address size. Should be set to "12"
- - interface_type : This is a board specific setting to describe the type of
+ - ram-bits : Specifies the ram address size. Should be set to "12"
+ - interface-type : This is a board specific setting to describe the type of
    interface between the controller and the phy. It should be "0" or "1"
    specifying ULPI and UTMI respectively.
  - mode : Should be "3" to represent OTG. "1" signifies HOST and "2"
@@ -29,14 +29,14 @@ usb_otg_hs: usb_otg_hs@4a0ab000 {
 	ti,hwmods = "usb_otg_hs";
 	ti,has-mailbox;
 	multipoint = <1>;
-	num_eps = <16>;
-	ram_bits = <12>;
+	num-eps = <16>;
+	ram-bits = <12>;
 	ctrl-module = <&omap_control_usb>;
 };
 
 Board specific device node entry
 &usb_otg_hs {
-	interface_type = <1>;
+	interface-type = <1>;
 	mode = <3>;
 	power = <50>;
 };
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 1762354..dde2802 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -522,10 +522,10 @@ static int omap2430_probe(struct platform_device *pdev)
 		}
 
 		of_property_read_u32(np, "mode", (u32 *)&pdata->mode);
-		of_property_read_u32(np, "interface_type",
+		of_property_read_u32(np, "interface-type",
 						(u32 *)&data->interface_type);
-		of_property_read_u32(np, "num_eps", (u32 *)&config->num_eps);
-		of_property_read_u32(np, "ram_bits", (u32 *)&config->ram_bits);
+		of_property_read_u32(np, "num-eps", (u32 *)&config->num_eps);
+		of_property_read_u32(np, "ram-bits", (u32 *)&config->ram_bits);
 		of_property_read_u32(np, "power", (u32 *)&pdata->power);
 		config->multipoint = of_property_read_bool(np, "multipoint");
 		pdata->has_mailbox = of_property_read_bool(np,
-- 
1.7.10.4

