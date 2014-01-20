Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaATVGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:06:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaATVGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:06:38 -0500
Date: Mon, 20 Jan 2014 13:07:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB patches for 3.14-rc1
Message-ID: <20140120210724.GA412@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.14-rc1

for you to fetch changes up to 2fc5a7dace3c43e62402ab4e8800a8f1834ffe2a:

  usb: chipidea: udc: using MultO at TD as real mult value for ISO-TX (2014-01-13 15:55:19 -0800)

----------------------------------------------------------------
USB patches for 3.14-rc1

Here's the big USB pull request for 3.14-rc1

Lots of little things all over the place, and the usual USB gadget
updates, and XHCI fixes (some for an issue reported by a lot of people.)
USB PHY updates as well as chipidea updates and fixes.

All of these have been in the linux-next tree with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (7):
      ARM: OMAP1: USB: move omap_usb_config to platform data
      usb: omap1: add extcon to platform data
      usb: omap1: OTG controller driver
      usb: omap1: Tahvo USB transceiver driver
      usb: phy: tahvo: fix smatch warnings
      usb: phy: isp1301-omap: fix smatch warnings
      usb: phy: fix some Kconfig descriptions

Alan Stern (1):
      USB: fix race between hub_disconnect and recursively_mark_NOTATTACHED

Alexander Shiyan (2):
      usb: chipidea: usbmisc: Add support for i.MX27/i.MX31 CPUs
      usb: chipidea: usbmisc: Add support for i.MX51 CPU

Andreas Larsson (1):
      usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC

Andrew Lunn (2):
      tty: Add C_CMSPAR(tty)
      USB: serial: add Moxa UPORT 12XX/14XX/16XX driver

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

Arnd Bergmann (1):
      USB: fix: ohci-at91 mismerge build error

Ben Hutchings (2):
      USB: emi62: Provide the correct bitstream firmware
      xhci: Avoid infinite loop when sg urb requires too many trbs

Bin Liu (1):
      usb: musb: dsps: polling ID pin status only in otg mode

Bjørn Mork (2):
      usb: cdc-wdm: avoid hanging on zero length reads
      usb: cdc-wdm: resp_count can be 0 even if WDM_READ is set

Boris BREZILLON (3):
      usb: ohci-at91: replace request_mem_region + ioremap by devm_ioremap_resource
      usb: ohci-at91: use dev variable instead of &pdev->dev
      usb: ohci-at91: use device managed clk retrieval

Chris Ruehl (3):
      usb: chipidea: Reallocate regmap only if lpm is detected
      usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
      usb: chipidea: put hw_phymode_configure before ci_usb_phy_init

Colin Leitner (1):
      USB: ftdi_sio: added CS5 quirk for broken smartcard readers

Dan Carpenter (1):
      usb: gadget: update some out of date comments

Dan Williams (2):
      usb: xhci: change enumeration scheme to 'new scheme' by default
      xhci: clarify logging in xhci_setup_device

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

Fabio Estevam (2):
      usb: chipidea: host: Only disable the vbus regulator if it is not NULL
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

Fengguang Wu (1):
      USB: fix coccinelle warnings

Geert Uytterhoeven (4):
      usb: gadget: remove superfluous name casts
      usb: core: Remove superfluous name casts
      usb: gadget: Remove superfluous name casts
      usb: host: Remove superfluous name casts

George Cherian (3):
      usb: dwc3: dwc3-omap: return PROBE_DEFER if extcon is missing and found in dt
      usb: phy: am335x: Enable USB remote wakeup using PHY wakeup
      usb: phy: omap: Add omap-control Support for AM437x

Greg Kroah-Hartman (13):
      Merge tag 'for-usb-next-2013-12-02' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge tag 'for-usb-next-2013-12-10' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge branch 3.13-rc4 into usb-next
      usb: gadget: fix up some comments about CONFIG_USB_DEBUG
      USB: c67x00: remove CONFIG_USB_DEBUG dependancy
      Merge tag 'for-usb-next-2013-12-20' of git://git.kernel.org/.../sarah/xhci into usb-next
      USB: gadget: fix up some comments about CONFIG_USB_DEBUG
      USB: core: remove CONFIG_USB_DEBUG usage
      Merge 3.13-rc5 into usb-next
      Merge tag 'usb-for-v3.14' of git://git.kernel.org/.../balbi/usb into usb-next
      Watchdog: pcwd_usb: remove CONFIG_USB_DEBUG usage
      Merge tag 'for-usb-next-2014-01-08' of git://git.kernel.org/.../sarah/xhci into usb-next
      Revert "usb: chipidea: imx: set CI_HDRC_IMX28_WRITE_FIX for imx28"

Heikki Krogerus (1):
      usb: dwc3: fix the glue drivers using the nop phy

Huang Rui (3):
      usb: usbtest: add a test case to support bos for queue control
      usb: usbtest: fix the bit mask of usb 2.0 extension descriptor
      usb: usbtest: update bos test coverage to usb 2.1 device

Jack Pham (1):
      usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()

