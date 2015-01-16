Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbbAPOEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:04:21 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43317 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbAPOET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:04:19 -0500
From: Vishnu Patekar <vishnupatekar0510@gmail.com>
To: dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        ijc+devicetree@hellion.org.uk, maxime.ripard@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vishnu Patekar <vishnupatekar0510@gmail.com>
Subject: [PATCH v4 0/5] ARM:sunxi:ps2 Added support for A10/A20 ps2 controller
Date: Fri, 16 Jan 2015 19:33:36 +0530
Message-Id: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for Allwinner A0, A20 PS2 controller. 

I've tested PS2 keyboard on A20 Olimex-Lime2 board. 
Hans had tested previous patch on A10 as well.

v3 --> v4
1. Reported errors(SERIO_FRAME,SERIO_TIMEOUT, SERIO_PARITY) to consumer.
2. Handled the transmit timeout in sun4i_ps2_write.
3. Removed the resetting the ps2 controller in case of errors.
4. Added synchronize_irq() in sun4i_ps2_close to make sure pending interrupts are handled.
5. Explicitly disabled interrupt in probe to avoid spurious interrupts.
6. Removed disable_irq from sun4i_ps2_remove as serio_close will take care of it.
7. Removed the obvious comments.
3. Corrected the style errors.
4. As there is not conflict with ps2 pins, enabled ps2 pins in lime2 dts by default.

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

Vishnu Patekar (5):
  sunxi:dts-bindings:input: bindings for A10/A20 ps2
  ARM:sunxi:drivers:input Add support for A10/A20 PS2
  ARM: sunxi: dts: Add PS2 nodes to dtsi for A10 and A20
  ARM: sunxi: dts: Add A10/A20 PS2 pin muxing options
  ARM: sunxi: dts: Add PS2 nodes for A20 lime2 board

 .../bindings/serio/allwinner,sun4i-ps2.txt         |   23 ++
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   30 ++
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts    |   12 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   30 ++
 drivers/input/serio/Kconfig                        |   11 +
 drivers/input/serio/Makefile                       |    1 +
 drivers/input/serio/sun4i-ps2.c                    |  330 ++++++++++++++++++++
 7 files changed, 437 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serio/allwinner,sun4i-ps2.txt
 create mode 100644 drivers/input/serio/sun4i-ps2.c

-- 
1.7.9.5

