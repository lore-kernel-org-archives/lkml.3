Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaKYPRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:17:21 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50726 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaKYPRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:17:18 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB patches for v3.19 merge window
Date: Tue, 25 Nov 2014 09:17:30 -0600
Message-ID: <1416928650-20218-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's a giant pull request for v3.19. Patches have been
on linux-next for quite a while - most of them at least - and
I tested what I could - read, what I had HW for - on both
BeagleBoneBlack and AM437x SK. Some has also been tested with
BeagleBoard X15, but that's still not supported in mainline
(probably v3.19 as well).

Anyway, let me know if you want to change anything.

cheers

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-for-v3.19

for you to fetch changes up to ebf3992061db1f7b3aa093f37fb308acc74fbc82:

  usb: musb: Use IS_ENABLED for tusb6010 (2014-11-25 08:47:07 -0600)

----------------------------------------------------------------
usb: patches for v3.19 merge window

This time, a very pull request with 216 non-merge
commits. Most of the commits contained here are
sparse or coccinelle fixes ranging from missing
'static' to returning 0 in case of errors.

More importantly, we have the removal the now
unnecessary 'driver' argument to ->udc_stop().

DWC2 learned about Dual-Role builds. Users of
this IP can now have a single driver built for
host and device roles.

DWC3 got support for two new HW platforms: Exynos7
and AMD.

The Broadcom USB 3.0 Device Controller IP is now
supported and so is PLX USB338x, which means DWC3
has lost is badge as the only USB 3.0 peripheral
IP supported on Linux.

Thanks for Tony Lindgren's work, we can now have
a distro-like kernel where all MUSB glue layers
can be built into the same kernel (statically
or dynamically linked) and it'll work in PIO (DMA
will come probably on v3.20).

Other than these, the usual set of cleanups and
non-critical fixes.

Signed-off-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Alan Stern (3):
      usb: gadget: dummy-hcd: use udc-core's reset notifier
      usb: gadget: net2280: use udc-core's reset notifier
      usb: gadget: net2272: use udc-core's reset notifier

Andrzej Pietrasiewicz (17):
      usb: gadget: configfs: add suspend/resume
      usb: gadget: Kconfig: enable separate compilation of uac1/uac2 functions
      usb: gadget: f_midi: enable use of the index parameter
      usb: gadget: f_midi: check kstrdup() return value
      usb: gadget: f_midi: convert to new function interface with backward compatibility
      usb: gadget: midi: convert to new interface of f_midi
      usb: gadget: f_midi: remove compatibility layer
      usb: gadget: f_midi: use usb_gstrings_attach
      usb: gadget: f_midi: add configfs support
      usb: gadget: f_hid: check return value of class_create
      usb: gadget: f_hid: check return value of device_create
      usb: gadget: hid: mirror init operations in module cleanup
      usb: gadget: f_hid: convert to new function interface with backward compatibility
      usb: gadget: hid: convert to new interface of f_hid
      usb: gadget: f_hid: remove compatibility layer
      usb: gadget: f_hid: use usb_gstrings_attach
      usb: gadget: hid: add configfs support

Antoine Tenart (5):
      usb: move the OTG state from the USB PHY to the OTG structure
      usb: rename phy to usb_phy in OTG
      usb: add support to the generic PHY framework in OTG
      usb: allow to supply the PHY in the drivers when using HCD
      usb: chipidea: add support to the generic PHY framework

Arjun Sreedharan (1):
      usb: phy: propagate __of_usb_find_phy()'s error on failure

Ashwini Pahuja (1):
      usb: gadget: Add UDC driver for Broadcom USB3.0 device controller IP BDC

Bo Shen (2):
      usb: gadget: at91_udc: remove unused release function
      usb: gadget: atmel_usba_udc: remove release function

Dan Carpenter (3):
      usb: gadget: f_uac1: remove an unneeded NULL check
      usb: gadget: f_hid: use after free in hidg_alloc_inst()
      usb: gadget: f_hid: fix error handling in ghid_setup()

