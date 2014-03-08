Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaCHAcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:32:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58408 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaCHAcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:32:20 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB patches for v3.15
Date: Fri, 7 Mar 2014 18:30:45 -0600
Message-ID: <1394238645-26796-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my pull request for v3.15 merge window.

This pull request contains patches which have been soaking in linux-next for
quite a bit of time. I also ran everything through my 150 randconfigs script
(which uses some seeds of my own).

Please, consider merging it on top of your greg/usb-next branch.

Note that this pull request is based off of an old commit on your usb-next
branch because I was out for a while on vacations and wanted to avoid
duplicated commits.

cheers


The following changes since commit 6d36b6f313738e99fc8b903697f8ecf06add29aa:

  phy-core: Don't allow building phy-core as a module (2014-02-15 12:28:39 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-for-v3.15

for you to fetch changes up to 4b76e14d95f7b69e71eabc002dcb0dcb9ebb5340:

  phy: ti-pipe3: Add SATA compatible to Documentation binding (2014-03-07 10:03:47 -0600)

----------------------------------------------------------------
usb: patches for v3.15

another substantial pull request with new features all over
the place.

dwc3 got a bit closer towards hibernation support with after
a few patches re-factoring code to be reused for hibernation.
Also in dwc3 two new workarounds for known silicon bugs have
been implemented, some randconfig build errors have been fixed,
and it was taught about the new generic phy layer.

MUSB on AM335x now supports isochronous transfers thanks to
George Cherian's work.

The atmel_usba driver got two crash fixes: one when no endpoint
was specified in DeviceTree data and another when stopping the UDC
in DEBUG builds.

Function FS got a much needed fix to ffs_epfile_io() which was
copying too much data to userspace in some cases.

The printer gadget got a fix for a possible deadlock and plugged
a memory leak.

Ethernet drivers now use NAPI for RX which gives improved throughput.

Other than that, the usual miscelaneous fixes, cleanups, and
the like.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Alexandre Belloni (1):
      usb: gadget: atmel_usba: fix crash when no endpoint are specified

Andrzej Pietrasiewicz (4):
      usb: gadget: FunctionFS: dereference ffs_dev conditionally
      usb: gadget: code cleanup
      usb: gadget: FunctionFS: staticize functions used only in f_fs.c
      usb: gadget: FunctionFS: use consistent naming with regard to ffs_lock

Bo Shen (2):
      usb: gadget: at91: fix the number of endpoint parameter
      usb: gadget: at91: using USBA_NR_DMAS for DMA channels

Chuansheng Liu (1):
      usb: gadget: return the right length in ffs_epfile_io()

Dan Carpenter (3):
      usb: gadget: gr_udc: remove some unneeded error handling
      usb: dwc3: gadget: cut and paste fixups in suspend/resume
      usb: dwc3: gadget: remove known conditions

Felipe Balbi (15):
      usb: musb: avoid NULL pointer dereference
      usb: dwc3: gadget: always enable IOC on bulk/interrupt transfers
      usb: dwc3: core: define bit 10 of GCTL register
      usb: dwc3: workaround: clock gating issues
      usb: dwc3: workaround: bogus hibernation events
      usb: dwc3: cleanup struct dwc3
      usb: dwc3: add has_hibernation flag
      usb: dwc3: core: allocate scratch buffers
      usb: dwc3: core: fix indentation
      usb: dwc3: gadget: set KEEP_CONNECT in case of hibernation
      usb: dwc3: gadget: make sure HIRD threshold is 0 in superspeed
      usb: dwc3: gadget: call gadget driver's ->suspend/->resume
      usb: dwc3: gadget: pre-start Stream transfers when they're queued
      usb: dwc3: fix randconfig build errors
      usb: dwc3: define more revisions

Geert Uytterhoeven (1):
      usb: musb: USB_MUSB_DUAL_ROLE/USB_MUSB_GADGET should depend on HAS_DMA

George Cherian (4):
      usb: musb: musb_host: Enable ISOCH IN handling for AM335x host
      usb: musb: musb_cppi41: Make CPPI aware of high bandwidth transfers
      usb: musb: musb_cppi41: Handle ISOCH differently and not use the hrtimer.
      usb: musb: musb_cppi41: Dont reprogram DMA if tear down is initiated

Gregory CLEMENT (1):
      usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

Jingoo Han (1):
      usb: gadget: s3c-hsotg: use %pad for dma_addr_t

Julia Lawall (1):
      usb: gadget: fix error return code

Kishon Vijay Abraham I (3):
      Documentation: dt bindings: move ..usb/usb-phy.txt to ..phy/ti-phy.txt
      usb: dwc3: core: support optional PHYs
      usb: dwc3: adapt dwc3 core to use Generic PHY Framework

Li Jun (1):
      usb: phy: fsm: update OTG HNP state transition conditions according to OTG and EH 2.0 spec.

Manu Gautam (1):
      usb: gadget: f_fs: Add support for SuperSpeed Mode

Marek Szyprowski (1):
      usb: gadget: s3c-hsotg: add proper suspend/resume support

Markus Pargmann (2):
      usb: musb: dsps, use devm_kzalloc
      usb: musb: dsps, debugfs files

