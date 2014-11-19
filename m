Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaKSI1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:27:21 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61978 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaKSI1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:27:19 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, kishon@ti.com,
        arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, alexandre.torgue@st.com
Subject: [PATCH 0/7] Fix sti drivers whcih mix reg address spaces
Date: Wed, 19 Nov 2014 08:27:05 +0000
Message-Id: <1416385632-5832-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following on from Arnds comments about the picophy driver here
https://lkml.org/lkml/2014/11/13/161, this series fixes the
remaining upstreamed drivers for STI, which are mixing address spaces
in the reg property. We do this in a way similar to the keystone
and bcm7445 platforms, by having sysconfig phandle/ offset pair (
where only one register is required). Or phandle / integer array
where multiple offsets in the same bank are needed).

This series breaks DT compatability! But the platform support
is WIP and only being used by the few developers who are upstreaming
support for it. I've made each change to the driver / dt doc / dt
file as a single atomic commit so the kernel will remain bisectable. 

This series then also enables the picophy driver, and adds back in
the ehci/ohci dt nodes for stih410 which make use of the picophy.

regards,

Peter.


Peter Griffin (7):
  phy: phy-stih407-usb: Pass sysconfig register offsets via syscfg
    property.
  phy: miphy365x: Pass sysconfig register offsets via syscfg dt
    property.
  ARM: STi: DT: STiH407: Add usb2 picophy dt nodes
  ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
  ARM: STi: DT: STiH410: Add DT nodes for the ehci and ohci usb
    controllers.
  ARM: multi_v7_defconfig: Enable stih407 usb picophy
  stmmac: dwmac-sti: Pass sysconfig register offset via syscon dt
    property.

 .../devicetree/bindings/net/sti-dwmac.txt          | 14 ++---
 .../devicetree/bindings/phy/phy-miphy365x.txt      | 15 ++---
 .../devicetree/bindings/phy/phy-stih407-usb.txt    | 10 +---
 arch/arm/boot/dts/stih407-family.dtsi              |  9 +++
 arch/arm/boot/dts/stih410.dtsi                     | 70 ++++++++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi                     | 12 ++--
 arch/arm/boot/dts/stih416.dtsi                     | 22 +++----
 arch/arm/configs/multi_v7_defconfig                |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c    | 13 ++--
 drivers/phy/phy-miphy365x.c                        | 29 ++++-----
 drivers/phy/phy-stih407-usb.c                      | 25 ++++----
 11 files changed, 143 insertions(+), 77 deletions(-)

-- 
1.9.1

