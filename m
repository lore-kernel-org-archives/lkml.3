Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3AUOJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:09:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37262 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab3AUOJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:09:10 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v2 0/4] usb: musb: add driver for control module
Date: Mon, 21 Jan 2013 19:38:24 +0530
Message-ID: <1358777308-2409-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new driver for the usb part of control module. This has an API
to power on the USB2 phy and an API to write to the mailbox depending on
whether MUSB has to act in host mode or in device mode.

Writing to control module registers for doing the above task which was
previously done in omap glue and in omap-usb2 phy is removed.

Changes from v1:
* renamed get_omap_control_dev to omap_get_control_dev

* created and exported a single API (omap_control_usb_set_mode) to change
  the usb mode

* Before writing to the otghs_control regster, the value from
  otghs_control regster is read and only the appropriate bits are set.

* In omap_init_control_usb, the indentation is now reduced as per Felipe's
  suggestion.

Changes from RFC:
* Used "#if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)" instead of 
  "#if (defined(CONFIG_OMAP_CONTROL_USB) || \
				defined(CONFIG_OMAP_CONTROL_USB_MODULE))"

* return "-EADDRNOTAVAIL" if devm_request_and_ioremap fails.

* Removed the dt data from this patch series (I'll send that as a separate
series).

* added "ctrl_module" binding to usb otg glue and usb phy in the Documentaion.
  This binding is not planned to be used until an actual requirement for
  it arises.

This series was developed on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv

Did basic enumeration testing in omap4 panda and omap3 beagle.

Kishon Vijay Abraham I (4):
  drivers: usb: phy: add a new driver for usb part of control module
  ARM: OMAP: devices: create device for usb part of control module
  ARM: OMAP2: MUSB: Specify omap4 has mailbox
  drivers: usb: start using the control module driver

 Documentation/devicetree/bindings/usb/omap-usb.txt |   30 ++-
 Documentation/devicetree/bindings/usb/usb-phy.txt  |   12 +-
 arch/arm/mach-omap2/devices.c                      |   45 ++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   13 --
 arch/arm/mach-omap2/usb-musb.c                     |    3 +
 drivers/usb/musb/Kconfig                           |    1 +
 drivers/usb/musb/omap2430.c                        |   64 ++----
 drivers/usb/musb/omap2430.h                        |    9 -
 drivers/usb/phy/Kconfig                            |   10 +
 drivers/usb/phy/Makefile                           |    1 +
 drivers/usb/phy/omap-control-usb.c                 |  238 ++++++++++++++++++++
 drivers/usb/phy/omap-usb2.c                        |   38 +---
 include/linux/usb/musb.h                           |    2 +
 include/linux/usb/omap_control_usb.h               |   71 ++++++
 include/linux/usb/omap_usb.h                       |    4 +-
 15 files changed, 439 insertions(+), 102 deletions(-)
 create mode 100644 drivers/usb/phy/omap-control-usb.c
 create mode 100644 include/linux/usb/omap_control_usb.h

-- 
1.7.9.5

