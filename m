Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967861AbaLLNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:16:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967578AbaLLNQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:16:56 -0500
Message-ID: <548AEA8E.6040100@redhat.com>
Date: Fri, 12 Dec 2014 14:15:58 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com, dmitry.torokhov@gmail.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk
CC: leafy.myeh@newbietech.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org,
        vishnupatekar <VishnuPatekar0510@gmail.com>
Subject: Re: [linux-sunxi] [PATCHv2 0/3] ARM:sunxi:ps2 Added support for A10/A20
 ps2 controller.
References: <1417907719-26775-1-git-send-email-VishnuPatekar0510@gmail.com>
In-Reply-To: <1417907719-26775-1-git-send-email-VishnuPatekar0510@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000808020300080807030800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000808020300080807030800
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 07-12-14 00:15, vishnupatekar wrote:
> Here is v2 of SUNXI PS2 controller support patch-set as with v1.

So as promised I've run this on an A10 board, with a small fix to
the interrupt property in the sun4i.dtsi file this works as is.

This means that the sun7i compat should be dropped, and the sun4i
compat used everywhere.

I've created 3 fixup patches to do this, note one also renames / moves
the bindings file as it is in the wrong place.

I've attached the 3 fixup patches, pleasesquash these into your
existing patches before posting the next version.

Thanks & Regards,

Hans


>
> Changes in v2:
> 1. added default n depends on ARCH_SUNXI || COMPILE_TEST in Kconfig.
> 2. handled errors and free resources on errors.
> 3. used BIT(x), DIV_ROUND_UP macros.
> 4. corrected style errors.
> 5. added support for A10 also, A10 and A2 have same properties of PS2 controller.
> 6. by default commented ps20 and ps21 nodes,as ps20 pins conflict with HDMI
>     connector on Lime2 Board.
> 7. added compatible as allwinner,sun4i-a10-ps2.
> 8. corrected the possible race condition.
>
> Patch 0 Summary: Allwinner A10/A20 PS2 controller. These modifications are
> 	for PS2 host controller. IBM compliant IBM PS2 and AT-compatible
> 	keyboard and mouse can be connected.
>
> Patch 1 device tree bindings.
>
> Patch 2 adds support for sun7i ps2 driver.
>
> Patch 3 device tree support for PS2 controller.
>   1) Added A10/A20 ps2 nodes to the dtsi
>   2) Added A10/A20 ps2 pinmux to the dtsi
>   3) Added ps2 nodes to the lime2 dts file
>
> vishnupatekar (3):
>    sunxi:dts-bindings:input:ps2 bindings for A10/A20 ps2.
>    sunxi:drivers:input:ps2 Added sunxi A10/A20 ps2 driver
>    ARM:dts:sunxi:ps2 dt nodes for A10/A20 PS2 controller.
>
>   .../bindings/input/allwinner,sunxi-ps2.txt         |   23 ++
>   arch/arm/boot/dts/sun4i-a10.dtsi                   |   27 ++
>   arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts    |   13 +
>   arch/arm/boot/dts/sun7i-a20.dtsi                   |   29 ++
>   drivers/input/serio/Kconfig                        |   10 +
>   drivers/input/serio/Makefile                       |    1 +
>   drivers/input/serio/sunxi-ps2.c                    |  364 ++++++++++++++++++++
>   7 files changed, 467 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt
>   create mode 100644 drivers/input/serio/sunxi-ps2.c
>

--------------000808020300080807030800
Content-Type: text/x-patch;
 name="0001-FIXUP-sunxi-dts-bindings-input-ps2-bindings-for-A10-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-FIXUP-sunxi-dts-bindings-input-ps2-bindings-for-A10-.pa";
 filename*1="tch"

>From 85105ec25cfb0dcff102e579e00a0a6c38ac34e9 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 12 Dec 2014 14:05:56 +0100
Subject: [PATCH v2 1/4] FIXUP: "sunxi:dts-bindings:input:ps2 bindings for
 A10/A20 ps2."

2 fixups for: "sunxi:dts-bindings:input:ps2 bindings for A10/A20 ps2."

1) dt bindings should use the compat string for the earliest version of the
hardware which has the relevant hardware block, unless there are differences,
the A10 and A20 ps2 controllers are identical, so for both sun4i-a10-ps2
should be used as compat string.

2) ps2 / serio bindings belong under Documentation/devicetree/bindings/serio

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../bindings/input/allwinner,sunxi-ps2.txt         | 23 ----------------------
 .../bindings/serio/allwinner,sun4i-a10-ps2.txt     | 22 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 23 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt
 create mode 100644 Documentation/devicetree/bindings/serio/allwinner,sun4i-a10-ps2.txt

