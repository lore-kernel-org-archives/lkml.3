Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaLNWfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:35:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaLNWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:35:24 -0500
Date: Sun, 14 Dec 2014 14:35:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver patches for 3.19-rc1
Message-ID: <20141214223523.GA3802@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 009d0431c3914de64666bec0d350e54fdd59df6a:

  Linux 3.18-rc7 (2014-11-30 16:42:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.19-rc1

for you to fetch changes up to 81e1dadfb5b2d47aa513ad60b1c9cf0ea17b6514:

  arm: omap3: twl: remove usb phy init data (2014-12-10 22:37:20 -0500)

----------------------------------------------------------------
USB patches for 3.19-rc1

Here's the big set of USB and PHY patches for 3.19-rc1.

The normal churn in the USB gadget area is in here, as well as xhci and
other individual USB driver updates.  The PHY tree is also in here, as
there were dependancies on the USB tree.

All of these have been in linux-next.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (4):
      usb: gadget: dummy-hcd: use udc-core's reset notifier
      usb: gadget: net2280: use udc-core's reset notifier
      usb: gadget: net2272: use udc-core's reset notifier
      USB: host: Remove ehci-octeon and ohci-octeon drivers

Alexandre Belloni (1):
      USB: OHCI: ohci-at91: remove unnecessary headers

Alexey Khoroshilov (1):
      usbip: fix error handling in stub_probe()

Andrew Lunn (1):
      Phy: DT binding documentation for Marvell MVEBU SATA phy.

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

Antoine Tenart (10):
      usb: move the OTG state from the USB PHY to the OTG structure
      usb: rename phy to usb_phy in OTG
      usb: add support to the generic PHY framework in OTG
      usb: allow to supply the PHY in the drivers when using HCD
      usb: chipidea: add support to the generic PHY framework
      phy: add the Berlin USB PHY driver
      Documentation: bindings: add doc for the Berlin USB PHY
      usb: chipidea: fix phy handling
      usb: chipidea: add a usb2 driver for ci13xxx
      Documentation: bindings: add doc for the USB2 ChipIdea USB driver

Anton Staaf (1):
      USB: serial: add Google simple serial SubClass support

Arjun Sreedharan (1):
      usb: phy: propagate __of_usb_find_phy()'s error on failure

Ashwini Pahuja (1):
      usb: gadget: Add UDC driver for Broadcom USB3.0 device controller IP BDC

Bo Shen (2):
      usb: gadget: at91_udc: remove unused release function
      usb: gadget: atmel_usba_udc: remove release function

Chris Rorvick (10):
      usb: Create separate header for ehci-dbgp
      fusbh200: Make Xen notificaiton consistent with EHCI
      fusbh200: Remove superfluous macro definitions
      fusbh200: Remove duplicate ehci-dbgp declarations
      fusbh200: Use ehci_dbg_port struct
      fotg210: Make Xen notification consistent with EHCI
      fotg210: Remove superfluous macro definitions
      fotg210: Remove duplicate ehci-dbgp declarations
      fotg210: Use ehci_dbg_port struct
      usb: Remove __init from early_dbgp_init() prototype

Dan Carpenter (6):
      usb: gadget: f_uac1: remove an unneeded NULL check
      usb: gadget: f_hid: use after free in hidg_alloc_inst()
      usb: gadget: f_hid: fix error handling in ghid_setup()
      USB: adutux: NULL dereferences on disconnect
      USB: mos7720: delete some unneeded code
      usb: gadget: udc: missing curly braces

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

Fabio Estevam (5):
      usb: dwc2: Fix build warning when CONFIG_PM_SLEEP=n
      usb: chipidea: core: Remove unneeded OOM message
      usb: chipidea: ci_hdrc_imx.c: Remove unneeded OOM message
      usb: chipidea: usbmisc_imx: Move the reading of USB_PHY_CTRL
      usb: chipidea: usbmisc_imx: Read MX53_USB_OTG_PHY_CTRL_1_OFFSET directly

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

Gabriel FERNANDEZ (6):
      phy: Add PHY header file for DT x Driver defines
      phy: miphy28lp: Add Device Tree bindings for the MiPHY28lp
      phy: miphy28lp: Provide support for the MiPHY28lp Generic PHY
      phy: miphy28lp: Add SSC support for SATA
      phy: miphy28lp: Add SSC support for PCIE
      phy: miphy28lp: Tune tx impedance across Soc cuts

Geert Uytterhoeven (1):
      uwb: Remove bogus colon after newline from debug message

George Cherian (2):
      usb: dwc3: dwc3-omap: get rid of ->prepare()/->complete()
      usb: musb: core: Disable the Interrupts till BABBLE is fully handled

Greg Kroah-Hartman (6):
      Merge 3.18-rc4 into usb-next.
      USB: cdc-acm: check for valid interfaces
      Merge tag 'usb-for-v3.19' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'usb-serial-3.19-rc1' of git://git.kernel.org/.../johan/usb-serial into usb-next
      Merge tag 'for-3.19' of git://git.kernel.org/.../kishon/linux-phy into usb-testing
      Merge 3.18-rc7 into usb-next

Gregory CLEMENT (3):
      phy: Use PTR_ERR_OR_ZERO to fix warning raised by coccinelle
      Phy: DT binding documentation for the Armada 375 USB cluster binding
      phy: add support for USB cluster on the Armada 375 SoC

Hans de Goede (1):
      uas: Make uas work with blk-mq

Heikki Krogerus (8):
      usb: dwc3: core: only setting the dma_mask when needed
      usb: dwc3: add ACPI support
      phy: safer to_phy() macro
      phy: improved lookup method
      phy: twl4030: use the new lookup method
      phy: remove the old lookup method
      usb: dwc3: host: convey the PHYs to xhci
      arm: omap3: twl: remove usb phy init data

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

Jingoo Han (3):
      USB: imx21-hcd: use %pad for dma_addr_t
      usb: dwc3: exynos: remove non-DT support for Exynos Specific Glue layer
      usb: dwc3: ep0: remove unnecessary break after return

Joe Perches (1):
      usb: storage: Convert usb_stor_dbg to return void

Johan Hovold (3):
      USB: kobil_sct: replace unnecessary atomic allocation
      USB: mos7720: replace unnecessary atomic allocations
      USB: mos7840: replace unnecessary atomic allocations

Jorge Ramirez-Ortiz (1):
      usb: gadget: add USB3 support to the printer driver

Josef Gajdusek (1):
      usb: Do not re-read descriptors for wired devices in usb_authorize_device()

Julia Lawall (5):
      usb: dwc3: keystone: fix error return code
      usb: dwc3: return error code from the most recent call
      host: ehci-w90x900: fix error return code
      usbip: remove unneeded structure
      wusb: replace memset by memzero_explicit

Kazuya Mizuguchi (1):
      usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()

Kever Yang (1):
      usb: dwc2: add bus suspend/resume for dwc2

Kevin Cernekee (3):
      USB: OHCI: Eliminate platform-specific test in ohci.h
      USB: ohci-platform: Expose no_big_frame_no and num_ports in DT
      USB: ohci-platform: Move platform_data checks into the probe function

Kiran Raparthy (2):
      usb: phy: introduce usb_phy_set_event interface
      usb: phy: Handle per-PHY event for connnect and disconnect events

Kishon Vijay Abraham I (1):
      phy: phy-core: use the np present in of_phandle_args to get the PHY

Kyösti Mälkki (1):
      usb: gadget: dbgp: Fix endpoint config after USB disconnect

Lu Baolu (1):
      usb: xhci: fix comment for PORT_DEV_REMOVE

Marcin Wojtas (1):
      usb: ehci-orion: enable big-endian support

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

Mark Knibbs (4):
      USB: serial: keyspan_pda: fix Entrega company name spelling
      USB: storage: Reject bogus max LUN values
      storage: Enable multi-target mode as vendor driver does for SCM eUSCSI bridge
      storage: Fix bus scan and multi-LUN support for SCM eUSCSI devices

Markus Elfring (4):
      usb: gadget: function: delete an unnecessary check before rndis_add_hdr()
      USB-IP: Deletion of unnecessary checks before the function call "usb_put_dev"
      USB-SIS: Deletion of an unnecessary check before the function call "usb_put_dev"
      USB: PCI-quirks: Deletion of unnecessary checks before the function call "pci_dev_put"

Martin Hauke (1):
      USB: qcserial: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Mathias Nyman (3):
      xhci: cleanup finish_td function
      xhci: clear extra bits from slot context when setting max exit latency
      xhci: don't use the same variable for stopped and halted rings current TD

Michael Grzeschik (2):
      usb: ehci: add ehci_port_power interface
      usb: chipidea: host: add portpower override

Mickael Maison (1):
      usb: chipidea: Fixed a few typos in comments

Oliver Neukum (2):
      cdc-acm: Drop the warning for unusual capabilities
      cdc-acm: memory leak in error case

Paul Bolle (1):
      usb: host: Remove optional dependencies on PLAT_S5P

Pavitrakumar Managutte (1):
      usb: gadget: function: Added usb_assign_descriptors failure check

Peter Chen (47):
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
      usb: chipidea: otg_fsm: delete unnecessary 'out of memory' messages
      usb: class: usbtmc: delete unnecessary 'out of memory' messages
      usb: host: ehci-mv: delete unnecessary 'out of memory' messages
      usb: host: ehci-sh: delete unnecessary 'out of memory' messages
      usb: host: ehci-tegra: delete unnecessary 'out of memory' messages
      usb: host: oxu210hp-hcd: delete unnecessary 'out of memory' messages
      usb: misc: usb3503: delete unnecessary 'out of memory' messages
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
      usb: chipidea: using devm_request_irq to instead of request_irq
      usb: chipidea: remove the unnecessary delay after clear portsc.phcd
      usb: chipidea: add hw_wait_phy_stable for getting stable status
      usb: chipidea: add system power management support
      usb: chipidea: imx: add system power management support
      usb: chipidea: remove flag CI_HDRC_REQUIRE_TRANSCEIVER
      usb: chipidea: add controller reset API
      usb: chipidea: parameter 'mode' isn't needed for hw_device_reset
      usb: chipidea: remove duplicate dev_set_drvdata for host_start

Robert Jarzmik (7):
      usb: gadget: pxa27x_udc: prepare device-tree support
      usb: gadget: pxa27x_udc: transfer mach_info into pxa_udc
      usb: gadget: pxa27x_udc: add devicetree support
      usb: gadget: pxa27x_udc device-tree documentation
      usb: gadget: pxa27x_udc: use devm_* helpers
      usb: gadget: pxa27x_udc: fix clock prepare and enable
      usb: gadget: pxa27x_udc: fix warning in non device-tree build

Roman Byshko (2):
      phy: sun4i: add support for USB phy0
      usb: musb: replace hard coded registers with defines

Ronald Wahl (1):
      usb: gadget: at91_udc: move prepare clk into process context

Sebastian Andrzej Siewior (5):
      usb: musb: core: use ->resume instead ->resume_noirq
      usb: musb: core: check link status on resume
      usb: musb: try a race-free wakeup
      usb: musb: core: make sure musb is in RPM_ACTIVE on resume
      usb: musb: musb_cppi41: recognize HS devices in hostmode

Sebastian Hesselbarth (3):
      phy: berlin-sata: Move PHY_BASE into private data struct
      phy: berlin-sata: Add support for BG2 SATA PHY
      phy: berlin-sata: Document BG2 compatible

Sergei Shtylyov (2):
      usb: musb: omap2430: use MUSB_DEVCTL_BDEVICE
      usb: phy: remove file names from heading comments

Sudip Mukherjee (2):
      usb: yurex: fixed sparse warning of incorrect type
      usb: hub: remove unused variable

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

Varka Bhadram (34):
      usb: dwc3: keystone: remove duplicate check on resource
      usb: renesas_usbhs: common: remove duplicate check on resource
      usb: phy: rcar-usb: remove duplicate check on resource
      usb: musb: dsps: remove duplicate check on resource
      usb: musb: core: remove duplicate check on resource
      host: uhci-platform: fix NULL pointer dereference on resource
      host: ehci-sead3: fix NULL pointer dereference on resource
      host: ehci-atmel: remove duplicate check on resource
      host: ohci-da8xx: remove duplicate check on resource
      host: ehci-tegra: remove duplicate check on resource
      host: ehci-w90x900: remove duplicate check on resource
      host: ohci-at91: remove duplicate check on resource
      host: ohci-exynos: remove duplicate check on resource
      host: ohci-jz4740: remove duplicate check on resource
      host: ohci-octeon: remove duplicate check on resource
      host: ohci-platform: remove duplicate check on resource
      host: ohci-pxa27x: remove duplicate check on resource
      host: ehci-sh: remove duplicate check on resource
      host: ohci-spear: remove duplicate check on resource
      host: ehci-msm: remove duplicate check on resource
      host: ehci-mv: remove duplicate check on resource
      host: ehci-mxc: remove duplicate check on resource
      host: ehci-octeon: remove duplicate check on resource
      host: ehci-orion: remove duplicate check on resource
      host: ehci-platform: remove duplicate check on resource
      host: ehci-spear: remove duplicate check on resource
      host: xhci-plat: remove duplicate check on resource
      musb: musb_core: remove duplicate check on resource
      musb: musb_dsps: remove duplicate check on resource
      phy: phy-rcar-usb: remove duplicate check on resource
      dwc3: dwc3-keystone: remove duplicate check on resource
      host: ehci-fsl: remove duplicate check on resource
      host: ehci-exynos: remove duplicate check on resource
      renesas_usbhs: common: remove duplicate check on resource

Vinod Koul (1):
      usb: musb: ux500_dma: use dmaengine_xxx() APIs

Vivek Gautam (7):
      usb: ehci/ohci-exynos: Fix of_node_put() for child when getting PHYs
      usb: dwc3: exynos: Remove local variable for clock from probe
      usb: dwc3: exynos: Add provision for suspend clock
      usb: dwc3: exynos: Add provision for AXI UpScaler clock on exynos7
      phy: exynos5-usbdrd: Add pipe-clk, utmi-clk and itp-clk support
      phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V supply
      phy: exynos7-usbdrd: Update dependency for ARCH_EXYNOS

Wonhong Kwon (1):
      usb: ehci/ohci-platform: use SIMPLE_DEV_PM_OPS to support hibernation

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

kbuild test robot (2):
      usb: gadget: ss_ep_in_comp_desc can be static
      usb: chipidea: fix platform_no_drv_owner.cocci warnings

 Documentation/ABI/stable/sysfs-class-udc           |   93 +
 Documentation/ABI/testing/configfs-usb-gadget-hid  |   11 +
 Documentation/ABI/testing/configfs-usb-gadget-midi |   12 +
 Documentation/devicetree/bindings/ata/marvell.txt  |    6 +
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |    4 +-
 .../devicetree/bindings/phy/berlin-usb-phy.txt     |   16 +
 .../devicetree/bindings/phy/phy-miphy28lp.txt      |  128 ++
 .../devicetree/bindings/phy/phy-mvebu.txt          |   43 +
 .../devicetree/bindings/phy/samsung-phy.txt        |    6 +
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt       |   24 +
 Documentation/devicetree/bindings/usb/dwc3.txt     |   23 +
 .../devicetree/bindings/usb/exynos-usb.txt         |    6 +-
 Documentation/devicetree/bindings/usb/pxa-usb.txt  |   22 +
 Documentation/devicetree/bindings/usb/usb-ohci.txt |    2 +
 Documentation/phy.txt                              |   60 +-
 Documentation/usb/gadget_hid.txt                   |    7 +
 Documentation/usb/usb-serial.txt                   |    2 +-
 arch/arm/boot/dts/am4372.dtsi                      |    4 +
 arch/arm/mach-omap2/twl-common.c                   |   12 +-
 arch/mips/cavium-octeon/octeon-platform.c          |  274 ++-
 arch/mips/configs/cavium_octeon_defconfig          |    3 +
 drivers/pci/quirks.c                               |   20 +
 drivers/phy/Kconfig                                |   23 +-
 drivers/phy/Makefile                               |    3 +
 drivers/phy/phy-armada375-usb2.c                   |  158 ++
 drivers/phy/phy-bcm-kona-usb2.c                    |    2 +-
 drivers/phy/phy-berlin-sata.c                      |   36 +-
 drivers/phy/phy-berlin-usb.c                       |  223 +++
 drivers/phy/phy-core.c                             |  115 +-
 drivers/phy/phy-exynos-dp-video.c                  |    2 +-
 drivers/phy/phy-exynos-mipi-video.c                |    2 +-
 drivers/phy/phy-exynos5-usbdrd.c                   |  139 +-
 drivers/phy/phy-exynos5250-sata.c                  |    2 +-
 drivers/phy/phy-hix5hd2-sata.c                     |    7 +-
 drivers/phy/phy-miphy28lp.c                        | 1283 +++++++++++++
 drivers/phy/phy-miphy365x.c                        |    7 +-
 drivers/phy/phy-mvebu-sata.c                       |    2 +-
 drivers/phy/phy-omap-usb2.c                        |   16 +-
 drivers/phy/phy-qcom-apq8064-sata.c                |    3 +-
 drivers/phy/phy-qcom-ipq806x-sata.c                |    3 +-
 drivers/phy/phy-rcar-gen2.c                        |    2 +-
 drivers/phy/phy-samsung-usb2.c                     |    3 +-
 drivers/phy/phy-spear1310-miphy.c                  |    2 +-
 drivers/phy/phy-spear1340-miphy.c                  |    2 +-
 drivers/phy/phy-stih407-usb.c                      |    2 +-
 drivers/phy/phy-stih41x-usb.c                      |    7 +-
 drivers/phy/phy-sun4i-usb.c                        |   11 +-
 drivers/phy/phy-ti-pipe3.c                         |    2 +-
 drivers/phy/phy-twl4030-usb.c                      |   15 +-
 drivers/phy/phy-xgene.c                            |    2 +-
 drivers/pinctrl/pinctrl-tegra-xusb.c               |    4 +-
 drivers/usb/chipidea/Makefile                      |    1 +
 drivers/usb/chipidea/ci.h                          |   10 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |   45 +-
 drivers/usb/chipidea/ci_hdrc_msm.c                 |    9 +-
 drivers/usb/chipidea/ci_hdrc_usb2.c                |  115 ++
 drivers/usb/chipidea/core.c                        |  225 ++-
 drivers/usb/chipidea/debug.c                       |    2 +-
 drivers/usb/chipidea/host.c                        |   78 +-
 drivers/usb/chipidea/otg_fsm.c                     |   41 +-
 drivers/usb/chipidea/udc.c                         |   22 +-
 drivers/usb/chipidea/usbmisc_imx.c                 |    6 +-
 drivers/usb/class/cdc-acm.c                        |   17 +-
 drivers/usb/class/cdc-acm.h                        |    1 -
 drivers/usb/class/usbtmc.c                         |    4 +-
 drivers/usb/common/usb-otg-fsm.c                   |    8 +-
 drivers/usb/core/hcd.c                             |    7 +-
 drivers/usb/core/hub.c                             |   18 +-
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
 drivers/usb/dwc3/host.c                            |   22 +-
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
 drivers/usb/gadget/udc/bdc/bdc_ep.c                | 2024 ++++++++++++++++++++
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
 drivers/usb/host/Kconfig                           |   18 +-
 drivers/usb/host/Makefile                          |    1 -
 drivers/usb/host/ehci-atmel.c                      |   13 +-
 drivers/usb/host/ehci-exynos.c                     |   12 +-
 drivers/usb/host/ehci-fsl.c                        |   12 +-
 drivers/usb/host/ehci-hcd.c                        |   14 +-
 drivers/usb/host/ehci-hub.c                        |   45 +-
 drivers/usb/host/ehci-msm.c                        |   10 +-
 drivers/usb/host/ehci-mv.c                         |   13 -
 drivers/usb/host/ehci-mxc.c                        |   11 +-
 drivers/usb/host/ehci-octeon.c                     |  188 --
 drivers/usb/host/ehci-orion.c                      |   14 +-
 drivers/usb/host/ehci-platform.c                   |   27 +-
 drivers/usb/host/ehci-sead3.c                      |    5 +-
 drivers/usb/host/ehci-sh.c                         |   16 +-
 drivers/usb/host/ehci-spear.c                      |    9 +-
 drivers/usb/host/ehci-tegra.c                      |   11 +-
 drivers/usb/host/ehci-w90x900.c                    |   17 +-
 drivers/usb/host/ehci.h                            |    2 +
 drivers/usb/host/fotg210.h                         |   62 +-
 drivers/usb/host/fusbh200.h                        |   62 +-
 drivers/usb/host/imx21-hcd.c                       |    6 +-
 drivers/usb/host/octeon2-common.c                  |  200 --
 drivers/usb/host/ohci-at91.c                       |   15 +-
 drivers/usb/host/ohci-da8xx.c                      |    7 +-
 drivers/usb/host/ohci-exynos.c                     |   11 +-
 drivers/usb/host/ohci-hcd.c                        |    5 -
 drivers/usb/host/ohci-jz4740.c                     |   13 +-
 drivers/usb/host/ohci-octeon.c                     |  202 --
 drivers/usb/host/ohci-omap.c                       |    2 +-
 drivers/usb/host/ohci-platform.c                   |   53 +-
 drivers/usb/host/ohci-pxa27x.c                     |   11 +-
 drivers/usb/host/ohci-spear.c                      |   11 +-
 drivers/usb/host/ohci.h                            |   19 +-
 drivers/usb/host/oxu210hp-hcd.c                    |    1 -
 drivers/usb/host/pci-quirks.c                      |   12 +-
 drivers/usb/host/uhci-platform.c                   |    6 +-
 drivers/usb/host/xhci-plat.c                       |   10 +-
 drivers/usb/host/xhci-ring.c                       |  113 +-
 drivers/usb/host/xhci.c                            |    7 +-
 drivers/usb/host/xhci.h                            |    4 +-
 drivers/usb/misc/adutux.c                          |    5 -
 drivers/usb/misc/sisusbvga/sisusb.c                |    3 +-
 drivers/usb/misc/usb3503.c                         |    8 +-
 drivers/usb/misc/yurex.c                           |    6 +-
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
 drivers/usb/serial/Kconfig                         |    5 +-
 drivers/usb/serial/keyspan_pda.c                   |   16 +-
 drivers/usb/serial/kobil_sct.c                     |    2 +-
 drivers/usb/serial/mos7720.c                       |    8 +-
 drivers/usb/serial/mos7840.c                       |    4 +-
 drivers/usb/serial/qcserial.c                      |   33 +
 drivers/usb/serial/usb-serial-simple.c             |   10 +
 drivers/usb/storage/debug.c                        |    7 +-
 drivers/usb/storage/debug.h                        |   10 +-
 drivers/usb/storage/initializers.c                 |    3 +-
 drivers/usb/storage/transport.c                    |   17 +-
 drivers/usb/storage/uas.c                          |   64 +-
 drivers/usb/storage/usb.c                          |   36 +-
 drivers/usb/usbip/stub_dev.c                       |   26 +-
 drivers/usb/usbip/vhci_hcd.c                       |    9 +-
 drivers/usb/wusbcore/dev-sysfs.c                   |    2 +-
 drivers/usb/wusbcore/security.c                    |    8 +-
 drivers/uwb/rsv.c                                  |    4 +-
 include/dt-bindings/phy/phy.h                      |   19 +
 include/linux/i2c/twl.h                            |    2 -
 include/linux/pci_ids.h                            |    1 +
 include/linux/phy/phy.h                            |   52 +-
 include/linux/platform_data/dwc3-exynos.h          |   24 -
 include/linux/usb/chipidea.h                       |    5 +-
 include/linux/usb/composite.h                      |    7 +
 include/linux/usb/ehci-dbgp.h                      |   83 +
 include/linux/usb/ehci_def.h                       |   65 +-
 include/linux/usb/gadget.h                         |    5 +-
 include/linux/usb/hcd.h                            |    3 +
 include/linux/usb/otg.h                            |    7 +-
 include/linux/usb/phy.h                            |    6 +-
 include/linux/usb/renesas_usbhs.h                  |    4 +
 tools/usb/usbip/src/usbipd.c                       |    2 -
 271 files changed, 11292 insertions(+), 3548 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-udc
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-hid
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-midi
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-usb-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
 create mode 100644 Documentation/devicetree/bindings/phy/phy-mvebu.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
 create mode 100644 drivers/phy/phy-armada375-usb2.c
 create mode 100644 drivers/phy/phy-berlin-usb.c
 create mode 100644 drivers/phy/phy-miphy28lp.c
 create mode 100644 drivers/usb/chipidea/ci_hdrc_usb2.c
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
 delete mode 100644 drivers/usb/host/ehci-octeon.c
 delete mode 100644 drivers/usb/host/octeon2-common.c
 delete mode 100644 drivers/usb/host/ohci-octeon.c
 create mode 100644 include/dt-bindings/phy/phy.h
 delete mode 100644 include/linux/platform_data/dwc3-exynos.h
 create mode 100644 include/linux/usb/ehci-dbgp.h