Jingoo Han (32):
      usb: chipidea: remove DEFINE_PCI_DEVICE_TABLE macro
      USB: remove DEFINE_PCI_DEVICE_TABLE macro
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
      USB: ehci-fsl: use dev_warn() instead of printk()
      USB: ehci-grlib: use dev_err() instead of printk()
      USB: ehci-orion: use dev_warn() instead of printk()
      USB: ehci-ppc-of: use dev_err() instead of printk()
      USB: ehci-xilinx-of: use dev_err() instead of printk()
      USB: ohci-omap: use dev_err() instead of printk()
      USB: ohci-ppc-of: use dev_err() instead of printk()
      USB: ehci-orion: Use devm_*() functions
      USB: ehci-fsl: Use devm_ioremap_resource()
      USB: ehci-octeon: Use devm_ioremap_resource()
      USB: ohci-pxa27x:Use devm_*() functions
      USB: ohci-jz4740: Use devm_*() functions
      USB: ohci-da8xx: Use devm_*() functions
      USB: ehci-w90x900: Use devm_ioremap_resource()
      USB: ohci-nxp: Use devm_clk_get()
      USB: ohci-ppc-of: Use devm_ioremap_resource()
      USB: ohci-spear: Use devm_ioremap_resource()
      USB: ohci-octeon: Use devm_ioremap_resource()

Johan Hovold (40):
      USB: pl2303: fix data corruption on termios updates
      USB: serial: constify device-id tables
      USB: serial: clean up ioctl debugging
      USB: serial: remove redundant OOM messages
      USB: f81232: remove bogus call to wake up MSR queue
      USB: f81232: switch to generic tiocmiwait
      USB: pl2303: remove bogus delta_msr_wait wake up
      USB: pl2303: clean up driver somewhat
      USB: pl2303: add error handling to vendor read and write functions
      USB: pl2303: add error handling to set_control_lines
      USB: pl2303: add error handling to line requests
      USB: pl2303: remove redundant line-request call
      USB: pl2303: add line-status quirk for Siemens phones
      USB: pl2303: use speed_t for baud rates
      USB: pl2303: clean up type handling
      USB: pl2303: add quirk for legacy devices
      USB: pl2303: add device-type abstraction
      USB: pl2303: rename pl2303_encode_baud_rate
      USB: pl2303: refactor baud-rate table lookup
      USB: pl2303: enforce baud-rate limits before lookup
      USB: pl2303: refactor baud-rate divisor handling
      USB: pl2303: add helper function for direct baud-rate encoding
      USB: pl2303: use direct baud-rate encoding when possible
      USB: pl2303: use C_CMSPAR macro
      USB: pl2303: make type data const
      USB: pl2303: clean up line-status handling
      USB: pl2303: only wake up MSR queue on changes
      USB: pl2303: switch to generic TIOCMIWAIT implementation
      USB: cypress_m8: fix ring-indicator detection and reporting
      USB: cypress_m8: clean up protocol definitions
      USB: cypress_m8: only wake up MSR queue on changes
      USB: cypress_m8: switch to generic TIOCMIWAIT implementation
      USB: ch341: refactor line-status handling
      USB: ch341: clean up line-status handling
      USB: ch341: fix ignored TIOCMIWAIT mask
      USB: ch341: only wake up MSR queue on changes
      USB: ch341: switch to generic TIOCMIWAIT implementation
      USB: ch341: clean up interrupt handler
      USB: oti6858: only wake up MSR queue on changes
      USB: oti6858: switch to generic TIOCMIWAIT implementation

Kuninori Morimoto (1):
      usb: renesas_usbhs: fifo: request DMAEngine once

Laurent Pinchart (1):
      usb: gadget: r8a66597-udc: convert to clk_prepare/unprepare

Lee Jones (1):
      usb: musb: ux500_dma: fix potential NULL dereference error

Levente Kurusa (1):
      uwb: umc-dev: add missing put_device call

Lin Wang (1):
      xhci: Remove unused variable 'addr' in inc_deq() and inc_enq().

Majunath Goudar (6):
      USB: OHCI: Properly handle OHCI controller suspend
      USB: OHCI: Properly handle ohci-at91 suspend
      USB: OHCI: Properly handle ohci-s3c2410 suspend
      USB: OHCI: Properly handle ohci-da8xx suspend
      USB: OHCI: Properly handle ohci-exynos suspend
      USB: OHCI: Properly handle ohci-spear suspend

Marc Kleine-Budde (2):
      usb: chipidea: move malloced regmap directly into struct hw_bank
      usb: chipidea: mark register map as "const" and convert to u8

Matt Porter (8):
      phy: add phy_get_bus_width()/phy_set_bus_width() calls
      staging: dwc2: update DT binding to add generic clock/phy properties
      usb: gadget: s3c-hsotg: enable build for other platforms
      usb: gadget: s3c-hsotg: add snps,dwc2 compatible string
      usb: gadget: s3c-hsotg: enable generic phy support
      usb: gadget: s3c-hsotg: get phy bus width from phy subsystem
      phy: add Broadcom Kona USB2 PHY DT binding
      phy: add Broadcom Kona USB2 PHY driver

Max Filippov (2):
      USB: c67x00: add proper delays to HPI read/write
      USB: c67x00: move URB private data allocation from under spinlock

Michal Nazarewicz (3):
      usb: gadget: goku: remove unused argument
      usb: gadget: f_fs: remove loop from I/O function
      usb: f_fs: check quirk to pad epout buf size when not aligned to maxpacketsize

Mikhail Zolotaryov (1):
      USB: Nokia 502 is an unusual device

Ming Lei (3):
      lib/scatterlist: export sg_miter_skip()
      USB: storage: use sg_miter_* APIs to access scsi buffer
      USB: storage: fix compile warning

Neil Zhang (1):
      usb: phy: initialize the notifier when add a new phy