Matt Porter (1):
      usb: gadget: s3c-hsotg: fix build on x86 and other architectures

Michal Nazarewicz (3):
      usb: gadget: functionfs: fix typo in the enum variable
      usb: gadget: functionfs: replace FFS_SETUP_STATUS with an inline function
      usb: gadget: f_fs: Add flags to descriptors block

Paul Zimmerman (4):
      usb: dwc3: add 'saved_state' field to dwc3_ep structure
      usb: dwc3: gadget: implement dwc3_gadget_get_link_state
      usb: dwc3: gadget: add a 'restore' argument to set_ep_config
      usb: dwc3: gadget: add 'force' argument to stop_active_transfer

Peter Chen (12):
      usb: doc: phy-mxs: Add more compatible strings
      usb: phy: mxs: Add platform judgement code
      usb: phy: mxs: Add auto clock and power setting
      usb: doc: phy-mxs: update binding for adding anatop phandle
      usb: phy: mxs: Add anatop regmap
      usb: phy: mxs: change description of usb device speed
      usb: phy: mxs: Enable IC fixes for related SoCs
      usb: phy: mxs: add controller id
      usb: phy: Add set_wakeup API
      usb: phy: mxs: Add implementation of set_wakeup
      usb: phy: mxs: Add system suspend/resume API
      usb: phy: mxs: Add sync time after controller clear phcd

Robert Baldyga (5):
      usb: gadget: s3c-hsotg: stall ep0 in set_halt function
      usb: gadget: f_fs: fix setup request handling
      usb: gadget: f_fs: add poll for endpoint 0
      usb: gadget: f_fs: add aio support
      usb: gadget: at91_udc: fix ep maxpacket initialisation

Roger Quadros (4):
      phy: omap-control: Update DT binding information
      phy: omap-control: update dra7 and am437 usb2 Documentation bindings
      phy: ti-pipe3: Add clocks to PIPE3 PHY Documentation binding
      phy: ti-pipe3: Add SATA compatible to Documentation binding

Sachin Kamat (2):
      usb: gadget: s3c2410_udc: Fix build error
      usb: gadget: s3c-hsudc: remove unused label

Sergei Shtylyov (1):
      usb: phy: rcar-gen2-usb: always use 'dev' variable in probe() method

Weinn Jheng (1):
      usb: gadget: u_ether: move hardware transmit to RX NAPI

Wolfram Sang (1):
      usb: dwc3: omap: don't check resource with devm_ioremap_resource

wenlin.kang (2):
      usb: gadget: printer: fix possible deadlock
      usb: gadget: printer: fix memory leak

 Documentation/devicetree/bindings/phy/ti-phy.txt   |  86 +++
 Documentation/devicetree/bindings/usb/dwc3.txt     |   6 +-
 Documentation/devicetree/bindings/usb/mxs-phy.txt  |   8 +-
 Documentation/devicetree/bindings/usb/omap-usb.txt |  24 -
 Documentation/devicetree/bindings/usb/usb-phy.txt  |  48 --
 drivers/usb/dwc3/core.c                            | 251 ++++++++-
 drivers/usb/dwc3/core.h                            | 105 +++-
 drivers/usb/dwc3/dwc3-omap.c                       |   5 -
 drivers/usb/dwc3/gadget.c                          | 183 ++++--
 drivers/usb/dwc3/gadget.h                          |  12 -
 drivers/usb/gadget/Kconfig                         |   1 -
 drivers/usb/gadget/at91_udc.c                      |  14 +-
 drivers/usb/gadget/atmel_usba_udc.c                |  16 +-
 drivers/usb/gadget/atmel_usba_udc.h                |   2 +-
 drivers/usb/gadget/f_fs.c                          | 612 ++++++++++++++++-----
 drivers/usb/gadget/gr_udc.c                        |  10 +-
 drivers/usb/gadget/printer.c                       |   8 +-
 drivers/usb/gadget/s3c-hsotg.c                     | 143 +++--
 drivers/usb/gadget/s3c-hsudc.c                     |   1 -
 drivers/usb/gadget/s3c2410_udc.c                   |   2 +-
 drivers/usb/gadget/u_ether.c                       | 101 ++--
 drivers/usb/gadget/u_fs.h                          |  30 +-
 drivers/usb/musb/Kconfig                           |   2 +
 drivers/usb/musb/musb_core.c                       |   5 +-
 drivers/usb/musb/musb_cppi41.c                     |  69 ++-
 drivers/usb/musb/musb_dsps.c                       |  58 +-
 drivers/usb/musb/musb_host.c                       |  30 +-
 drivers/usb/phy/phy-fsm-usb.c                      |   9 +-
 drivers/usb/phy/phy-mxs-usb.c                      | 310 ++++++++++-
 drivers/usb/phy/phy-rcar-gen2-usb.c                |   6 +-
 include/linux/usb/phy.h                            |  16 +
 include/uapi/linux/usb/functionfs.h                |  44 +-
 32 files changed, 1740 insertions(+), 477 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/ti-phy.txt
 delete mode 100644 Documentation/devicetree/bindings/usb/usb-phy.txt
