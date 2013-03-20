Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab3CTPpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:45:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53848 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab3CTPpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:19 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 00/21] ARM: OMAP2+: Adapt to ehci-omap changes for 3.10
Date: Wed, 20 Mar 2013 17:44:39 +0200
Message-ID: <1363794300-31526-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

These patches provide the SoC side code required to support
the changes in the OMAP USB Host drivers done in [1], [2] & [3].

Device tree support is added for Beagleboard only. I've removed
Panda device tree support till we have resolved the AUXCLK issue.

NOTE: The first patch needs to be shared between the
OMAP tree and Felipe's USB tree.

v4:
- Some more cleanup to usbhs_init_phys(). Moved repeated code into
another helper function usbhs_add_regulator().
- Removed patch for Panda device tree support for USB host since
it is non functional.

v3:
- Moved more functionality into usbhs_init_phys().

v2:
- Added helper function usbhs_init_phys() that can be used by board files
to simplify adding of PHY regulators for USB host ports.

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

Roger Quadros (21):
  usb: phy: nop: Add some parameters to platform data
  ARM: OMAP2+: omap-usb-host: Add usbhs_init_phys()
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
  ARM: dts: OMAP3: Add HS USB Host IP nodes
  ARM: dts: omap3-beagle: Add USB Host support

 arch/arm/boot/dts/omap3-beagle.dts         |   71 ++++++++++++
 arch/arm/boot/dts/omap3.dtsi               |   31 ++++++
 arch/arm/boot/dts/omap4.dtsi               |   30 +++++
 arch/arm/mach-omap2/board-3430sdp.c        |   21 +++-
 arch/arm/mach-omap2/board-3630sdp.c        |   21 +++-
 arch/arm/mach-omap2/board-am3517crane.c    |   24 ++---
 arch/arm/mach-omap2/board-am3517evm.c      |   17 ++--
 arch/arm/mach-omap2/board-cm-t35.c         |   20 +++-
 arch/arm/mach-omap2/board-cm-t3517.c       |   20 +++-
 arch/arm/mach-omap2/board-devkit8000.c     |    8 --
 arch/arm/mach-omap2/board-igep0020.c       |   32 +++---
 arch/arm/mach-omap2/board-omap3beagle.c    |   32 ++++--
 arch/arm/mach-omap2/board-omap3evm.c       |   25 +++--
 arch/arm/mach-omap2/board-omap3pandora.c   |   21 ++--
 arch/arm/mach-omap2/board-omap3stalker.c   |   17 ++--
 arch/arm/mach-omap2/board-omap3touchbook.c |   17 ++--
 arch/arm/mach-omap2/board-omap4panda.c     |   55 ++++------
 arch/arm/mach-omap2/board-overo.c          |   16 ++-
 arch/arm/mach-omap2/board-zoom.c           |   16 ++-
 arch/arm/mach-omap2/usb-host.c             |  160 +++++++++++++++++++++++++++-
 arch/arm/mach-omap2/usb.h                  |    9 ++
 include/linux/usb/nop-usb-xceiv.h          |    5 +
 22 files changed, 508 insertions(+), 160 deletions(-)

-- 
1.7.4.1