Oliver Neukum (25):
      cdc-acm: add TIOCMIWAIT
      cdc-acm: add TIOCGICOUNT
      cdc-acm: fix power management in ioctl
      ohci: remove conditional compilation
      ohci: kill ohci_vdbg
      ohci:always register debug files
      ohci: no conditional debugging in root hub hadling
      ehci: no conditional compilation for interestingness
      ehci: Remove debugging at every interrupt
      fotg210: remove conditional compilation
      fotg210: always compile the support for debugfs
      fotg210: change dbg_port() to evaluate parameters only if needed
      fotg210: remove conditional compilation
      fotg210: kill fotg210_vdbg()
      fusbh200: always build debugfs support
      uhci: change dependency for debug parameter
      uhci: compile debugfs conditional on CONFIG_DYNAMIC_DEBUG || DEBUG
      fusbh200: unconditionally compile debugging helpers
      fusb200h: don't log on every interrupt
      fusbh200: always compile debugfs support
      fusb200h: always compile in debugfs support
      fusbh200: kill fusbh200_vdbg
      usb: kill DEBUG compile option
      USB: kill #undef VERBOSE_DEBUG
      Revert "USB: quirks: add touchscreen that is dazzeled by remote wakeup"

Paul Gortmaker (1):
      usb: delete non-required instances of include <linux/init.h>

Peter Chen (9):
      usb: chipidea: imx: avoid unnecessary probe defer every time
      usb: hcd: move controller wakeup setting initialization to individual driver
      usb: doc: rename ci13xxx-imx.txt to ci-hdrc-imx.txt
      usb: chipidea: imx: set CI_HDRC_IMX28_WRITE_FIX for imx28
      usb: ehci: add freescale imx28 special write register method
      usb: chipidea: add freescale imx28 special write register method
      usb: chipidea: imx: set CI_HDRC_IMX28_WRITE_FIX for imx28
      usb: chipidea: need to mask INT_STATUS when write otgsc
      usb: chipidea: udc: using MultO at TD as real mult value for ISO-TX

Rahul Bedarkar (18):
      USB: iowarrior: fix spelling mistake in comment
      USB: chipidea: add guard macro to ci_hdrc_imx.h
      USB: yurex: fix spelling mistake in comment
      USB: misc: idmouse: correct spelling mistake in error string
      USB: musb: correct spelling mistakes in comment and error string
      USB: serial: correct spelling mistakes in comments
      USB: serial: add support for iBall 3.5G connect usb modem
      USB: core: correct spelling mistakes in comments and warning
      USB: wusbcore: correct spelling mistakes in comments and error string
      USB: wusbcore: fix up minor coding style issues in cbaf.c
      USB: wusbcore: fix up line break coding style issues in wa-hc.h
      USB: wusbcore: fix up line break coding style issues in security.c
      USB: wusbcore: fix up line break coding style issues in mmc.c
      USB: wusbcore: fix up coding style issues in wusbhc.c and wusbhc.h
      USB: wusbcore: fix up coding style issues in wa-rpipe.c
      USB: wusbcore: fix up coding style issues in wa-nep.c
      USB: c67x00: correct spelling mistakes in comments
      USB: image: correct spelling mistake in comment

Rashika Kheria (4):
      usb: gadget: configfs: include appropriate header file in configfs.c
      usb: phy: am335x-control: include appropriate header file in phy-am335x-control.c
      drivers: usb: Mark function as static in usbsevseg.c
      drivers: usb: Mark function as static in metro-usb.c

Robert Baldyga (3):
      usb: gadget: s3c-hsotg: fix maxpacket size in s3c_hsotg_irq_enumdone
      usb: gadget: s3c-hsotg: add flush TX FIFO when kill all requests
      usb: gadget: add "maxpacket_limit" field to struct usb_ep

Roger Quadros (2):
      usb: usbtest: Add timetout to simple_io()
      usb: usbtest: Always clear halt else further tests will fail

Sachin Kamat (4):
      usb: phy-keystone: Remove redundant of_match_ptr helper
      usb: phy-fsm: Staticize local symbols
      usb: phy-twl6030: Add missing braces
      usb: ehci: Cleanup usb-ehci-orion.h header

Sarah Sharp (2):
      usbtest: Fix BOS control test for USB 2.01 devices.
      xhci: Set scatter-gather limit to avoid failed block writes.

Seth Archer Brown (1):
      Usb: atm: usbatm: fixed a pointer variable format issue

Shen Guang (1):
      usb:hub set hub->change_bits when over-current happens

Takashi Iwai (1):
      xhci: Add quirks module option

Thomas Pugliese (15):
      usb: wusbcore: add calls to usb_hcd_link_urb_to_ep, usb_hcd_unlink_urb_from_ep, and
      usb: wusbcore: add more info to debug prints in urb_unlink path
      usb: wusbcore: return -ENOENT for unlinked URBs.
      usb: wusbcore: fix short transfers
      usb: core: allow isoc URBs for wireless devices with an interval < 6
      usb: core: get config and string descriptors for unauthorized devices
      usb: wusbcore: use USB_CTRL_SET_TIMEOUT and USB_CTRL_GET_TIMEOUT
      usb: wusbcore: move isoc_frame_index from wa_xfer to wa_seg
      usb: wusbcore: set packet count correctly on isoc transfers
      usb: wusbcore: add isochronous IN support to HWA
      usb: wusbcore: add debug prints to reservation and channel change
      uwb: add debug prints during channel change and beacon actions
      uwb: whitespace and comment cleanups
      uwb: use uwb_rsv_callback instead of calling rsv->callback directly
      uwb: move mutex_lock to error case in uwbd_evt_handle_rc_bp_slot_change

