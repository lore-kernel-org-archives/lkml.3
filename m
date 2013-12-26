Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3LZWhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 17:37:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49585 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3LZWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 17:37:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] usb patches for v3.14 merge window
Date: Thu, 26 Dec 2013 16:36:59 -0600
Message-ID: <1388097419-24041-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my overly extensive pull request for v3.14 merge window. Lots
of work has happened for next merge window.

All patches have been tested with all ARM defconfigs, i386_defconfig,
kvm_guest.config, x86_64_defconfig, plus quite a few randconfigs.

All latest 0-DAY reports have been fixed already a few days back.

I have test-merged this on top of your usb-next and no conflicts showed
up.

Please, consider merging.

Happy New Year

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-for-v3.14

for you to fetch changes up to 836a2164491b19dcd4f29d574e548bcadd421a6a:

  usb: phy: keystone: remove redundant return value check of platform_get_resource() (2013-12-26 10:19:01 -0600)

----------------------------------------------------------------
usb: changes for v3.14 merge window

This pull request is quite extensive, containing
105 non-merge commits. Because of that, we describe
the changes in sections below:

New drivers:
	- Keystone PHY driver and DWC3 Glue Layer
	- Aeroflex Gaisler GRUSBDC
	- Tahvo PHY driver for N770
	- JZ4740 MUSB gluer Layer
	- Broadcom PHY Driver

Important new features:
	- MUSB DSPS learned about suspend/resume
	- New quirk_ep_out_aligned_size flag added to struct usb_gadget
	- DWC3 initializes the new quirk flag so gadget drivers can use it.
	- AM335x PHY Driver learns about remote wakeup
	- Renesas USBHS now requests DMA Engine only once
	- s3c-hsotg is now re-used on Broadcom devices
	- USB PHY layer now makes sure to initialize the notifier for all
		drivers
	- omap-control learned about TI's new AM437x devices
	- few other usb gadget/function drivers learned about the new
		configfs-based binding.

Misc Fixes and Clean Ups:
	- Several sparse fixes all over the place
	- Removal of redundant of_match_ptr()
	- r-car gen2 phy now uses usb_add_phy_dev()
	- removal of DEFINE_PCI_DEVICE_TABLE() from a few drivers
	- conversion to clk_prepare/clk_unprepare on r8a66597-udc
	- some randconfig errors and build warnings were fixed
	- removal of unnecessary lock on dwc3-omap.c

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Aaro Koskinen (7):
      ARM: OMAP1: USB: move omap_usb_config to platform data
      usb: omap1: add extcon to platform data
      usb: omap1: OTG controller driver
      usb: omap1: Tahvo USB transceiver driver
      usb: phy: tahvo: fix smatch warnings
      usb: phy: isp1301-omap: fix smatch warnings
      usb: phy: fix some Kconfig descriptions

Andreas Larsson (1):
      usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC

Andrzej Pietrasiewicz (21):
      usb: gadget: composite: redirect setup requests
      usb: gadget: factor out alloc_ep_req
      usb: gadget: f_loopback: add configfs support
      usb: gadget: f_sourcesink: add configfs support
      usb: gadget: configfs: allow setting function instance's name
      usb: gadget: g_ffs: remove a reduntant gfs_ether_setup variable
      usb: gadget: g_ffs: convert to new interface of f_ecm
      usb: gadget: f_ecm: remove compatibility layer
      usb: gadget: g_ffs: convert to new interface of f_subset
      usb: gadget: f_subset: remove compatibility layer
      usb: gadget: g_ffs: convert to new interface of f_rndis
      usb: gadget: f_rndis: remove compatibility layer
      usb: gadget: rndis: merge u_rndis.ko with usb_f_rndis.ko
      usb: gadget: FunctionFS: Remove VLAIS usage from gadget code
      usb: gadget: FunctionFS: create utility file
      usb: gadget: FunctionFS: add devices management code
      usb: gadget: FunctionFS: convert to new function interface with backward compatibility
      usb: gadget: g_ffs: convert to new interface of f_fs
      usb: gadget: FunctionFS: Remove compatibility layer
      usb: gadget: FunctionFS: add configfs support
      usb: gadget: nokia: fix error recovery path for optional functions

Anton Tikhomirov (5):
      usb: phy: fsm: protect against multiple inclusions
      usb: phy: replace spinlock with mutex in OTG FSM
      usb: phy: move OTG FSM header
      usb: phy: Add OTG FSM configuration option
      usb: phy: Fix double lock in OTG FSM

Apelete Seketeli (2):
      usb: musb: add support for JZ4740 usb device controller
      usb: musb: fix setting JZ4740 gadget periphal mode on reset

Bin Liu (1):
      usb: musb: dsps: polling ID pin status only in otg mode

Dan Carpenter (1):
      usb: gadget: update some out of date comments