Dinh Nguyen (10):
      usb: dwc2: allow dwc2 to get built when USB_GADGET=m
      usb: dwc2: Update the gadget driver to use common dwc2_hsotg structure
      usb: dwc2: Move gadget probe function into platform code
      usb: dwc2: convert to use dev_pm_ops API
      usb: dwc2: Initialize the USB core for peripheral mode
      usb: dwc2: Update common interrupt handler to call gadget interrupt handler
      usb: dwc2: gadget: Do not fail probe if there isn't a clock node
      usb: dwc2: move usb_disabled() call to host driver only
      usb: dwc2: Update Kconfig to support dual-role
      usb: dwc2: remove early return on clock query

Fabio Estevam (1):
      usb: dwc2: Fix build warning when CONFIG_PM_SLEEP=n

Felipe Balbi (51):
      usb: dwc3: core: write LINUX_VERSION_CODE to our GUID register
      usb: dwc3: trace: remove unnecessary newline character
      usb: gadget: composite: introduce setup and os_desc pending flags
      usb: gadget: composite: set our req->context to cdev
      usb: gadget: composite: conditionally dequeue os_desc and setup requests
      usb: dwc3: ep0: trace ep0 TRBs too
      usb: dwc3: get rid of ->prepare()/->complete()
      usb: gadget: udc-core: call ->disconnect() when soft disconnecting
      usb: gadget: udc: document our sysfs ABI
      usb: dwc3: gadget: set state to NOT_ATTACHED on disconnect_irq
      usb: dwc3: gadget: WARN() on bogus usb_ep_queue()
      usb: gadget: udc: amd5536: do not rely on 'driver' argument
      usb: gadget: udc: at91: do not rely on 'driver' argument
      usb: gadget: udc: dummy: do not rely on 'driver' argument
      usb: gadget: udc: fsl_qe: do not rely on 'driver' argument
      usb: gadget: udc: lpc32xx: do not rely on 'driver' argument
      usb: gadget: udc: mv_u3d: do not rely on 'driver' argument
      usb: gadget: udc: mv_udc: do not rely on 'driver' argument
      usb: gadget: udc: net2272: do not rely on 'driver' argument
      usb: gadget: udc: net2280: do not rely on 'driver' argument
      usb: gadget: udc: pxa25x: do not rely on 'driver' argument
      usb: gadget: udc: pxa27x: do not rely on 'driver' argument
      usb: gadget: udc: s3c-hsudc: do not rely on 'driver' argument
      usb: musb: gadget: do not rely on 'driver' argument
      usb: gadget: udc: pass a single argument to usb_gadget_udc_start/stop
      usb: gadget: udc: at91: remove bind/unbind messages
      usb: gadget: udc: atmel_usba: remove bind/unbind messages
      usb: gadget: udc: dummy: remove bind/unbind messages
      usb: gadget: udc: fsl_qe: remove bind/unbind messages
      usb: gadget: udc: gr_udc: remove bind/unbind messages
      usb: gadget: udc: net2272: remove bind/unbind messages
      usb: gadget: udc: net2280: remove bind/unbind messages
      usb: gadget: udc: s3c-hsudc: remove bind/unbind messages
      usb: musb: gadget: remove bind/unbind messages
      usb: gadget: udc: core: fix unregistering message
      usb: gadget: remove unnecessary 'driver' argument
      usb: gadget: udc: core: prepend udc_attach_driver with usb_
      usb: dwc2: gadget: do not call usb_gadget_unregister_driver()
      usb: gadget: udc: dummy: do not call usb_gadget_unregister_driver()
      usb: gadget: udc: net2272: do not call usb_gadget_unregister_driver()
      usb: gadget: udc: pxa27x: do not call usb_gadget_unregister_driver()
      usb: dwc3: core: enable phy suspend quirk on non-FPGA
      arm: boot: dts: am4372: enable dwc3 suspend PHY quirk
      phy: twl4030: Fix build breakage
      usb: dwc3: gadget: use udc-core's reset notifier
      usb: musb: gadget: use udc-core's reset notifier
      usb: host: ohci: omap: fix build breakage
      usb: phy: fsl: Fix build errors
      usb: dwc3: trace: don't save pointers
      usb: gadget: udc: lpc32xx: remove unnecessary NULL check
      usb: gadget: udc: pxa25x: remove unnecessary NULL check

