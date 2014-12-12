Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031275AbaLLS0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:26:22 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64645 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030930AbaLLS0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:26:20 -0500
From: VishnuPatekar <vishnupatekar0510@gmail.com>
To: linux-input@vger.kernel.org, maxime.ripard@free-electrons.com,
        dmitry.torokhov@gmail.com, hdegoede@redhat.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, grant.likely@linaro.org,
        benh@kernel.crashing.org, msalter@redhat.com, ralf@linux-mips.org,
        jdelvare@suse.de, VishnuPatekar <vishnupatekar0510@gmail.com>
Subject: [PATCHv3 0/5] ARM:sunxi:ps2 Added support for A10/A20 ps2 controller.
Date: Fri, 12 Dec 2014 23:55:43 +0530
Message-Id: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 --> v3
1. changed config to SERIO_SUN4I_PS2 from SERIO_SUNXI_PS2
2. changed driver name to sun4i-ps2 from sunxi-ps2.
3. changed the function names to sun4i_ps2_*.
4. added locking in sun4i_ps2_open.
5. kept compatible "sun4i-a10-ps2" for A10 and A20, as A10 is earlier SOC.
6. corrected the style errors.
7. separated the dts patches.
8. removed commented ps2 notes from lime2 dts.
9. added note that ps2 pins confilt with hdmi.
10. corrected the interrupt property for A10.
11. moved dt-bindings to Documentation/devicetree/bindings/serio

v1 --> v2: 
1. added default n depends on ARCH_SUNXI || COMPILE_TEST in Kconfig. 
2. handled errors and free resources on errors. 
3. used BIT(x), DIV_ROUND_UP macros. 
4. corrected style errors. 
5. added support for A10 also, A10 and A2 have same properties of PS2 controller. 
6. by default commented ps20 and ps21 nodes,as ps20 pins conflict with HDMI.
7. added compatible as allwinner,sun4i-a10-ps2. 
8. corrected the possible race condition. 


VishnuPatekar (5):
  sunxi:dts-bindings:input:ps2 bindings for A10/A20 ps2.
  ARM:sunxi:drivers:input Add support for A10/A20 PS2
  ARM: sunxi: dts: Add PS2 nodes to dtsi for A10 and A20
  ARM: sunxi: dts: Add A10/A20 PS2 pin muxing options
  ARM: sunxi: dts: Add note ps2 pins conflict with hdmi

 .../bindings/serio/allwinner,sun4i-ps2.txt         |   23 ++
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   31 ++
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts    |    6 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   32 ++
 drivers/input/serio/Kconfig                        |   11 +
 drivers/input/serio/Makefile                       |    1 +
 drivers/input/serio/sun4i-ps2.c                    |  362 ++++++++++++++++++++
 7 files changed, 465 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/serio/allwinner,sun4i-ps2.txt
 create mode 100644 drivers/input/serio/sun4i-ps2.c

-- 
1.7.9.5