Daniel Mack (7):
      usb: musb: unconditionally save and restore the context on suspend
      usb: musb: call musb_port_suspend from musb_bus_suspend
      usb: musb: dsps: add {tx,rx}_mode to wrapper
      usb: musb: dsps: add support for suspend and resume
      usb: musb: finish suspend/reset work independently from musb_hub_control()
      usb: musb: fix prototype for musb_port_reset
      usb: musb: fix musb pointer acqusition in musb_host_finish_resume

David Cohen (3):
      usb: gadget: move bitflags to the end of usb_gadget struct
      usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
      usb: dwc3: set gadget's quirk ep_out_align_size

Du, ChangbinX (1):
      usb: gadget: should use u16 type variable to store MaxPower

Ezequiel Garcia (2):
      usb: musb: Rework USB and USB_GADGET dependency
      usb: musb: Remove usb_disable() check in module_init()

Fabio Estevam (1):
      usb: phy: phy-mxs-usb: Check the return value from clk_prepare_enable()

Felipe Balbi (10):
      usb: musb: dsps: implement ->set_mode()
      usb: musb: core: call musb_platform_set_mode() during probe
      usb: gadget: epautoconf: switch over to usb_endpoint_type()
      usb: phy: fsm: don't depend on indirect includes
      usb: dwc3: omap: remove unnecessary lock
      usb: gadget: f_fs: fix sparse warning
      Merge tag 'v3.13-rc4' into next
      usb: phy: am335x: fix randconfig errors
      Merge tag 'v3.13-rc5' into next
      usb: gadget: at91_udc: fix build warning

Geert Uytterhoeven (1):
      usb: gadget: remove superfluous name casts

George Cherian (3):
      usb: dwc3: dwc3-omap: return PROBE_DEFER if extcon is missing and found in dt
      usb: phy: am335x: Enable USB remote wakeup using PHY wakeup
      usb: phy: omap: Add omap-control Support for AM437x

Greg Kroah-Hartman (1):
      usb: gadget: fix up some comments about CONFIG_USB_DEBUG

Heikki Krogerus (1):
      usb: dwc3: fix the glue drivers using the nop phy

Jingoo Han (12):
      usb: dwc3: pci: remove DEFINE_PCI_DEVICE_TABLE macro
      usb: gadget: pch_udc: remove DEFINE_PCI_DEVICE_TABLE macro
      usb: gadget: amd5536udc: remove DEFINE_PCI_DEVICE_TABLE macro
      usb: gadget: atmel_usba: Use devm_*() functions
      usb: gadget: atmel_usba: Fix sparse warning
      usb: gadget: f_loopback: Fix sparse warning
      usb: gadget: f_mass_storage: Fix sparse warning
      usb: gadget: f_ncm: Fix sparse warning
      usb: gadget: f_obex: Fix sparse warning
      usb: gadget: f_phonet: Fix sparse warning
      usb: gadget: f_serial: Fix sparse warning
      usb: gadget: f_sourcesink: Fix sparse warning

Kuninori Morimoto (1):
      usb: renesas_usbhs: fifo: request DMAEngine once

Laurent Pinchart (1):
      usb: gadget: r8a66597-udc: convert to clk_prepare/unprepare

Lee Jones (1):
      usb: musb: ux500_dma: fix potential NULL dereference error

Matt Porter (8):
      phy: add phy_get_bus_width()/phy_set_bus_width() calls
      staging: dwc2: update DT binding to add generic clock/phy properties
      usb: gadget: s3c-hsotg: enable build for other platforms
      usb: gadget: s3c-hsotg: add snps,dwc2 compatible string
      usb: gadget: s3c-hsotg: enable generic phy support
      usb: gadget: s3c-hsotg: get phy bus width from phy subsystem
      phy: add Broadcom Kona USB2 PHY DT binding
      phy: add Broadcom Kona USB2 PHY driver

Michal Nazarewicz (3):
      usb: gadget: goku: remove unused argument
      usb: gadget: f_fs: remove loop from I/O function
      usb: f_fs: check quirk to pad epout buf size when not aligned to maxpacketsize

Neil Zhang (1):
      usb: phy: initialize the notifier when add a new phy

Rashika Kheria (2):
      usb: gadget: configfs: include appropriate header file in configfs.c
      usb: phy: am335x-control: include appropriate header file in phy-am335x-control.c

Robert Baldyga (3):
      usb: gadget: s3c-hsotg: fix maxpacket size in s3c_hsotg_irq_enumdone
      usb: gadget: s3c-hsotg: add flush TX FIFO when kill all requests
      usb: gadget: add "maxpacket_limit" field to struct usb_ep

Sachin Kamat (3):
      usb: phy-keystone: Remove redundant of_match_ptr helper
      usb: phy-fsm: Staticize local symbols
      usb: phy-twl6030: Add missing braces