Fengguang Wu (3):
      usb: gadget: fix ptr_ret.cocci warnings
      usb: gadget: f_hid: hidg_alloc() can be static
      usb: gadget: midi: f_midi_alloc() can be static

George Cherian (2):
      usb: dwc3: dwc3-omap: get rid of ->prepare()/->complete()
      usb: musb: core: Disable the Interrupts till BABBLE is fully handled

Heikki Krogerus (2):
      usb: dwc3: core: only setting the dma_mask when needed
      usb: dwc3: add ACPI support

Huang Rui (20):
      usb: dwc3: enable hibernation if to be supported
      usb: dwc3: add a flag to check if it is fpga board
      usb: dwc3: initialize platform data at pci glue layer
      usb: dwc3: add disscramble quirk
      usb: dwc3: add lpm erratum support
      usb: dwc3: add u2exit lfps quirk
      usb: dwc3: add P3 in U2 SS inactive quirk
      usb: dwc3: add request p1p2p3 quirk
      usb: dwc3: add delay p1p2p3 quirk
      usb: dwc3: add delay phy power change quirk
      usb: dwc3: add lfps filter quirk
      usb: dwc3: add rx_detect to polling lfps quirk
      usb: dwc3: set SUSPHY bit for all cores
      usb: dwc3: add Tx de-emphasis quirk
      usb: dwc3: add disable usb3 suspend phy quirk
      usb: dwc3: add disable usb2 suspend phy quirk
      PCI: Add support for AMD Nolan USB3 DRD
      PCI: Prevent xHCI driver from claiming AMD Nolan USB3 DRD device
      usb: dwc3: add support for AMD Nolan platform
      usb: dwc3: make HIRD threshold configurable

Jingoo Han (2):
      usb: dwc3: exynos: remove non-DT support for Exynos Specific Glue layer
      usb: dwc3: ep0: remove unnecessary break after return

Jorge Ramirez-Ortiz (1):
      usb: gadget: add USB3 support to the printer driver

Julia Lawall (2):
      usb: dwc3: keystone: fix error return code
      usb: dwc3: return error code from the most recent call

Kazuya Mizuguchi (1):
      usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()

Kever Yang (1):
      usb: dwc2: add bus suspend/resume for dwc2

Kiran Raparthy (2):
      usb: phy: introduce usb_phy_set_event interface
      usb: phy: Handle per-PHY event for connnect and disconnect events

Kyösti Mälkki (1):
      usb: gadget: dbgp: Fix endpoint config after USB disconnect

Marek Szyprowski (8):
      usb: dwc2: gadget: move setting last reset time to s3c_hsotg_core_init
      usb: dwc2: gadget: decouple setting soft-disconnect from s3c_hsotg_core_init
      usb: dwc2: gadget: move phy control calls out of pullup() method
      usb: dwc2: gadget: use soft-disconnect udc feature in pullup() method
      usb: dwc2: gadget: fix calls to phy control functions in suspend/resume code
      usb: dwc2: gadget: rework disconnect event handling
      usb: dwc2: gadget: add mutex to serialize init/deinit calls
      usb: dwc2: gadget: rework suspend/resume code to correctly restore gadget state

Mario Schuknecht (1):
      usb: gadget: net2280: Fix superspeed dma_done()

Markus Elfring (1):
      usb: gadget: function: delete an unnecessary check before rndis_add_hdr()

Pavitrakumar Managutte (1):
      usb: gadget: function: Added usb_assign_descriptors failure check

