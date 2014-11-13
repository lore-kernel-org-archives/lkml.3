Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbaKMLAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:00:37 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45299 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700AbaKMLAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:00:36 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 00/14] Add stih410 SoC and USB2/1.1 support
Date: Thu, 13 Nov 2014 11:00:03 +0000
Message-Id: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This series adds the required device tree nodes to enable the usb2/1.1 phy
and usb2/1.1 controllers on the stih416-b2120 board.

It additionally re-works and adds support for the new stih410 SoC which is
very similar to the stih407 SoC, by abstracting out the common parts
into common dt files. It also then adds the dt nodes to enable usb2/1.1 
for the stih410 platform as well.

As well as adding dt nodes it also enables the relevant drivers in the 
mult7_v7_defconfig.

Finally we update the default bootargs for stih407-b2120 and stih410-b2120
to boot with the clk_ignore_unused kernel parameter so as not to hang
the SoC when the (as yet) unreferenced interconnect clocks get disabled
by CCF (this is a tempoary solution).

This series has been tested on stih416-b2020 and stih410-b2120 SoC/boards.

Changes since v1:
- Leave bootargs & memory dt nodes in board files (Arnd)
- Remove '0x' from the unit address in all instances. (Arnd)
- Remove 'status="okay"' from some nodes (Arnd)
- Remove some legacy extra nodes which only contain status property (Arnd)
- Fix stih410 commit description (Maxime)
- Add a stih410.dtsi and stih410-pinctrl.dtsi files (Maxime)
- Remove superflous '\n' (Lee)
- Add a '\n' between the sentries and #include (Lee)

regards,

Peter.

Peter Griffin (14):
  ARM: STi: DT: STiH416: Add pinctl setup for usb controllers.
  ARM: STi: DT: STiH416: Add DT node for the stih415/6 usb2 phy
  ARM: STi: DT: STiH416: Add DT nodes for the ehci and ohci usb
    controllers.
  ARM: multi_v7_defconfig: Enable st ohci and ehci HCD drivers.
  ARM: multi_v7_defconfig: Enable stih415/6 usb2 phy driver.
  ARM: multi_v7_defconfig: Enable stih407 usb picophy
  ARM: STi: DT: STiH407: Add usb2 picophy dt nodes
  ARM: STi: DT: STiH410: Add defines for STiH410 DT clocks
  ARM: STi: DT: STiH410:  Add pinctl config for usb controllers.
  ARM: STi: DT: STih407: Abstract common dt nodes into shared files.
  ARM: STi: DT: STiH410: Add STiH410 SoC and b2120 board support.
  ARM: STi: DT: STih407: STih410: Add clk_ignore_unused to kernel
    bootargs
  ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
  ARM: STi: DT: STiH410: Add DT nodes for the ehci and ohci usb
    controllers.

 arch/arm/boot/dts/Makefile               |   1 +
 arch/arm/boot/dts/stih407-b2120.dts      |  55 +----
 arch/arm/boot/dts/stih407-family.dtsi    | 290 ++++++++++++++++++++++++++
 arch/arm/boot/dts/stih407.dtsi           | 279 -------------------------
 arch/arm/boot/dts/stih410-b2120.dts      |  29 +++
 arch/arm/boot/dts/stih410-clock.dtsi     | 338 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih410-pinctrl.dtsi   |  34 ++++
 arch/arm/boot/dts/stih410.dtsi           |  90 ++++++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi   |  34 ++++
 arch/arm/boot/dts/stih416.dtsi           | 129 ++++++++++++
 arch/arm/boot/dts/stihxxx-b2120.dtsi     |  59 ++++++
 arch/arm/configs/multi_v7_defconfig      |   4 +
 include/dt-bindings/clock/stih410-clks.h |  25 +++
 13 files changed, 1037 insertions(+), 330 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih407-family.dtsi
 delete mode 100644 arch/arm/boot/dts/stih407.dtsi
 create mode 100644 arch/arm/boot/dts/stih410-b2120.dts
 create mode 100644 arch/arm/boot/dts/stih410-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih410-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih410.dtsi
 create mode 100644 arch/arm/boot/dts/stihxxx-b2120.dtsi
 create mode 100644 include/dt-bindings/clock/stih410-clks.h

-- 
1.9.1

