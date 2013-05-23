Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab3EWQPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:15:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210Ab3EWQO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:14:58 -0400
Date: Thu, 23 May 2013 09:14:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.10-rc3
Message-ID: <20130523161457.GA14414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.10-rc2

for you to fetch changes up to 2a0ebf80aa95cc758d4725f74a7016e992606a39:

  USB: cxacru: potential underflow in cxacru_cm_get_array() (2013-05-20 11:35:47 -0700)

----------------------------------------------------------------
USB fixes for 3.10-rc2

Here are a number of tiny USB bugfixes / new device ids for 3.10-rc2

The majority of these are USB gadget fixes, but they are all small.
Other than that, some USB host controller fixes, and USB serial driver
fixes for problems reported with them.

Also hopefully a fixed up USB_OTG Kconfig dependancy, that one seems to
be almost impossible to get right for all of the different platforms
these days.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (6):
      USB: xHCI: override bogus bulk wMaxPacketSize values
      USB: fix Kconfig logic for USB_UHCI_HCD
      USB: UHCI: fix for suspend of virtual HP controller
      USB: fix latency in uhci-hcd and ohci-hcd
      USB: OHCI: fix logic for scheduling isochronous URBs
      USB: remove remaining instances of USB_SUSPEND

Arnd Bergmann (1):
      USB: EHCI: remove bogus #error

Dan Carpenter (1):
      USB: cxacru: potential underflow in cxacru_cm_get_array()

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

David Rientjes (1):
      usb, chipidea: fix link error when USB_EHCI_HCD is a module

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-v3.10-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus

Jingoo Han (1):
      usb: gadget: s3c-hsotg: pass 'struct usb_request *' to usb_gadget_unmap_request()

Johan Hovold (7):
      USB: serial: add wait_until_sent operation
      USB: serial: add generic wait_until_sent implementation
      USB: ftdi_sio: clean up get_modem_status
      USB: ftdi_sio: fix chars_in_buffer overhead
      USB: io_ti: fix chars_in_buffer overhead
      USB: ti_usb_3410_5052: fix chars_in_buffer overhead
      USB: serial: clean up chars_in_buffer

Libo Chen (3):
      usb: ehci-s5p: fix memleak when fallback to pdata
      usb: isp1760-if: fix memleak when platform_get_resource fail
      usb: ohci: fix goto wrong tag in err case

Michael Grzeschik (1):
      usb: otg: mxs-phy: add missing type to usb_phy

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Paul Bolle (1):
      usb: phy: remove CONFIG_USB_OTG_UTILS once more

Robert Jarzmik (1):
      usb: phy: Fix NULL pointer exception during usb_get_phy

Robert P. J. Day (2):
      Correct typo "supperspeed" to "superspeed".
      Add a couple kernel-doc lines to prevent warnings.

Sachin Kamat (12):
      usb: gadget: atmel_usba_udc: Remove redundant platform_set_drvdata()
      usb: gadget: bcm63xx_udc: Remove redundant platform_set_drvdata()
      usb: gadget: dummy_hcd: Remove redundant platform_set_drvdata()
      usb: gadget: f_uac2: Remove redundant platform_set_drvdata()
      usb: gadget: imx_udc: Remove redundant platform_set_drvdata()
      usb: gadget: pxa25x_udc: Remove redundant platform_set_drvdata()
      usb: gadget: s3c2410_udc: Remove redundant platform_set_drvdata()
      usb: phy: ab8500-usb: Remove redundant platform_set_drvdata()
      usb: phy: gpio-vbus-usb: Remove redundant platform_set_drvdata()
      usb: phy: mv-usb: Remove redundant platform_set_drvdata()
      usb: phy: mxs-usb: Remove redundant platform_set_drvdata()
      usb: phy: nop: Remove redundant platform_set_drvdata()

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Stephen Warren (1):
      USB: set device dma_mask without reference to global data

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Vivek Gautam (1):
      usb: dwc3: Fix compilation break when building with USB_DWC3_DUAL_ROLE=y

Wei WANG (1):
      USB: usb-stor: realtek_cr: Fix compile error

Wei Yongjun (9):
      usb: gadget: zero: fix error return code in zero_bind()
      usb: musb: omap2430: add missing platform_device_put() on error in omap2430_probe()
      usb: musb: dsps: fix error return code in dsps_create_musb_pdev()
      usb: gadget: s3c2410_udc: fix error return code in s3c2410_udc_probe()
      usb: gadget: r8a66597-udc: fix error return code in r8a66597_probe()
      usb: gadget: m66592-udc: fix error return code in m66592_probe()
      usb: gadget: fusb300_udc: fix error return code in fusb300_probe()
      usb: gadget: dummy_hcd: fix error return code in init()
      usb: gadget: fix error return code in configfs_composite_bind()