diff --git a/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt b/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt
deleted file mode 100644
index 3a8919a..0000000
--- a/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt
+++ /dev/null
@@ -1,23 +0,0 @@
-* Device tree bindings for Allwinner A10, A20 PS2 host controller
-
-A20 PS2 is dual role controller(PS2 host and PS2 device). These bindings are for PS2 host controller.
-IBM compliant IBM PS2 and AT-compatible keyboard and mouse can be connected.
-
-Required properties:
-
- - reg             : Offset and length of the register set for the device.
- - compatible      : Should one of the following:
-                     - "allwinner,sun7i-a20-ps2"
-                     - "allwinner,sun4i-a10-ps2"
- - interrupts      : The interrupt line connected to the PS2.
- - clocks          : The gate clk connected to the PS2.
-
-
-Example:
-	ps20: ps2@0x01c2a000 {
-		compatible = "allwinner,sun7i-a20-ps2";
-		reg = <0x01c2a000 0x400>;
-		interrupts = <0 62 4>;
-		clocks = <&apb1_gates 6>;
-		status = "disabled";
-	};
diff --git a/Documentation/devicetree/bindings/serio/allwinner,sun4i-a10-ps2.txt b/Documentation/devicetree/bindings/serio/allwinner,sun4i-a10-ps2.txt
new file mode 100644
index 0000000..c93ca90
--- /dev/null
+++ b/Documentation/devicetree/bindings/serio/allwinner,sun4i-a10-ps2.txt
@@ -0,0 +1,22 @@
+* Device tree bindings for Allwinner A10, A20 PS2 host controller
+
+A10 PS2 is dual role controller (PS2 host and PS2 device). These bindings are
+for the PS2 host controller.
+IBM compliant IBM PS2 and AT-compatible keyboard and mouse can be connected.
+
+Required properties:
+
+ - reg             : Offset and length of the register set for the device.
+ - compatible      : "allwinner,sun4i-a10-ps2"
+ - interrupts      : The interrupt line connected to the PS2.
+ - clocks          : The gate clk connected to the PS2.
+
+
+Example:
+	ps20: ps2@0x01c2a000 {
+		compatible = "allwinner,sun4i-a10-ps2";
+		reg = <0x01c2a000 0x400>;
+		interrupts = <0 62 4>;
+		clocks = <&apb1_gates 6>;
+		status = "disabled";
+	};
-- 
2.1.0


--------------000808020300080807030800
Content-Type: text/x-patch;
 name="0002-FIXUP-sunxi-drivers-input-ps2-Added-sunxi-A10-A20-ps.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-FIXUP-sunxi-drivers-input-ps2-Added-sunxi-A10-A20-ps.pa";
 filename*1="tch"

>From 0eecd5e763278a59c4533e576ac1c9616310c21e Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 12 Dec 2014 14:11:56 +0100
Subject: [PATCH v2 2/4] FIXUP: "sunxi:drivers:input:ps2 Added sunxi A10/A20
 ps2 driver"

dt bindings should use the compat string for the earliest version of the
hardware which has the relevant hardware block, unless there are differences,
the A10 and A20 ps2 controllers are identical, so for both sun4i-a10-ps2
should be used as compat string, drop the sun7i-a20-ps2 compat string.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/input/serio/sunxi-ps2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/serio/sunxi-ps2.c b/drivers/input/serio/sunxi-ps2.c
index 4cd89ae..cb89d80 100644
--- a/drivers/input/serio/sunxi-ps2.c
+++ b/drivers/input/serio/sunxi-ps2.c
@@ -340,7 +340,6 @@ static int sunxips2_remove(struct platform_device *pdev)
 
 /* Match table for of_platform binding */
 static const struct of_device_id sunxips2_of_match[] = {
-	{ .compatible = "allwinner,sun7i-a20-ps2", },
 	{ .compatible = "allwinner,sun4i-a10-ps2", },
 	{ },
 };
-- 
2.1.0


--------------000808020300080807030800
Content-Type: text/x-patch;
 name="0003-FIXUP-ARM-dts-sunxi-ps2-dt-nodes-for-A10-A20-PS2-con.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-FIXUP-ARM-dts-sunxi-ps2-dt-nodes-for-A10-A20-PS2-con.pa";
 filename*1="tch"

>From 45985183f3e96adf1c846c7bbde32647367024dc Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 12 Dec 2014 14:01:43 +0100
Subject: [PATCH v2 3/4] FIXUP: "ARM:dts:sunxi:ps2 dt nodes for A10/A20 PS2
 controller."

2 fixups for: "ARM:dts:sunxi:ps2 dt nodes for A10/A20 PS2 controller."

1) Fixup the sun4i ps/2 nodes interrupt property, sun4i interrupts take
only 1 specifier

2) dt bindings should use the compat string for the earliest version of the
hardware which has the relevant hardware block, unless there are differences,
the A10 and A20 ps2 controllers are identical, so for both sun4i-a10-ps2
should be used as compat string, update the sun7i.dtsi ps2 entries to
use the sun4i-a10-ps2 compat string.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 4 ++--
 arch/arm/boot/dts/sun7i-a20.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index c04c117..e8cd6db 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -818,14 +818,14 @@
 		ps20: ps2@0x01c2a000 {
 			compatible = "allwinner,sun4i-a10-ps2";
 			reg = <0x01c2a000 0x400>;
-			interrupts = <0 62 4>;
+			interrupts = <62>;
 			clocks = <&apb1_gates 6>;
 			status = "disabled";
 		};
 		ps21: ps2@0x01c2a400 {
 			compatible = "allwinner,sun4i-a10-ps2";
 			reg = <0x01c2a400 0x400>;
-			interrupts = <0 63 4>;
+			interrupts = <63>;
 			clocks = <&apb1_gates 7>;
 			status = "disabled";
 		};
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 4417c8c3..d54d684 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -1114,14 +1114,14 @@
 			interrupts = <1 9 0xf04>;
 		};
 		ps20: ps2@0x01c2a000 {
-			compatible = "allwinner,sun7i-a20-ps2";
+			compatible = "allwinner,sun4i-a10-ps2";
 			reg = <0x01c2a000 0x400>;
 			interrupts = <0 62 4>;
 			clocks = <&apb1_gates 6>;
 			status = "disabled";
 		};
 		ps21: ps2@0x01c2a400 {
-			compatible = "allwinner,sun7i-a20-ps2";
+			compatible = "allwinner,sun4i-a10-ps2";
 			reg = <0x01c2a400 0x400>;
 			interrupts = <0 63 4>;
 			clocks = <&apb1_gates 7>;
-- 
2.1.0


--------------000808020300080807030800--