Peter Chen (30):
      usb: gadget: mv_udc_core: delete unnecessary 'out of memory' messages
      usb: gadget: fsl_qe_udc: delete unnecessary 'out of memory' messages
      usb: gadget: bcm63xx_udc: delete unnecessary 'out of memory' messages
      usb: gadget: s3c-hsudc: delete unnecessary 'out of memory' messages
      usb: musb: davinci: delete unnecessary 'out of memory' messages
      usb: musb: ux500: delete unnecessary 'out of memory' messages
      usb: musb: omap2430: delete unnecessary 'out of memory' messages
      usb: musb: blackfin: delete unnecessary 'out of memory' messages
      usb: musb: tusb6010: delete unnecessary 'out of memory' messages
      usb: musb: musb_dsps: delete unnecessary 'out of memory' messages
      usb: phy: phy-rcar-usb: delete unnecessary 'out of memory' messages
      usb: phy: phy-tegra-usb: delete unnecessary 'out of memory' messages
      usb: phy: phy-am335x-control: delete unnecessary 'out of memory' messages
      usb: phy: phy-rcar-gen2-usb: delete unnecessary 'out of memory' messages
      usb: phy: phy-mxs-usb: delete unnecessary 'out of memory' messages
      usb: phy: phy-msm-usb: delete unnecessary 'out of memory' messages
      usb: phy: phy-mv-usb: delete unnecessary 'out of memory' messages
      usb: renesas_usbhs: delete unnecessary 'out of memory' messages
      usb: chipidea: gadget: use udc-core's reset notifier
      usb: gadget: pxa25x_udc: use udc-core's reset notifier
      usb: gadget: m66592-udc: use udc-core's reset notifier
      usb: gadget: fsl_udc_core: use udc-core's reset notifier
      usb: gadget: at91_udc: use udc-core's reset notifier
      usb: gadget: mv_udc_core: use udc-core's reset notifier
      usb: gadget: fsl_qe_udc: use udc-core's reset notifier
      usb: gadget: pch_udc: use udc-core's reset notifier
      usb: gadget: amd5536udc: use udc-core's reset notifier
      usb: gadget: r8a66597-udc: use udc-core's reset notifier
      usb: gadget: bcm63xx_udc: use udc-core's reset notifier
      usb: gadget: atmel_usba_udc: use udc-core's reset notifier

Robert Jarzmik (7):
      usb: gadget: pxa27x_udc: prepare device-tree support
      usb: gadget: pxa27x_udc: transfer mach_info into pxa_udc
      usb: gadget: pxa27x_udc: add devicetree support
      usb: gadget: pxa27x_udc device-tree documentation
      usb: gadget: pxa27x_udc: use devm_* helpers
      usb: gadget: pxa27x_udc: fix clock prepare and enable
      usb: gadget: pxa27x_udc: fix warning in non device-tree build

Roman Byshko (1):
      usb: musb: replace hard coded registers with defines

Ronald Wahl (1):
      usb: gadget: at91_udc: move prepare clk into process context

Sebastian Andrzej Siewior (5):
      usb: musb: core: use ->resume instead ->resume_noirq
      usb: musb: core: check link status on resume
      usb: musb: try a race-free wakeup
      usb: musb: core: make sure musb is in RPM_ACTIVE on resume
      usb: musb: musb_cppi41: recognize HS devices in hostmode

Sergei Shtylyov (2):
      usb: musb: omap2430: use MUSB_DEVCTL_BDEVICE
      usb: phy: remove file names from heading comments

Takeshi Kihara (1):
      usb: renesas_usbhs: gadget: fix the behavior of pullup

Tony Lindgren (8):
      usb: musb: Add function pointers for IO access functions
      usb: musb: Populate new IO functions for tusb6010
      usb: musb: Populate new IO functions for blackfin
      usb: musb: Change to use new IO access
      usb: musb: Change end point selection to use new IO access
      usb: musb: Pass fifo_mode in platform data
      usb: musb: Allow multiple glue layers to be built in
      usb: musb: Use IS_ENABLED for tusb6010

Varka Bhadram (5):
      usb: dwc3: keystone: remove duplicate check on resource
      usb: renesas_usbhs: common: remove duplicate check on resource
      usb: phy: rcar-usb: remove duplicate check on resource
      usb: musb: dsps: remove duplicate check on resource
      usb: musb: core: remove duplicate check on resource

Vinod Koul (1):
      usb: musb: ux500_dma: use dmaengine_xxx() APIs

Vivek Gautam (3):
      usb: dwc3: exynos: Remove local variable for clock from probe
      usb: dwc3: exynos: Add provision for suspend clock
      usb: dwc3: exynos: Add provision for AXI UpScaler clock on exynos7