Wolfram Sang (2):
      usb: gadget: don't check resource with devm_ioremap_resource
      usb: phy: don't check resource with devm_ioremap_resource

 arch/arm/configs/omap1_defconfig      |  1 -
 arch/arm/configs/omap2plus_defconfig  |  1 -
 arch/mips/configs/db1000_defconfig    |  1 -
 arch/mips/configs/db1235_defconfig    |  1 -
 arch/mips/configs/lemote2f_defconfig  |  1 -
 arch/powerpc/configs/ps3_defconfig    |  1 -
 drivers/net/usb/usbnet.c              |  2 +-
 drivers/staging/dwc2/Kconfig          |  1 -
 drivers/staging/gdm72xx/Kconfig       |  2 +-
 drivers/usb/atm/cxacru.c              |  3 ++-
 drivers/usb/chipidea/Kconfig          |  2 +-
 drivers/usb/chipidea/ci13xxx_imx.c    | 15 +++---------
 drivers/usb/core/Kconfig              |  2 +-
 drivers/usb/core/quirks.c             |  3 +++
 drivers/usb/dwc3/Kconfig              |  6 ++---
 drivers/usb/dwc3/dwc3-exynos.c        |  6 ++---
 drivers/usb/gadget/Kconfig            |  1 -
 drivers/usb/gadget/atmel_usba_udc.c   |  2 --
 drivers/usb/gadget/bcm63xx_udc.c      | 11 ---------
 drivers/usb/gadget/configfs.c         |  8 ++++--
 drivers/usb/gadget/dummy_hcd.c        |  5 ++--
 drivers/usb/gadget/f_ecm.c            |  1 +
 drivers/usb/gadget/f_subset.c         |  1 +
 drivers/usb/gadget/f_uac2.c           |  2 --
 drivers/usb/gadget/fusb300_udc.c      |  4 ++-
 drivers/usb/gadget/imx_udc.c          |  2 --
 drivers/usb/gadget/m66592-udc.c       |  4 ++-
 drivers/usb/gadget/pxa25x_udc.c       |  1 -
 drivers/usb/gadget/r8a66597-udc.c     |  4 ++-
 drivers/usb/gadget/s3c-hsotg.c        |  2 +-
 drivers/usb/gadget/s3c2410_udc.c      |  3 +--
 drivers/usb/gadget/zero.c             |  8 ++++--
 drivers/usb/host/Kconfig              | 17 ++++---------
 drivers/usb/host/ehci-atmel.c         |  6 ++---
 drivers/usb/host/ehci-hcd.c           | 17 -------------
 drivers/usb/host/ehci-omap.c          |  8 +++---
 drivers/usb/host/ehci-orion.c         |  6 ++---
 drivers/usb/host/ehci-s5p.c           |  5 ++--
 drivers/usb/host/ehci-spear.c         |  6 ++---
 drivers/usb/host/ehci-tegra.c         |  6 ++---
 drivers/usb/host/isp1760-hcd.c        |  2 +-
 drivers/usb/host/isp1760-if.c         |  4 ++-
 drivers/usb/host/ohci-at91.c          |  6 ++---
 drivers/usb/host/ohci-exynos.c        |  4 +--
 drivers/usb/host/ohci-hcd.c           | 34 ++++++++++++++------------
 drivers/usb/host/ohci-nxp.c           | 46 +++++++++++++++++------------------
 drivers/usb/host/ohci-omap3.c         |  8 +++---
 drivers/usb/host/ohci-pxa27x.c        |  6 ++---
 drivers/usb/host/ohci-spear.c         |  6 ++---
 drivers/usb/host/oxu210hp-hcd.c       |  2 +-
 drivers/usb/host/sl811-hcd.c          |  2 +-
 drivers/usb/host/uhci-hub.c           |  3 ++-
 drivers/usb/host/uhci-platform.c      |  6 ++---
 drivers/usb/host/uhci-q.c             |  2 +-
 drivers/usb/host/xhci-mem.c           | 17 +++++++------
 drivers/usb/musb/musb_dsps.c          |  1 +
 drivers/usb/musb/omap2430.c           |  3 ++-
 drivers/usb/phy/Kconfig               |  5 ++--
 drivers/usb/phy/phy-ab8500-usb.c      |  2 --
 drivers/usb/phy/phy-fsl-usb.c         |  1 +
 drivers/usb/phy/phy-gpio-vbus-usb.c   |  3 +--
 drivers/usb/phy/phy-isp1301.c         |  1 +
 drivers/usb/phy/phy-mv-u3d-usb.c      |  5 ----
 drivers/usb/phy/phy-mv-usb.c          |  3 ---
 drivers/usb/phy/phy-mxs-usb.c         |  8 +-----
 drivers/usb/phy/phy-nop.c             |  2 --
 drivers/usb/phy/phy-samsung-usb2.c    |  5 ----
 drivers/usb/phy/phy-samsung-usb3.c    |  5 ----
 drivers/usb/serial/ftdi_sio.c         | 30 +++++++++--------------
 drivers/usb/serial/ftdi_sio_ids.h     |  2 ++
 drivers/usb/serial/generic.c          | 31 +++++++++++++++++++++++
 drivers/usb/serial/io_ti.c            | 22 +++++++++++------
 drivers/usb/serial/option.c           | 13 +++++++---
 drivers/usb/serial/ti_usb_3410_5052.c | 23 ++++++++++++------
 drivers/usb/serial/usb-serial.c       | 30 ++++++++++++++++-------
 drivers/usb/storage/realtek_cr.c      |  8 +++---
 include/linux/usb/gadget.h            |  5 ++--
 include/linux/usb/serial.h            |  4 +++
 78 files changed, 269 insertions(+), 269 deletions(-)