Valentine Barshak (3):
      usb: hcd: Remove USB phy if needed
      usb: hcd: Initialize USB phy if needed
      usb: phy: r-car gen2: use usb_add_phy_dev

Wei Yongjun (3):
      usb: phy: keystone: remove redundant return value check of platform_get_resource()
      usb: gadget: s3c-hsotg: remove duplicated include from s3c-hsotg.c
      usb: gadget: remove unused variable in gr_queue_int()

WingMan Kwok (2):
      usb: dwc3: add Keystone specific glue layer
      usb: phy: add Keystone usb phy driver

Wolfram Sang (4):
      usb: core: add sanity checks when using bInterfaceClass with new_id
      usb: core: allow a reference device for new_id
      usb: core: bail out if user gives an unknown RefId when using new_id
      usb: core: check for valid id_table when using the RefId feature

Xenia Ragiadakou (15):
      xhci: convert TRB_CYCLE to le32 before using it to set Link TRB's cycle bit
      xhci: fix incorrect type in assignment in handle_device_notification()
      xhci: fix derivation of TRB's DMA address in xhci_log_event Trace Event Class
      xhci: fix sparse warning in xhci-trace.h
      xhci: fix incorrect type in assignment in xhci_address_device()
      xhci: replace USB_MAXINTERFACES with config->desc.bNumInterface
      xhci: fix SCT_FOR_CTX(p) macro
      xhci: remove unnecessary check in xhci_free_stream_info()
      xhci: fix incorrect type in assignment in xhci_count_num_new_endpoints()
      xhci: fix incorrect type in assignment in xhci_count_num_dropped_endpoints()
      xhci: remove conversion from generic to pci device in xhci_mem.c
      xhci: replace xhci_readl() with readl()
      xhci: replace xhci_writel() with writel()
      xhci: replace xhci_read_64() with readq()
      xhci: replace xhci_write_64() with writeq()

Yijing Wang (2):
      uwb: Use dev_is_pci() to check whether it is pci device
      usb: Use dev_is_pci() to check whether it is pci device