Yoshihiro Shimoda (9):
      usb: renesas_usbhs: rename phy to usb_phy in usbhs_priv
      usb: renesas_usbhs: clean up rcar2.c to support a generic PHY
      usb: renesas_usbhs: add support for generic PHY
      usb: renesas_usbhs: fix the timing of dcp_control_transfer_done
      usb: renesas_usbhs: fix usbhs_pipe_clear() for DCP PIPE
      usb: renesas_usbhs: change d{0,1}fifo to dfifo array
      usb: renesas_usbhs: standardize d{0,1}fifo control
      usb: renesas_usbhs: add a new macro for extending DnFIFOs
      usb: renesas_usbhs: expand USB-DMAC channels for R-Car Gen2

kbuild test robot (1):
      usb: gadget: ss_ep_in_comp_desc can be static

 Documentation/ABI/stable/sysfs-class-udc           |   93 +
 Documentation/ABI/testing/configfs-usb-gadget-hid  |   11 +
 Documentation/ABI/testing/configfs-usb-gadget-midi |   12 +
 Documentation/devicetree/bindings/usb/dwc3.txt     |   23 +
 .../devicetree/bindings/usb/exynos-usb.txt         |    6 +-
 Documentation/devicetree/bindings/usb/pxa-usb.txt  |   22 +
 Documentation/usb/gadget_hid.txt                   |    7 +
 arch/arm/boot/dts/am4372.dtsi                      |    4 +
 drivers/pci/quirks.c                               |   20 +
 drivers/phy/phy-omap-usb2.c                        |   14 +-
 drivers/phy/phy-twl4030-usb.c                      |    6 +-
 drivers/usb/chipidea/ci.h                          |    8 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |    2 +-
 drivers/usb/chipidea/ci_hdrc_msm.c                 |    8 +-
 drivers/usb/chipidea/core.c                        |   89 +-
 drivers/usb/chipidea/debug.c                       |    2 +-
 drivers/usb/chipidea/host.c                        |   10 +-
 drivers/usb/chipidea/otg_fsm.c                     |   30 +-
 drivers/usb/chipidea/udc.c                         |   18 +-
 drivers/usb/common/usb-otg-fsm.c                   |    8 +-
 drivers/usb/core/hcd.c                             |    7 +-
 drivers/usb/dwc2/Kconfig                           |   68 +-
 drivers/usb/dwc2/Makefile                          |   32 +-
 drivers/usb/dwc2/core.c                            |   10 -
 drivers/usb/dwc2/core.h                            |  197 +-
 drivers/usb/dwc2/core_intr.c                       |   17 +-
 drivers/usb/dwc2/gadget.c                          |  387 ++--
 drivers/usb/dwc2/hcd.c                             |   94 +-
 drivers/usb/dwc2/hcd.h                             |   10 -
 drivers/usb/dwc2/pci.c                             |    7 +
 drivers/usb/dwc2/platform.c                        |   44 +-
 drivers/usb/dwc3/Kconfig                           |    2 +-
 drivers/usb/dwc3/core.c                            |  251 ++-
 drivers/usb/dwc3/core.h                            |   89 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |   44 +-
 drivers/usb/dwc3/dwc3-keystone.c                   |    6 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   20 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   35 +
 drivers/usb/dwc3/dwc3-st.c                         |    2 +-
 drivers/usb/dwc3/ep0.c                             |   26 +-
 drivers/usb/dwc3/gadget.c                          |   68 +-
 drivers/usb/dwc3/platform_data.h                   |   20 +
 drivers/usb/dwc3/trace.h                           |   20 +-
 drivers/usb/gadget/Kconfig                         |   61 +
 drivers/usb/gadget/composite.c                     |   64 +-
 drivers/usb/gadget/configfs.c                      |    5 +-
 drivers/usb/gadget/function/Makefile               |    4 +
 drivers/usb/gadget/function/f_hid.c                |  374 +++-
 drivers/usb/gadget/function/f_midi.c               |  364 +++-
 drivers/usb/gadget/function/f_ncm.c                |    3 +
 drivers/usb/gadget/function/f_rndis.c              |    3 +-
 drivers/usb/gadget/function/u_hid.h                |   42 +
 drivers/usb/gadget/function/u_midi.h               |   40 +
 drivers/usb/gadget/function/u_uac1.c               |    3 -
 drivers/usb/gadget/legacy/Kconfig                  |    2 +
 drivers/usb/gadget/legacy/dbgp.c                   |   26 +-
 drivers/usb/gadget/legacy/gmidi.c                  |   43 +-
 drivers/usb/gadget/legacy/hid.c                    |   79 +-
 drivers/usb/gadget/legacy/printer.c                |   65 +-
 drivers/usb/gadget/udc/Kconfig                     |    2 +
 drivers/usb/gadget/udc/Makefile                    |    1 +
 drivers/usb/gadget/udc/amd5536udc.c                |   12 +-
 drivers/usb/gadget/udc/at91_udc.c                  |   89 +-
 drivers/usb/gadget/udc/atmel_usba_udc.c            |   25 +-
 drivers/usb/gadget/udc/bcm63xx_udc.c               |   13 +-
 drivers/usb/gadget/udc/bdc/Kconfig                 |   21 +
 drivers/usb/gadget/udc/bdc/Makefile                |    8 +
 drivers/usb/gadget/udc/bdc/bdc.h                   |  490 +++++
 drivers/usb/gadget/udc/bdc/bdc_cmd.c               |  376 ++++
 drivers/usb/gadget/udc/bdc/bdc_cmd.h               |   29 +
 drivers/usb/gadget/udc/bdc/bdc_core.c              |  533 ++++++
 drivers/usb/gadget/udc/bdc/bdc_dbg.c               |  123 ++
 drivers/usb/gadget/udc/bdc/bdc_dbg.h               |   37 +
 drivers/usb/gadget/udc/bdc/bdc_ep.c                | 2023 ++++++++++++++++++++
 drivers/usb/gadget/udc/bdc/bdc_ep.h                |   22 +
 drivers/usb/gadget/udc/bdc/bdc_pci.c               |  132 ++
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |  587 ++++++
 drivers/usb/gadget/udc/dummy_hcd.c                 |   36 +-
 drivers/usb/gadget/udc/fotg210-udc.c               |    3 +-
 drivers/usb/gadget/udc/fsl_qe_udc.c                |   13 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   19 +-
 drivers/usb/gadget/udc/fusb300_udc.c               |    3 +-
 drivers/usb/gadget/udc/goku_udc.c                  |    6 +-
 drivers/usb/gadget/udc/gr_udc.c                    |    8 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   11 +-
 drivers/usb/gadget/udc/m66592-udc.c                |    5 +-
 drivers/usb/gadget/udc/mv_u3d_core.c               |    5 +-
 drivers/usb/gadget/udc/mv_udc_core.c               |   32 +-
 drivers/usb/gadget/udc/net2272.c                   |   66 +-
 drivers/usb/gadget/udc/net2280.c                   |   65 +-
 drivers/usb/gadget/udc/omap_udc.c                  |    6 +-
 drivers/usb/gadget/udc/pch_udc.c                   |   11 +-
 drivers/usb/gadget/udc/pxa25x_udc.c                |   43 +-
 drivers/usb/gadget/udc/pxa27x_udc.c                |  152 +-
 drivers/usb/gadget/udc/pxa27x_udc.h                |    6 +-
 drivers/usb/gadget/udc/r8a66597-udc.c              |   10 +-
 drivers/usb/gadget/udc/s3c-hsudc.c                 |   16 +-
 drivers/usb/gadget/udc/s3c2410_udc.c               |    6 +-
 drivers/usb/gadget/udc/udc-core.c                  |   28 +-
 drivers/usb/gadget/udc/udc-xilinx.c                |    3 +-
 drivers/usb/host/ohci-omap.c                       |    2 +-
 drivers/usb/musb/Kconfig                           |    5 +-
 drivers/usb/musb/am35x.c                           |   32 +-
 drivers/usb/musb/blackfin.c                        |   74 +-
 drivers/usb/musb/da8xx.c                           |   30 +-
 drivers/usb/musb/davinci.c                         |   22 +-
 drivers/usb/musb/jz4740.c                          |    2 +
 drivers/usb/musb/musb_core.c                       |  335 +++-
 drivers/usb/musb/musb_core.h                       |   87 +-
 drivers/usb/musb/musb_cppi41.c                     |   10 +-
 drivers/usb/musb/musb_debugfs.c                    |   57 +-
 drivers/usb/musb/musb_dsps.c                       |   37 +-
 drivers/usb/musb/musb_gadget.c                     |   58 +-
 drivers/usb/musb/musb_host.c                       |    8 +-
 drivers/usb/musb/musb_io.h                         |  106 +-
 drivers/usb/musb/musb_regs.h                       |   26 -
 drivers/usb/musb/musb_virthub.c                    |   23 +-
 drivers/usb/musb/musbhsdma.c                       |    7 +-
 drivers/usb/musb/omap2430.c                        |   52 +-
 drivers/usb/musb/tusb6010.c                        |  102 +-
 drivers/usb/musb/ux500.c                           |   16 +-
 drivers/usb/musb/ux500_dma.c                       |   11 +-
 drivers/usb/phy/phy-ab8500-usb.c                   |   33 +-
 drivers/usb/phy/phy-am335x-control.c               |    4 +-
 drivers/usb/phy/phy-fsl-usb.c                      |   27 +-
 drivers/usb/phy/phy-fsl-usb.h                      |    2 +-
 drivers/usb/phy/phy-generic.c                      |    8 +-
 drivers/usb/phy/phy-gpio-vbus-usb.c                |   16 +-
 drivers/usb/phy/phy-isp1301-omap.c                 |  104 +-
 drivers/usb/phy/phy-msm-usb.c                      |  107 +-
 drivers/usb/phy/phy-mv-usb.c                       |   56 +-
 drivers/usb/phy/phy-mxs-usb.c                      |    4 +-
 drivers/usb/phy/phy-rcar-gen2-usb.c                |    4 +-
 drivers/usb/phy/phy-rcar-usb.c                     |   12 +-
 drivers/usb/phy/phy-tahvo.c                        |   34 +-
 drivers/usb/phy/phy-tegra-usb.c                    |    9 +-
 drivers/usb/phy/phy-ulpi.c                         |    6 +-
 drivers/usb/phy/phy.c                              |   16 +-
 drivers/usb/renesas_usbhs/common.c                 |   14 +-
 drivers/usb/renesas_usbhs/common.h                 |    7 +-
 drivers/usb/renesas_usbhs/fifo.c                   |  111 +-
 drivers/usb/renesas_usbhs/fifo.h                   |   10 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |   41 +-
 drivers/usb/renesas_usbhs/mod_host.c               |    2 +-
 drivers/usb/renesas_usbhs/pipe.c                   |    8 +-
 drivers/usb/renesas_usbhs/rcar2.c                  |   73 +-
 include/linux/pci_ids.h                            |    1 +
 include/linux/platform_data/dwc3-exynos.h          |   24 -
 include/linux/usb/chipidea.h                       |    4 +-
 include/linux/usb/composite.h                      |    7 +
 include/linux/usb/gadget.h                         |    5 +-
 include/linux/usb/otg.h                            |    7 +-
 include/linux/usb/phy.h                            |    6 +-
 include/linux/usb/renesas_usbhs.h                  |    4 +
 154 files changed, 7991 insertions(+), 1980 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-udc
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-hid
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-midi
 create mode 100644 drivers/usb/gadget/function/u_hid.h
 create mode 100644 drivers/usb/gadget/function/u_midi.h
 create mode 100644 drivers/usb/gadget/udc/bdc/Kconfig
 create mode 100644 drivers/usb/gadget/udc/bdc/Makefile
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc.h
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_cmd.c
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_cmd.h
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_core.c
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_dbg.c
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_dbg.h
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_ep.c
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_ep.h
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_pci.c
 create mode 100644 drivers/usb/gadget/udc/bdc/bdc_udc.c
 delete mode 100644 include/linux/platform_data/dwc3-exynos.h
