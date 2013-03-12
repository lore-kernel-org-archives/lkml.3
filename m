Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab3CLLnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:43:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44440 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3CLLnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:43:39 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 00/24] ARM: OMAP2+: Adapt to ehci-omap changes for 3.10
Date: Tue, 12 Mar 2013 13:43:02 +0200
Message-ID: <1363088606-2692-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

These patches provide the SoC side code required to support
the changes in the OMAP USB Host drivers done in [1], [2] & [3].

Device tree support is added for Beagleboard and Panda.

NOTE: The first patch needs to be shared between the
OMAP tree and Felipe's USB tree.

[1] MFD side changes to omap-usb-host and omap-usb-tll
  https://lkml.org/lkml/2013/3/12/179
[2] USB EHCI side changes to ehci-omap 
  http://www.mail-archive.com/linux-omap@vger.kernel.org/msg86265.html
[3] USB PHY driver changes
  http://www.mail-archive.com/linux-omap@vger.kernel.org/msg86293.html

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost-arm-next

Roger Quadros (24):
  usb: phy: nop: Add some parameters to platform data
  ARM: OMAP2+: omap4panda: Provide USB Host's PHY platform data
  ARM: OMAP2+: omap4panda: Adapt to ehci-omap changes
  ARM: OMAP3: Beagle: Adapt to ehci-omap changes
  ARM: OMAP3: 3430SDP: Adapt to ehci-omap changes
  ARM: OMAP3: 3630SDP: Adapt to ehci-omap changes
  ARM: OMAP: AM3517crane: Adapt to ehci-omap changes
  ARM: OMAP: AM3517evm: Adapt to ehci-omap changes
  ARM: OMAP3: cm-t35: Adapt to ehci-omap changes
  ARM: OMAP3: cm-t3517: Adapt to ehci-omap changes
  ARM: OMAP: devkit8000: Adapt to ehci-omap changes
  ARM: OMAP3: igep0020: Adapt to ehci-omap changes
  ARM: OMAP3: omap3evm: Adapt to ehci-omap changes
  ARM: OMAP3: omap3pandora: Adapt to ehci-omap changes
  ARM: OMAP3: omap3stalker: Adapt to ehci-omap changes
  ARM: OMAP3: omap3touchbook: Adapt to ehci-omap changes
  ARM: OMAP3: overo: Adapt to ehci-omap changes
  ARM: OMAP: zoom: Adapt to ehci-omap changes
  ARM: dts: OMAP4: Add HS USB Host IP nodes
  ARM: dts: omap4-panda: Add USB Host support
  ARM: dts: OMAP3: Add HS USB Host IP nodes
  ARM: dts: omap3-beagle: Add USB Host support
  ARM: OMAP2+: Allow clock alias provision from device tree
  ARM: dts: omap4-panda: Add clock alias for USB PHY

 .../devicetree/bindings/clock/ti-clock-alias.txt   |   26 ++++
 arch/arm/boot/dts/omap3-beagle.dts                 |   71 +++++++++++
 arch/arm/boot/dts/omap3.dtsi                       |   31 +++++
 arch/arm/boot/dts/omap4-panda.dts                  |   63 ++++++++++
 arch/arm/boot/dts/omap4.dtsi                       |   30 +++++
 arch/arm/mach-omap2/board-3430sdp.c                |   97 +++++++++++++++-
 arch/arm/mach-omap2/board-3630sdp.c                |  100 +++++++++++++++-
 arch/arm/mach-omap2/board-am3517crane.c            |   95 +++++++++++++--
 arch/arm/mach-omap2/board-am3517evm.c              |   66 ++++++++++-
 arch/arm/mach-omap2/board-cm-t35.c                 |   95 ++++++++++++++-
 arch/arm/mach-omap2/board-cm-t3517.c               |   97 +++++++++++++++-
 arch/arm/mach-omap2/board-devkit8000.c             |   20 ++--
 arch/arm/mach-omap2/board-generic.c                |   67 +++++++++++
 arch/arm/mach-omap2/board-igep0020.c               |  112 ++++++++++++++++---
 arch/arm/mach-omap2/board-omap3beagle.c            |   93 +++++++++++++--
 arch/arm/mach-omap2/board-omap3evm.c               |   62 ++++++++--
 arch/arm/mach-omap2/board-omap3pandora.c           |   52 +++++++--
 arch/arm/mach-omap2/board-omap3stalker.c           |   52 +++++++-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   62 +++++++++-
 arch/arm/mach-omap2/board-omap4panda.c             |  122 ++++++++++++++------
 arch/arm/mach-omap2/board-overo.c                  |   54 ++++++++-
 arch/arm/mach-omap2/board-zoom.c                   |   56 ++++++++-
 include/linux/usb/nop-usb-xceiv.h                  |    5 +
 23 files changed, 1377 insertions(+), 151 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/ti-clock-alias.txt

--
cheers,
-roger 