张君 (1):
      usb: option: add new zte 3g modem pids to option driver

 Documentation/ABI/testing/configfs-usb-gadget-ffs  |     9 +
 .../ABI/testing/configfs-usb-gadget-loopback       |     8 +
 .../ABI/testing/configfs-usb-gadget-sourcesink     |    12 +
 Documentation/ABI/testing/sysfs-bus-usb            |    10 +-
 Documentation/ABI/testing/sysfs-platform-tahvo-usb |    16 +
 Documentation/devicetree/bindings/phy/bcm-phy.txt  |    15 +
 Documentation/devicetree/bindings/staging/dwc2.txt |    12 +
 .../usb/{ci13xxx-imx.txt => ci-hdrc-imx.txt}       |     0
 Documentation/devicetree/bindings/usb/gr-udc.txt   |    28 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |     2 +
 arch/arm/mach-omap1/include/mach/usb.h             |    38 +-
 drivers/phy/Kconfig                                |     6 +
 drivers/phy/Makefile                               |     1 +
 drivers/phy/phy-bcm-kona-usb2.c                    |   158 +
 drivers/staging/dwc2/hcd.c                         |     2 +
 drivers/staging/octeon-usb/octeon-hcd.c            |     1 +
 drivers/staging/ozwpan/ozhcd.c                     |     2 +
 drivers/usb/Kconfig                                |     4 +-
 drivers/usb/atm/cxacru.c                           |     1 -
 drivers/usb/atm/speedtch.c                         |     1 -
 drivers/usb/atm/ueagle-atm.c                       |     1 -
 drivers/usb/atm/usbatm.c                           |     8 +-
 drivers/usb/c67x00/Makefile                        |     2 -
 drivers/usb/c67x00/c67x00-hcd.c                    |     2 +
 drivers/usb/c67x00/c67x00-hcd.h                    |     2 +-
 drivers/usb/c67x00/c67x00-ll-hpi.c                 |    14 +-
 drivers/usb/c67x00/c67x00-sched.c                  |    33 +-
 drivers/usb/chipidea/Makefile                      |     2 +-
 drivers/usb/chipidea/ci.h                          |    89 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |    32 +-
 drivers/usb/chipidea/ci_hdrc_imx.h                 |     5 +
 drivers/usb/chipidea/ci_hdrc_pci.c                 |     2 +-
 drivers/usb/chipidea/core.c                        |   105 +-
 drivers/usb/chipidea/host.c                        |     1 +
 drivers/usb/chipidea/otg.h                         |     6 +-
 drivers/usb/chipidea/udc.c                         |    23 +-
 drivers/usb/chipidea/usbmisc_imx.c                 |    46 +
 drivers/usb/class/cdc-acm.c                        |   116 +-
 drivers/usb/class/cdc-acm.h                        |     3 +
 drivers/usb/class/cdc-wdm.c                        |    70 +-
 drivers/usb/class/usblp.c                          |     1 -
 drivers/usb/class/usbtmc.c                         |     1 -
 drivers/usb/core/Makefile                          |     2 -
 drivers/usb/core/buffer.c                          |     2 +-
 drivers/usb/core/config.c                          |     8 -
 drivers/usb/core/devio.c                           |     2 +-
 drivers/usb/core/driver.c                          |    33 +-
 drivers/usb/core/hcd-pci.c                         |     1 +
 drivers/usb/core/hcd.c                             |    40 +-
 drivers/usb/core/hub.c                             |   116 +-
 drivers/usb/core/hub.h                             |     2 +-
 drivers/usb/core/message.c                         |     5 +-
 drivers/usb/core/quirks.c                          |     3 -
 drivers/usb/core/sysfs.c                           |     2 +-
 drivers/usb/core/urb.c                             |    25 +-
 drivers/usb/core/usb-acpi.c                        |     2 +-
 drivers/usb/dwc3/Kconfig                           |     7 +
 drivers/usb/dwc3/Makefile                          |     1 +
 drivers/usb/dwc3/dwc3-exynos.c                     |     1 +
 drivers/usb/dwc3/dwc3-keystone.c                   |   202 +
 drivers/usb/dwc3/dwc3-omap.c                       |    12 +-
 drivers/usb/dwc3/dwc3-pci.c                        |     3 +-
 drivers/usb/dwc3/gadget.c                          |    10 +-
 drivers/usb/gadget/Kconfig                         |    54 +-
 drivers/usb/gadget/Makefile                        |     9 +-
 drivers/usb/gadget/acm_ms.c                        |     2 +-
 drivers/usb/gadget/amd5536udc.c                    |    18 +-
 drivers/usb/gadget/at91_udc.c                      |    17 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    71 +-
 drivers/usb/gadget/bcm63xx_udc.c                   |     5 +-
 drivers/usb/gadget/composite.c                     |    18 +-
 drivers/usb/gadget/configfs.c                      |     8 +
 drivers/usb/gadget/dummy_hcd.c                     |     2 +-
 drivers/usb/gadget/epautoconf.c                    |     9 +-
 drivers/usb/gadget/f_ecm.c                         |    73 +-
 drivers/usb/gadget/f_fs.c                          |  1012 +-
 drivers/usb/gadget/f_hid.c                         |    18 +-
 drivers/usb/gadget/f_loopback.c                    |   144 +-
 drivers/usb/gadget/f_midi.c                        |    22 +-
 drivers/usb/gadget/f_ncm.c                         |     2 +-
 drivers/usb/gadget/f_obex.c                        |     2 +-
 drivers/usb/gadget/f_phonet.c                      |     2 +-
 drivers/usb/gadget/f_rndis.c                       |    94 +-
 drivers/usb/gadget/f_serial.c                      |     2 +-
 drivers/usb/gadget/f_sourcesink.c                  |   349 +-
 drivers/usb/gadget/f_subset.c                      |    60 +-
 drivers/usb/gadget/fotg210-udc.c                   |     3 +-
 drivers/usb/gadget/fsl_qe_udc.c                    |     5 +-
 drivers/usb/gadget/fsl_udc_core.c                  |     7 +-
 drivers/usb/gadget/fusb300_udc.c                   |     4 +-
 drivers/usb/gadget/g_ffs.c                         |   466 +-
 drivers/usb/gadget/g_zero.h                        |    24 +-
 drivers/usb/gadget/goku_udc.c                      |    17 +-
 drivers/usb/gadget/gr_udc.c                        |  2238 ++++
 drivers/usb/gadget/gr_udc.h                        |   220 +
 drivers/usb/gadget/lpc32xx_udc.c                   |     2 +-
 drivers/usb/gadget/m66592-udc.c                    |     4 +-
 drivers/usb/gadget/multi.c                         |     2 +-
 drivers/usb/gadget/mv_u3d_core.c                   |     5 +-
 drivers/usb/gadget/mv_udc_core.c                   |     5 +-
 drivers/usb/gadget/net2272.c                       |     4 +-
 drivers/usb/gadget/net2280.c                       |     8 +-
 drivers/usb/gadget/nokia.c                         |     6 +-
 drivers/usb/gadget/omap_udc.c                      |     4 +-
 drivers/usb/gadget/pch_udc.c                       |     8 +-
 drivers/usb/gadget/pxa25x_udc.c                    |     2 +-
 drivers/usb/gadget/pxa27x_udc.c                    |     5 +-
 drivers/usb/gadget/r8a66597-udc.c                  |    10 +-
 drivers/usb/gadget/rndis.c                         |     8 +-
 drivers/usb/gadget/s3c-hsotg.c                     |    80 +-
 drivers/usb/gadget/s3c-hsotg.h                     |     1 +
 drivers/usb/gadget/s3c-hsudc.c                     |     2 +-
 drivers/usb/gadget/s3c2410_udc.c                   |     1 +
 drivers/usb/gadget/u_ether.c                       |     2 +-
 drivers/usb/gadget/u_ether.h                       |    43 +-
 drivers/usb/gadget/u_f.c                           |    32 +
 drivers/usb/gadget/u_f.h                           |    26 +
 drivers/usb/gadget/u_fs.h                          |   267 +
 drivers/usb/gadget/u_rndis.h                       |     2 +
 drivers/usb/gadget/usbstring.c                     |     1 -
 drivers/usb/gadget/zero.c                          |     8 +-
 drivers/usb/host/Makefile                          |     2 -
 drivers/usb/host/ehci-atmel.c                      |     1 +
 drivers/usb/host/ehci-dbg.c                        |    10 +-
 drivers/usb/host/ehci-exynos.c                     |     1 +
 drivers/usb/host/ehci-fsl.c                        |    33 +-
 drivers/usb/host/ehci-grlib.c                      |     4 +-
 drivers/usb/host/ehci-hcd.c                        |    14 +-
 drivers/usb/host/ehci-hub.c                        |     6 +-
 drivers/usb/host/ehci-mv.c                         |     3 +-
 drivers/usb/host/ehci-mxc.c                        |     1 +
 drivers/usb/host/ehci-octeon.c                     |    24 +-
 drivers/usb/host/ehci-omap.c                       |     1 +
 drivers/usb/host/ehci-orion.c                      |    46 +-
 drivers/usb/host/ehci-platform.c                   |     1 +
 drivers/usb/host/ehci-pmcmsp.c                     |     4 +-
 drivers/usb/host/ehci-ppc-of.c                     |     4 +-
 drivers/usb/host/ehci-ps3.c                        |     1 +
 drivers/usb/host/ehci-q.c                          |     4 +-
 drivers/usb/host/ehci-sead3.c                      |     1 +
 drivers/usb/host/ehci-sh.c                         |     1 +
 drivers/usb/host/ehci-spear.c                      |     1 +
 drivers/usb/host/ehci-tegra.c                      |     1 +
 drivers/usb/host/ehci-tilegx.c                     |     1 +
 drivers/usb/host/ehci-w90x900.c                    |    22 +-
 drivers/usb/host/ehci-xilinx-of.c                  |     7 +-
 drivers/usb/host/ehci.h                            |    26 +-
 drivers/usb/host/fhci-hcd.c                        |     2 +
 drivers/usb/host/fotg210-hcd.c                     |    96 +-
 drivers/usb/host/fotg210.h                         |     8 -
 drivers/usb/host/fusbh200-hcd.c                    |    98 +-
 drivers/usb/host/fusbh200.h                        |    12 -
 drivers/usb/host/hwa-hc.c                          |    24 +-
 drivers/usb/host/imx21-dbg.c                       |     4 +
 drivers/usb/host/imx21-hcd.c                       |     7 +-
 drivers/usb/host/imx21-hcd.h                       |     4 +
 drivers/usb/host/isp116x-hcd.c                     |     5 +-
 drivers/usb/host/isp1362-hcd.c                     |     5 +-
 drivers/usb/host/isp1760-hcd.c                     |     1 +
 drivers/usb/host/ohci-at91.c                       |    82 +-
 drivers/usb/host/ohci-da8xx.c                      |    73 +-
 drivers/usb/host/ohci-dbg.c                        |    69 -
 drivers/usb/host/ohci-exynos.c                     |    23 +-
 drivers/usb/host/ohci-hcd.c                        |    29 +-
 drivers/usb/host/ohci-hub.c                        |     6 +-
 drivers/usb/host/ohci-jz4740.c                     |    40 +-
 drivers/usb/host/ohci-nxp.c                        |    30 +-
 drivers/usb/host/ohci-octeon.c                     |    25 +-
 drivers/usb/host/ohci-omap.c                       |     5 +-
 drivers/usb/host/ohci-omap3.c                      |     1 +
 drivers/usb/host/ohci-platform.c                   |     2 +
 drivers/usb/host/ohci-ppc-of.c                     |    28 +-
 drivers/usb/host/ohci-ps3.c                        |     1 +
 drivers/usb/host/ohci-pxa27x.c                     |    42 +-
 drivers/usb/host/ohci-q.c                          |    12 +-
 drivers/usb/host/ohci-s3c2410.c                    |    22 +-
 drivers/usb/host/ohci-sa1111.c                     |     4 +-
 drivers/usb/host/ohci-sm501.c                      |     1 +
 drivers/usb/host/ohci-spear.c                      |    29 +-
 drivers/usb/host/ohci-tilegx.c                     |     1 +
 drivers/usb/host/ohci-tmio.c                       |     2 +-
 drivers/usb/host/ohci.h                            |    13 +-
 drivers/usb/host/oxu210hp-hcd.c                    |     6 +-
 drivers/usb/host/pci-quirks.c                      |     1 -
 drivers/usb/host/r8a66597-hcd.c                    |     4 +-
 drivers/usb/host/sl811-hcd.c                       |     3 +-
 drivers/usb/host/sl811_cs.c                        |     1 -
 drivers/usb/host/u132-hcd.c                        |     3 +-
 drivers/usb/host/uhci-debug.c                      |     4 +-
 drivers/usb/host/uhci-grlib.c                      |     1 +
 drivers/usb/host/uhci-hcd.c                        |    44 +-
 drivers/usb/host/uhci-pci.c                        |     2 +-
 drivers/usb/host/uhci-platform.c                   |     1 +
 drivers/usb/host/whci/hcd.c                        |     1 +
 drivers/usb/host/whci/int.c                        |     1 -
 drivers/usb/host/whci/wusb.c                       |     1 -
 drivers/usb/host/xhci-dbg.c                        |    42 +-
 drivers/usb/host/xhci-hub.c                        |   106 +-
 drivers/usb/host/xhci-mem.c                        |    68 +-
 drivers/usb/host/xhci-pci.c                        |     1 +
 drivers/usb/host/xhci-plat.c                       |     2 +
 drivers/usb/host/xhci-ring.c                       |    50 +-
 drivers/usb/host/xhci-trace.h                      |     6 +-
 drivers/usb/host/xhci.c                            |   227 +-
 drivers/usb/host/xhci.h                            |    67 +-
 drivers/usb/image/mdc800.c                         |     2 +-
 drivers/usb/image/microtek.c                       |     1 -
 drivers/usb/misc/adutux.c                          |     1 -
 drivers/usb/misc/cypress_cy7c63.c                  |     1 -
 drivers/usb/misc/cytherm.c                         |     1 -
 drivers/usb/misc/emi26.c                           |     1 -
 drivers/usb/misc/emi62.c                           |     1 -
 drivers/usb/misc/ezusb.c                           |     1 -
 drivers/usb/misc/idmouse.c                         |     3 +-
 drivers/usb/misc/iowarrior.c                       |     3 +-
 drivers/usb/misc/ldusb.c                           |     1 -
 drivers/usb/misc/legousbtower.c                    |     1 -
 drivers/usb/misc/rio500.c                          |     1 -
 drivers/usb/misc/sisusbvga/sisusb_init.c           |     1 -
 drivers/usb/misc/trancevibrator.c                  |     1 -
 drivers/usb/misc/usblcd.c                          |     1 -
 drivers/usb/misc/usbled.c                          |     1 -
 drivers/usb/misc/usbsevseg.c                       |     3 +-
 drivers/usb/misc/usbtest.c                         |    42 +-
 drivers/usb/misc/yurex.c                           |     3 +-
 drivers/usb/musb/Kconfig                           |    16 +-
 drivers/usb/musb/Makefile                          |     1 +
 drivers/usb/musb/am35x.c                           |     1 -
 drivers/usb/musb/blackfin.c                        |     5 +-
 drivers/usb/musb/da8xx.c                           |     1 -
 drivers/usb/musb/davinci.c                         |     1 -
 drivers/usb/musb/jz4740.c                          |   201 +
 drivers/usb/musb/musb_am335x.c                     |     1 -
 drivers/usb/musb/musb_core.c                       |    74 +-
 drivers/usb/musb/musb_core.h                       |     3 +
 drivers/usb/musb/musb_cppi41.c                     |     2 +-
 drivers/usb/musb/musb_dsps.c                       |   118 +-
 drivers/usb/musb/musb_gadget.c                     |    16 +-
 drivers/usb/musb/musb_host.c                       |    13 +-
 drivers/usb/musb/musb_host.h                       |     6 +
 drivers/usb/musb/musb_virthub.c                    |    70 +-
 drivers/usb/musb/tusb6010.c                        |     1 -
 drivers/usb/musb/tusb6010_omap.c                   |     1 -
 drivers/usb/musb/ux500.c                           |     1 -
 drivers/usb/musb/ux500_dma.c                       |     4 +-
 drivers/usb/phy/Kconfig                            |    52 +-
 drivers/usb/phy/Makefile                           |     7 +-
 drivers/usb/phy/phy-ab8500-usb.c                   |     2 -
 drivers/usb/phy/phy-am335x-control.c               |     6 +-
 drivers/usb/phy/phy-am335x.c                       |    39 +-
 drivers/usb/phy/phy-fsl-usb.c                      |     8 +-
 drivers/usb/phy/phy-fsl-usb.h                      |     2 +-
 drivers/usb/phy/phy-fsm-usb.c                      |    14 +-
 drivers/usb/phy/phy-generic.c                      |     1 -
 drivers/usb/phy/phy-gpio-vbus-usb.c                |     2 -
 drivers/usb/phy/phy-isp1301-omap.c                 |     9 +-
 drivers/usb/phy/phy-keystone.c                     |   136 +
 drivers/usb/phy/phy-msm-usb.c                      |     1 +
 drivers/usb/phy/phy-mv-usb.c                       |     7 +-
 drivers/usb/phy/phy-mxs-usb.c                      |    13 +-
 drivers/usb/phy/phy-omap-control.c                 |    19 +
 drivers/usb/phy/phy-omap-otg.c                     |   169 +
 drivers/usb/phy/phy-rcar-gen2-usb.c                |     2 +-
 drivers/usb/phy/phy-tahvo.c                        |   457 +
 drivers/usb/phy/phy-twl6030-usb.c                  |     2 +-
 drivers/usb/phy/phy.c                              |     4 +
 drivers/usb/renesas_usbhs/fifo.c                   |    18 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |     4 +-
 drivers/usb/renesas_usbhs/mod_host.c               |     1 +
 drivers/usb/serial/Kconfig                         |    29 +
 drivers/usb/serial/Makefile                        |     1 +
 drivers/usb/serial/aircable.c                      |    10 +-
 drivers/usb/serial/ark3116.c                       |     5 +-
 drivers/usb/serial/belkin_sa.c                     |     3 +-
 drivers/usb/serial/bus.c                           |     4 +-
 drivers/usb/serial/ch341.c                         |   135 +-
 drivers/usb/serial/console.c                       |     3 -
 drivers/usb/serial/cp210x.c                        |     8 +-
 drivers/usb/serial/cyberjack.c                     |     3 +-
 drivers/usb/serial/cypress_m8.c                    |    67 +-
 drivers/usb/serial/cypress_m8.h                    |    30 +-
 drivers/usb/serial/digi_acceleport.c               |     1 -
 drivers/usb/serial/empeg.c                         |     1 -
 drivers/usb/serial/f81232.c                        |    55 +-
 drivers/usb/serial/ftdi_sio.c                      |    33 +-
 drivers/usb/serial/garmin_gps.c                    |    20 +-
 drivers/usb/serial/io_edgeport.c                   |    51 +-
 drivers/usb/serial/io_ti.c                         |    59 +-
 drivers/usb/serial/ipaq.c                          |     3 +-
 drivers/usb/serial/ipw.c                           |     1 -
 drivers/usb/serial/ir-usb.c                        |     9 +-
 drivers/usb/serial/iuu_phoenix.c                   |     3 +-
 drivers/usb/serial/keyspan.c                       |    11 +-
 drivers/usb/serial/keyspan_pda.c                   |     1 -
 drivers/usb/serial/keyspan_usa26msg.h              |     2 +-
 drivers/usb/serial/kl5kusb105.c                    |    17 +-
 drivers/usb/serial/kobil_sct.c                     |     1 -
 drivers/usb/serial/mct_u232.c                      |     1 -
 drivers/usb/serial/metro-usb.c                     |     5 +-
 drivers/usb/serial/mos7720.c                       |    37 +-
 drivers/usb/serial/mos7840.c                       |    21 +-
 drivers/usb/serial/mxuport.c                       |  1393 +++
 drivers/usb/serial/navman.c                        |     1 -
 drivers/usb/serial/omninet.c                       |     1 -
 drivers/usb/serial/opticon.c                       |    11 +-
 drivers/usb/serial/option.c                        |    15 +
 drivers/usb/serial/oti6858.c                       |    73 +-
 drivers/usb/serial/pl2303.c                        |   511 +-
 drivers/usb/serial/qcaux.c                         |     3 +-
 drivers/usb/serial/quatech2.c                      |     9 +-
 drivers/usb/serial/safe_serial.c                   |     3 +-
 drivers/usb/serial/sierra.c                        |    10 +-
 drivers/usb/serial/spcp8x5.c                       |     1 -
 drivers/usb/serial/ssu100.c                        |     5 -
 drivers/usb/serial/symbolserial.c                  |     1 -
 drivers/usb/serial/ti_usb_3410_5052.c              |    27 +-
 drivers/usb/serial/usb-serial-simple.c             |     1 -
 drivers/usb/serial/usb-serial.c                    |     2 +-
 drivers/usb/serial/usb_debug.c                     |     1 -
 drivers/usb/serial/usb_wwan.c                      |     6 +-
 drivers/usb/serial/visor.c                         |    19 +-
 drivers/usb/serial/visor.h                         |     2 +-
 drivers/usb/serial/whiteheat.c                     |     9 +-
 drivers/usb/serial/wishbone-serial.c               |     1 -
 drivers/usb/serial/xsens_mt.c                      |     1 -
 drivers/usb/serial/zte_ev.c                        |    21 +-
 drivers/usb/storage/onetouch.c                     |     1 -
 drivers/usb/storage/protocol.c                     |    81 +-
 drivers/usb/storage/unusual_devs.h                 |     7 +
 drivers/usb/storage/usb.c                          |     1 -
 drivers/usb/usb-skeleton.c                         |     1 -
 drivers/usb/wusbcore/cbaf.c                        |    22 +-
 drivers/usb/wusbcore/crypto.c                      |     2 +-
 drivers/usb/wusbcore/devconnect.c                  |     4 +-
 drivers/usb/wusbcore/mmc.c                         |     9 +-
 drivers/usb/wusbcore/pal.c                         |     1 +
 drivers/usb/wusbcore/reservation.c                 |     1 +
 drivers/usb/wusbcore/security.c                    |    42 +-
 drivers/usb/wusbcore/wa-hc.h                       |    25 +-
 drivers/usb/wusbcore/wa-nep.c                      |    10 +-
 drivers/usb/wusbcore/wa-rpipe.c                    |    19 +-
 drivers/usb/wusbcore/wa-xfer.c                     |   513 +-
 drivers/usb/wusbcore/wusbhc.c                      |    17 +-
 drivers/usb/wusbcore/wusbhc.h                      |     7 +-
 drivers/uwb/beacon.c                               |     9 +-
 drivers/uwb/radio.c                                |     6 +-
 drivers/uwb/rsv.c                                  |    16 +-
 drivers/uwb/umc-bus.c                              |     2 +-
 drivers/uwb/umc-dev.c                              |     1 +
 drivers/watchdog/pcwd_usb.c                        |    40 +-
 firmware/emi62/bitstream.HEX                       | 10325 +++++++++++--------
 include/linux/phy/phy.h                            |    28 +
 include/linux/platform_data/usb-ehci-orion.h       |     6 +-
 include/linux/platform_data/usb-omap1.h            |    53 +
 include/linux/scatterlist.h                        |     1 +
 include/linux/tty.h                                |     1 +
 include/linux/usb.h                                |     1 +
 include/linux/usb/chipidea.h                       |     1 +
 include/linux/usb/composite.h                      |     2 +
 include/linux/usb/functionfs.h                     |    30 -
 include/linux/usb/gadget.h                         |    58 +-
 include/linux/usb/hcd.h                            |     3 +
 include/linux/usb/musb.h                           |     3 +
 include/linux/usb/omap_control_usb.h               |     6 +
 .../phy-fsm-usb.h => include/linux/usb/otg-fsm.h   |    10 +-
 include/linux/uwb/umc.h                            |     2 +-
 lib/scatterlist.c                                  |     3 +-
 367 files changed, 16189 insertions(+), 8071 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-ffs
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-loopback
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-sourcesink
 create mode 100644 Documentation/ABI/testing/sysfs-platform-tahvo-usb
 create mode 100644 Documentation/devicetree/bindings/phy/bcm-phy.txt
 rename Documentation/devicetree/bindings/usb/{ci13xxx-imx.txt => ci-hdrc-imx.txt} (100%)
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
 create mode 100644 drivers/usb/serial/mxuport.c
 create mode 100644 include/linux/platform_data/usb-omap1.h
 rename drivers/usb/phy/phy-fsm-usb.h => include/linux/usb/otg-fsm.h (96%)