Valentine Barshak (1):
      usb: phy: r-car gen2: use usb_add_phy_dev

Wei Yongjun (1):
      usb: phy: keystone: remove redundant return value check of platform_get_resource()

WingMan Kwok (2):
      usb: dwc3: add Keystone specific glue layer
      usb: phy: add Keystone usb phy driver

 Documentation/ABI/testing/configfs-usb-gadget-ffs  |    9 +
 .../ABI/testing/configfs-usb-gadget-loopback       |    8 +
 .../ABI/testing/configfs-usb-gadget-sourcesink     |   12 +
 Documentation/ABI/testing/sysfs-platform-tahvo-usb |   16 +
 Documentation/devicetree/bindings/phy/bcm-phy.txt  |   15 +
 Documentation/devicetree/bindings/staging/dwc2.txt |   12 +
 Documentation/devicetree/bindings/usb/gr-udc.txt   |   28 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |    2 +
 arch/arm/mach-omap1/include/mach/usb.h             |   38 +-
 drivers/phy/Kconfig                                |    6 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-bcm-kona-usb2.c                    |  158 ++
 drivers/usb/Kconfig                                |    4 +-
 drivers/usb/chipidea/udc.c                         |    4 +-
 drivers/usb/dwc3/Kconfig                           |    7 +
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-exynos.c                     |    1 +
 drivers/usb/dwc3/dwc3-keystone.c                   |  202 ++
 drivers/usb/dwc3/dwc3-omap.c                       |   12 +-
 drivers/usb/dwc3/dwc3-pci.c                        |    3 +-
 drivers/usb/dwc3/gadget.c                          |   10 +-
 drivers/usb/gadget/Kconfig                         |   54 +-
 drivers/usb/gadget/Makefile                        |    9 +-
 drivers/usb/gadget/acm_ms.c                        |    2 +-
 drivers/usb/gadget/amd5536udc.c                    |   17 +-
 drivers/usb/gadget/at91_udc.c                      |   16 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   71 +-
 drivers/usb/gadget/bcm63xx_udc.c                   |    4 +-
 drivers/usb/gadget/composite.c                     |   18 +-
 drivers/usb/gadget/configfs.c                      |    8 +
 drivers/usb/gadget/dummy_hcd.c                     |    2 +-
 drivers/usb/gadget/epautoconf.c                    |    8 +-
 drivers/usb/gadget/f_ecm.c                         |   73 +-
 drivers/usb/gadget/f_fs.c                          | 1012 +++++----
 drivers/usb/gadget/f_hid.c                         |   18 +-
 drivers/usb/gadget/f_loopback.c                    |  144 +-
 drivers/usb/gadget/f_midi.c                        |   22 +-
 drivers/usb/gadget/f_ncm.c                         |    2 +-
 drivers/usb/gadget/f_obex.c                        |    2 +-
 drivers/usb/gadget/f_phonet.c                      |    2 +-
 drivers/usb/gadget/f_rndis.c                       |   94 +-
 drivers/usb/gadget/f_serial.c                      |    2 +-
 drivers/usb/gadget/f_sourcesink.c                  |  349 ++-
 drivers/usb/gadget/f_subset.c                      |   60 +-
 drivers/usb/gadget/fotg210-udc.c                   |    3 +-
 drivers/usb/gadget/fsl_qe_udc.c                    |    4 +-
 drivers/usb/gadget/fsl_udc_core.c                  |    7 +-
 drivers/usb/gadget/fusb300_udc.c                   |    4 +-
 drivers/usb/gadget/g_ffs.c                         |  466 ++--
 drivers/usb/gadget/g_zero.h                        |   24 +-
 drivers/usb/gadget/goku_udc.c                      |   16 +-
 drivers/usb/gadget/gr_udc.c                        | 2242 ++++++++++++++++++++
 drivers/usb/gadget/gr_udc.h                        |  220 ++
 drivers/usb/gadget/lpc32xx_udc.c                   |    2 +-
 drivers/usb/gadget/m66592-udc.c                    |    4 +-
 drivers/usb/gadget/multi.c                         |    2 +-
 drivers/usb/gadget/mv_u3d_core.c                   |    4 +-
 drivers/usb/gadget/mv_udc_core.c                   |    4 +-
 drivers/usb/gadget/net2272.c                       |    4 +-
 drivers/usb/gadget/net2280.c                       |    8 +-
 drivers/usb/gadget/nokia.c                         |    6 +-
 drivers/usb/gadget/omap_udc.c                      |    3 +-
 drivers/usb/gadget/pch_udc.c                       |    8 +-
 drivers/usb/gadget/pxa25x_udc.c                    |    1 +
 drivers/usb/gadget/pxa27x_udc.c                    |    5 +-
 drivers/usb/gadget/r8a66597-udc.c                  |   10 +-
 drivers/usb/gadget/rndis.c                         |    7 +-
 drivers/usb/gadget/s3c-hsotg.c                     |   81 +-
 drivers/usb/gadget/s3c-hsotg.h                     |    1 +
 drivers/usb/gadget/s3c-hsudc.c                     |    2 +-
 drivers/usb/gadget/s3c2410_udc.c                   |    1 +
 drivers/usb/gadget/u_ether.c                       |    2 +-
 drivers/usb/gadget/u_ether.h                       |   43 +-
 drivers/usb/gadget/u_f.c                           |   32 +
 drivers/usb/gadget/u_f.h                           |   26 +
 drivers/usb/gadget/u_fs.h                          |  267 +++
 drivers/usb/gadget/u_rndis.h                       |    2 +
 drivers/usb/gadget/zero.c                          |    8 +-
 drivers/usb/musb/Kconfig                           |   16 +-
 drivers/usb/musb/Makefile                          |    1 +
 drivers/usb/musb/jz4740.c                          |  201 ++
 drivers/usb/musb/musb_core.c                       |   67 +-
 drivers/usb/musb/musb_core.h                       |    3 +
 drivers/usb/musb/musb_dsps.c                       |  117 +-
 drivers/usb/musb/musb_gadget.c                     |   16 +-
 drivers/usb/musb/musb_host.c                       |    9 +-
 drivers/usb/musb/musb_host.h                       |    6 +
 drivers/usb/musb/musb_virthub.c                    |   69 +-
 drivers/usb/musb/ux500_dma.c                       |    4 +-
 drivers/usb/phy/Kconfig                            |   52 +-
 drivers/usb/phy/Makefile                           |    7 +-
 drivers/usb/phy/phy-ab8500-usb.c                   |    2 -
 drivers/usb/phy/phy-am335x-control.c               |    6 +-
 drivers/usb/phy/phy-am335x.c                       |   39 +-
 drivers/usb/phy/phy-fsl-usb.c                      |    7 +-
 drivers/usb/phy/phy-fsl-usb.h                      |    2 +-
 drivers/usb/phy/phy-fsm-usb.c                      |   14 +-
 drivers/usb/phy/phy-generic.c                      |    1 -
 drivers/usb/phy/phy-gpio-vbus-usb.c                |    2 -
 drivers/usb/phy/phy-isp1301-omap.c                 |    9 +-
 drivers/usb/phy/phy-keystone.c                     |  136 ++
 drivers/usb/phy/phy-mxs-usb.c                      |   13 +-
 drivers/usb/phy/phy-omap-control.c                 |   19 +
 drivers/usb/phy/phy-omap-otg.c                     |  169 ++
 drivers/usb/phy/phy-rcar-gen2-usb.c                |    2 +-
 drivers/usb/phy/phy-tahvo.c                        |  457 ++++
 drivers/usb/phy/phy-twl6030-usb.c                  |    2 +-
 drivers/usb/phy/phy.c                              |    4 +
 drivers/usb/renesas_usbhs/fifo.c                   |   18 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |    4 +-
 include/linux/phy/phy.h                            |   28 +
 include/linux/platform_data/usb-omap1.h            |   53 +
 include/linux/usb/composite.h                      |    2 +
 include/linux/usb/functionfs.h                     |   30 -
 include/linux/usb/gadget.h                         |   58 +-
 include/linux/usb/musb.h                           |    3 +
 include/linux/usb/omap_control_usb.h               |    6 +
 .../phy-fsm-usb.h => include/linux/usb/otg-fsm.h   |   10 +-
 118 files changed, 6442 insertions(+), 1279 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-ffs
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-loopback
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-sourcesink
 create mode 100644 Documentation/ABI/testing/sysfs-platform-tahvo-usb
 create mode 100644 Documentation/devicetree/bindings/phy/bcm-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/gr-udc.txt
 create mode 100644 drivers/phy/phy-bcm-kona-usb2.c
 create mode 100644 drivers/usb/dwc3/dwc3-keystone.c
 create mode 100644 drivers/usb/gadget/gr_udc.c
 create mode 100644 drivers/usb/gadget/gr_udc.h
 create mode 100644 drivers/usb/gadget/u_f.c
 create mode 100644 drivers/usb/gadget/u_f.h
 create mode 100644 drivers/usb/gadget/u_fs.h
 create mode 100644 drivers/usb/musb/jz4740.c
 create mode 100644 drivers/usb/phy/phy-keystone.c
 create mode 100644 drivers/usb/phy/phy-omap-otg.c
 create mode 100644 drivers/usb/phy/phy-tahvo.c
 create mode 100644 include/linux/platform_data/usb-omap1.h
 rename drivers/usb/phy/phy-fsm-usb.h => include/linux/usb/otg-fsm.h (96%)
