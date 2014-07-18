Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876AbaGRRBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:01:51 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:38323 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaGRRBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:01:50 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 0/6] vf610: Add USB support
Date: Fri, 18 Jul 2014 19:01:36 +0200
Message-Id: <cover.1405702442.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds USB support for Vybrid VF610 SoC. It extends the
clock framework to support the USB PHY cocks, extends the device
tree files and adds support for the non-core registers in the
usbmisc_imx driver.

This patchset needs the eSDHC length fix available in Shawn's
for-next branch.

The whole patchset proved to be working on a Colibri VF61. The
first USB controller runs in peripheral mode. I could successfully
use RNDIS, however with some stability issues: Suddenly the other
side was not reachable anymore and the interface needed to brought
down and back up again. I'm still investigating this.

The second USB controller, running in USB host mode, showed no
issues so far.

Stefan Agner (6):
  ARM: dts: vf610: add USB PHY and controller
  ARM: imx: clk-vf610: add USBPHY clocks
  ARM: dts: vf610: Add usbmisc for non-core registers
  chipidea: usbmisc_imx: Add USB support for VF610 SoCs
  usb: phy: mxs: Add VF610 USB PHY support
  ARM: dts: vf610-colibri: add USB support

 arch/arm/boot/dts/vf610-colibri.dts     | 10 +++++
 arch/arm/boot/dts/vf610.dtsi            | 55 ++++++++++++++++++++++--
 arch/arm/mach-imx/clk-vf610.c           | 12 +++++-
 drivers/usb/chipidea/usbmisc_imx.c      | 76 +++++++++++++++++++++++----------
 drivers/usb/phy/phy-mxs-usb.c           |  5 +++
 include/dt-bindings/clock/vf610-clock.h |  5 ++-
 6 files changed, 135 insertions(+), 28 deletions(-)

-- 
2.0.1

