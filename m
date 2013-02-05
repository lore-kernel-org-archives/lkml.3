Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3BEPYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:24:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54307 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3BEPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:24:30 -0500
Message-ID: <51112418.5020000@ti.com>
Date: Tue, 5 Feb 2013 20:54:08 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, <KISHON@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: [GIT PULL] ARM part of USB patches
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

As discussed, I'm sending a pull request for the arch/arm part of my USB 
patches. These patches are necessary to get MUSB functional in both dt 
and non-dt boot. Also added dt data for dwc3 present in OMAP. This patch 
series *depends* on some of the patches which are merged in usb-next.

Thanks
Kishon

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

   Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

   git://gitorious.org/linux-usb/linux-usb.git arm-usb-dt

for you to fetch changes up to 09084a48903c6056e20e27ae5054902958a10275:

   ARM: dts: omap5: add dwc3 core dt data (2013-02-05 20:11:46 +0530)

----------------------------------------------------------------
Kishon Vijay Abraham I (12):
       ARM: OMAP4: remove control module address space from PHY and OTG
       ARM: OMAP: devices: create device for usb part of control module
       ARM: OMAP2: MUSB: Specify omap4 has mailbox
       ARM: dts: omap: Add omap control usb data
       ARM: dts: omap: Add omap-usb2 dt data
       ARM: dts: omap: Add usb_otg and glue data
       ARM: OMAP: USB: Add phy binding information
       ARM: dts: omap5: Add omap control usb data
       ARM: dts: omap5: Add ocp2scp data
       ARM: dts: omap5: Add omap-usb3 and omap-usb2 dt data
       ARM: dts: omap5: add dwc3 omap dt data
       ARM: dts: omap5: add dwc3 core dt data

  Documentation/devicetree/bindings/usb/omap-usb.txt |    1 +
  arch/arm/boot/dts/omap3-beagle-xm.dts              |    6 ++++++
  arch/arm/boot/dts/omap3-evm.dts                    |    6 ++++++
  arch/arm/boot/dts/omap3-overo.dtsi                 |    6 ++++++
  arch/arm/boot/dts/omap3.dtsi                       |   12 ++++++++++++
  arch/arm/boot/dts/omap4-panda.dts                  |    6 ++++++
  arch/arm/boot/dts/omap4-sdp.dts                    |    6 ++++++
  arch/arm/boot/dts/omap4.dtsi                       |   26 
++++++++++++++++++++++++++
  arch/arm/boot/dts/omap5.dtsi                       |   48 
++++++++++++++++++++++++++++++++++++++++++++++++
  arch/arm/boot/dts/twl4030.dtsi                     |    2 +-
  arch/arm/mach-omap2/board-2430sdp.c                |    2 ++
  arch/arm/mach-omap2/board-3430sdp.c                |    2 ++
  arch/arm/mach-omap2/board-4430sdp.c                |    2 ++
  arch/arm/mach-omap2/board-cm-t35.c                 |    2 ++
  arch/arm/mach-omap2/board-devkit8000.c             |    2 ++
  arch/arm/mach-omap2/board-igep0020.c               |    2 ++
  arch/arm/mach-omap2/board-ldp.c                    |    2 ++
  arch/arm/mach-omap2/board-omap3beagle.c            |    2 ++
  arch/arm/mach-omap2/board-omap3evm.c               |    2 ++
  arch/arm/mach-omap2/board-omap3logic.c             |    2 ++
  arch/arm/mach-omap2/board-omap3pandora.c           |    2 ++
  arch/arm/mach-omap2/board-omap3stalker.c           |    2 ++
  arch/arm/mach-omap2/board-omap3touchbook.c         |    2 ++
  arch/arm/mach-omap2/board-omap4panda.c             |    2 ++
  arch/arm/mach-omap2/board-overo.c                  |    2 ++
  arch/arm/mach-omap2/board-rm680.c                  |    2 ++
  arch/arm/mach-omap2/board-zoom-peripherals.c       |    2 ++
  arch/arm/mach-omap2/devices.c                      |   45 
+++++++++++++++++++++++++++++++++++++++++++++
  arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   13 -------------
  arch/arm/mach-omap2/usb-musb.c                     |    3 +++
  include/linux/usb/musb.h                           |    2 ++
  31 files changed, 202 insertions(+), 14 deletions(-)
