Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab3IBXyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 19:54:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab3IBXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:54:42 -0400
Date: Mon, 2 Sep 2013 16:57:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.12-rc1
Message-ID: <20130902235717.GA4544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.12-rc1

for you to fetch changes up to b9a1048137f4ae43ee90f61a3f34f0efe863cfeb:

  usbcore: fix incorrect type in assignment in descriptors_changed() (2013-08-30 18:50:43 -0700)

----------------------------------------------------------------
USB patches for 3.12-rc1

Here's the big USB driver pull request for 3.12-rc1

Lots of USB driver fixes and updates.  Nothing major, just the normal
xhci, gadget, and other driver changes.  Full details in the shortlog.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Al Cooper (1):
      usb: Add Device Tree support to XHCI Platform driver

Alan Stern (9):
      USB: remove redundant "#if"
      USB: simplify the interface of usb_get_status()
      USB: refactor code for enabling/disabling remote wakeup
      USB: handle LPM errors during device suspend correctly
      USB: EHCI: keep better track of resuming ports
      USB: EHCI: don't depend on hardware for tracking port resets and resumes
      USB: handle LPM errors during device suspend correctly
      USB: OHCI: Allow runtime PM without system sleep
      USB: fix build error when CONFIG_PM_SLEEP isn't enabled

Alexey Khoroshilov (1):
      usb: gadget: amd5536udc: unconditionally use GFP_ATOMIC in udc_queue()

Anatolij Gustschin (1):
      usb: phy: fix build breakage

Andrzej Pietrasiewicz (1):
      usb: gadget: configfs: keep a function if it is not successfully added

Andy Shevchenko (4):
      usbtmc: remove trailing spaces
      usbtmc: call pr_err instead of plain printk
      usbtmc: remove redundant braces
      usbtmc: convert to devm_kzalloc

Boris BREZILLON (4):
      usb: gadget: atmel_usba: prepare clk before calling enable
      USB: ohci-at91: add usb_clk for transition to common clk framework
      usb: gadget: at91_udc: add missing clk_put on fclk and iclk
      usb: gadget: at91_udc: add usb_clk for transition to common clk framework

Chen Wang (1):
      USB: usb-skeleton.c: add retry for nonblocking read

Dan Carpenter (6):
      USB: mos7720: use GFP_ATOMIC under spinlock
      usb: gadget: gadgetfs: use after free in dev_release()
      usb: gadget: gadgetfs: potential use after free in unbind()
      usb: phy: signedness bugs in suspend/resume functions
      usb: gadget: double unlocks on error in atmel_usba_start()
      dma: cppi41: off by one in desc_to_chan()

Daniel Mack (1):
      usb: ehci-mxc: check for pdata before dereferencing

David Daney (1):
      usb: Move definition of USB_EHCI_BIG_ENDIAN_MMIO et al. out side of the ifs.

Dmitry Kasatkin (2):
      xhci:prevent "callbacks suppressed" when debug is not enabled
      dev-core: fix build break when DEBUG is enabled

Fabio Estevam (4):
      usb: phy: phy-mxs-usb: Check the return value from stmp_reset_block()
      usb: chipidea: ci_hdrc_imx: remove unused variable 'res'
      usb: chipidea: move hw_phymode_configure() into probe
      usb: chipidea: remove previous MODULE_ALIAS

Felipe Balbi (32):
      usb: class: cdc-acm: be careful with bInterval
      usb: atm: speedtch: be careful with bInterval
      usb: clamp bInterval to allowed range
      usb: dwc3: make glue layers selectable
      usb: gadget: remove imx_udc
      usb: dwc3: gadget: don't request IRQs in atomic
      usb: dwc3: switch to GPL v2 only
      usb: phy: protect against NULL phy pointers
      usb: common: introduce of_usb_get_maximum_speed()
      usb: dwc3: let non-DT platforms pass tx-fifo-resize flag;
      usb: dwc3: make maximum-speed a per-instance attribute
      usb: dwc3: core: switch to snps,dwc3
      usb: dwc3: gadget: drop dwc3 manual phy control
      usb: dwc3: omap: switch over to devm_ioremap_resource()
      usb: dwc3: core: switch over to devm_ioremap_resource()
      usb: dwc3: gadget: move debugging print around
      usb: dwc3: gadget: move direction setting up
      usb: dwc3: gadget: add a debugging print when initializing endpoints
      usb: dwc3: core: don't redefine DWC3_DCFG_LPM_CAP
      usb: dwc3: gadget: don't enable LPM early
      usb: dwc3: core: introduce and use macros for Event Size register
      usb: dwc3: gadget: get rid of IRQF_ONESHOT
      usb: dwc3: gadget: rename dwc3_process_event_buf
      usb: dwc3: gadget: introduce dwc3_process_event_buf
      usb: gadget: udc-core: move sysfs_notify() to a workqueue
      usb: dwc3: ep0: only change to ADDRESS if set_config() succeeds
      usb: dwc3: ep0: don't change to configured state too early
      usb: of: fix build breakage caused by recent patches
      usb: dwc3: use dev_get_platdata()
      Merge branch 'nop-phy-rename' into next
      usb: musb: dsps: make it depend on OF_IRQ
      usb: dwc3: core: cope with NULL pdata

Feng-Hsin Chiang (1):
      usb: host: Faraday fotg210-hcd driver

Frank Schäfer (12):
      USB: serial: pl2303: fix the upper baud rate limit check for type_0/1 chips
      USB: pl2303: restrict the divisor based baud rate encoding method to the "HX" chip type
      usb: pl2303: fix+improve the divsor based baud rate encoding method
      usb: pl2303: do not round to the next nearest standard baud rate for the divisor based baud rate encoding method
      usb: pl2303: remove 500000 baud from the list of standard baud rates
      usb: pl2303: move the two baud rate encoding methods to separate functions
      usb: pl2303: increase the allowed baud rate range for the divisor based encoding method
      usb: pl2303: also use the divisor based baud rate encoding method for baud rates < 115200 with HX chips
      usb: pl2303: add two comments concerning the supported baud rates with HX chips
      pl2303: simplify the else-if contruct for type_1 chips in pl2303_startup()
      pl2303: improve the chip type information output on startup
      pl2303: improve the chip type detection/distinction

Geert Uytterhoeven (3):
      usb: gadget: USB_FUSB300 should depend on HAS_DMA
      usb: gadget: USB_R8A66597 should depend on HAS_DMA
      usb: gadget: USB_NET2272_DMA should depend on HAS_DMA

Graham Williams (1):
      usb: acm gadget: Null termintate strings table

Greg Kroah-Hartman (46):
      USB: ldusb: remove custom dbg_info() macro
      USB: legotower: remove unneeded tracing macros
      USB: legousbtower: remove custom debug macro
      USB: legotower: remove custom debug macro and module parameter
      USB: legotower: remove direct calls to printk()
      USB: adutux: remove unneeded tracing macros
      USB: adutux: remove custom debug macro
      USB: adutux: remove custom debug macro and module parameter
      USB: adutux: remove direct calls to printk()
      USB: misc: remove CONFIG_USB_DEBUG from Makefile
      USB: usbatm: remove unused UDSL_ASSERT macro
      USB: usbatm: remove unneeded trace printk calls
      USB: usbatm: don't rely on CONFIG_USB_DEBUG
      USB: usbatm: move the atm_dbg() call to use dynamic debug
      USB: usbatm: remove CONFIG_USB_DEBUG dependancy
      USB: phy: remove custom DBG macro
      USB: phy: remove CONFIG_USB_DEBUG usage
      USB: gadget: fix up comment
      USB: isp1362: remove unused _BUG_ON() calls
      USB: isp1362: remove unused _WARN_ON() calls
      USB: isp1362: remove _DBG() usage
      USB: isp1362: remove CONFIG_USB_DEBUG dependency
      USB: isp116x: remove dependency on CONFIG_USB_DEBUG
      USB: sl811: remove CONFIG_USB_DEBUG dependency
      Merge tag 'for-usb-next-2013-07-23' of git://git.kernel.org/.../sarah/xhci into usb-next
      USB: remove unneeded idr.h include
      USB: sl811: move debug files from proc to debugfs
      USB: isp1362: move debug files from proc to debugfs
      Revert "usb: host: Faraday fotg210-hcd driver"
      usb: musb: get rid of unused proc_dir_entry
      Merge 3.11-rc3 into usb-next
      Merge 3.11-rc4 into usb-next
      USB: serial: move the "simple" drivers into usb-serial-simple.c
      Merge tag 'usb-for-v3.12' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'for-usb-next-2013-08-15' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge 3.11-rc6 into usb-next
      Merge tag 'for-usb-2013-08-15-step-2' of ra.kernel.org:/.../sarah/xhci into work-next
      USB: core: use DRIVER_ATTR_RW()
      USB: core: be specific about attribute permissions
      USB: usbtmc: fix up attribute permissions
      USB: serial: clean up attribute permissions
      USB: gadget: audit sysfs attribute permissions
      Merge tag 'for-usb-next-2013-08-27' of git://git.kernel.org/.../sarah/xhci into usb-next
      USB storage: audit sysfs attribute permissions
      Merge tag 'usb-for-v3.12-part2' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'for-usb-next-2013-08-27-15-07' of git://git.kernel.org/.../sarah/xhci into usb-next

H Hartley Sweeten (4):
      usb: ohci-ep93xx: use devm_ioremap_resource()
      usb: ohci-ep93xx: use platform_get_irq()
      usb: ohci-ep93xx: use devm_clk_get()
      usb: ohci-ep93xx: tidy up driver (*probe) and (*remove)

Hans de Goede (8):
      usbfs: Allow printer class 'get_device_id' without needing to claim the intf
      usb: config->desc.bLength may not exceed amount of data returned by the device
      proc_usb_info.txt: Correct documentation about endianness of config descriptors
      Documentation sysfs-bus-usb: Correct use of devnum
      Documentation sysfs-bus-usb: Document all files used by libusb
      Documentation sysfs-bus-usb: Move files with known users to stable
      Documentation sysfs-bus-usb: Document the speed file used by libusb
      Documentation sysfs-bus-usb: Document which files are used by libusb

Huang Rui (2):
      usb: dwc3: clean up redundant parameter comment
      usb: dwc3: fix typo in comment of dwc3_ep

Ivan T. Ivanov (1):
      usb: dwc3: core: modify IO memory resource after deferred probe completes

Jack Pham (1):
      usb: host: add Kconfig option for EHSET

Jingoo Han (18):
      usb: gadget: use dev_get_platdata()
      usb: phy: use dev_get_platdata()
      usb: musb: use dev_get_platdata()
      usb: renesas: use dev_get_platdata()
      USB: c67x00: use dev_get_platdata()
      usb: renesas: use dev_get_platdata()
      usb: misc: usb3503: use dev_get_platdata()
      USB: host: use dev_get_platdata()
      usb: dwc3: pci: add CONFIG_PM_SLEEP to suspend/resume functions
      usb: gadget: goku_udc: use NULL instead of 0
      usb: gadget: fusb300_udc: Staticize fusb300_rdcxf()
      usb: gadget: f_mass_storage: use NULL instead of 0
      usb: gadget: rndis: Staticize rndis_init()/rndis_exit()
      usb: gadget: u_uac1: add __user annotation
      usb: gadget: f_uac1: Staticize local functions
      usb: phy: mv-u3d: Staticize mv_u3d_phy_shutdown()
      usb: phy: mv-usb: remove incorrect __exit_p annotation
      uwb: Staticize local symbols

Joe Perches (2):
      xhci: Correct misplaced newlines
      MAINTAINERS: USB, remove F: drivers/net/usb/ pattern

Johan Hovold (29):
      USB: serial: remove defensive test from set_termios
      USB: serial: remove hupping check from tiocmiwait
      USB: serial: clean up dtr_rts
      USB: serial: set drain delay at port probe
      USB: console: use dev_dbg
      USB: console: remove unnecessary operations test
      USB: pl2303: refactor baud-rate handling
      USB: pl2303: clean up baud-rate handling
      USB: pl2303: clean up set_termios
      USB: pl2303: remove debugging noise
      USB: oti6858: do not call set_termios with uninitialised data
      USB: ftdi_sio: clean up device initialisation
      USB: ftdi_sio: remove redundant raise of DTR/RTS at open
      USB: ftdi_sio: remove vendor/product module parameters
      USB: ftdi_sio: remove unused defines
      USB: io_edgeport: remove unused defines
      USB: io_ti: kill private fifo
      USB: io_ti: move port initialisation to probe
      USB: mos7840: remove broken chase implementation
      USB: safe_serial: remove vendor/product module parameters
      USB: ti_usb_3410_5052: kill private fifo
      USB: ti_usb_3410_5052: remove unused wait queue
      USB: ti_usb_3410_5052: remove vendor/product module parameters
      USB: keyspan: fix serial DMA-buffer allocations
      USB: keyspan: fix port DMA-buffer allocations
      USB: quatech2: fix serial DMA-buffer allocations
      USB: quatech2: fix port DMA-buffer allocations
      USB: uss720: fix DMA-buffer allocation
      USB: mos7720: fix big-endian control requests

Julia Lawall (1):
      usb: musb: dsps: fix devm_ioremap_resource error detection code

Julius Werner (1):
      usb: core: don't try to reset_device() a port that got just disconnected

Krzysztof Mazur (3):
      usb: fix cleanup after failure in hub_configure()
      usb: fail on usb_hub_create_port_device() errors
      usb: don't use bNbrPorts after initialization

Kumar Gala (1):
      usb: dwc3: core: clarify usb-phy array binding

Kuninori Morimoto (1):
      usb: renesas_usbhs: tidyup original usbhsx_for_each_xxx macro

Lan Tianyu (1):
      usb: don't check pm qos NO_POWER_OFF flag in usb_port_suspend()

Laurent Pinchart (1):
      usb: gadget: uvc: Fix error handling in uvc_queue_buffer()

Lee Jones (1):
      usb: musb: ux500: Add check for NULL board data

Libo Chen (5):
      usb: fotg210-udc: use platform_{get,set}_drvdata()
      usb: renesas_usbhs: use platform_{get,set}_drvdata()
      usb: ohci-at91: remove unnecessary dev_set_drvdata()
      usb: phy-tegra-usb: use platform_{get,set}_drvdata()
      usb: r8a66597-hcd: use platform_{get,set}_drvdata()

Lothar Waßmann (4):
      usb: chipidea: improve kconfig 2.0
      usb: chipidea: ci_hdrc_imx: remove an unsolicited module_put() call from ci_hdrc_imx_remove()
      usb: chipidea: don't clobber return value of ci_role_start()
      usb: chipidea: prevent endless loop registering platform_devices when probe fails

Maarten ter Huurne (1):
      usb: musb: avoid null pointer dereference in debug logging

Manu Gautam (2):
      usb: misc: EHSET Test Fixture device driver for host compliance
      usb: ehci: Add support for SINGLE_STEP_SET_FEATURE test of EHSET

Mark Brown (12):
      usb: misc: Fix swapped properties in usb3503 DT parsing
      usb: misc: usb3503: Convert to devm_ APIs
      usb: misc: usb3503: Use gpio_set_value_cansleep()
      usb: misc: usb3503: Actively manage Hub Connect GPIO
      usb: misc: usb3503: Convert to regmap
      usb: misc: usb3503: Factor out I2C probe
      usb: misc: usb3503: Fix typos in error messages
      usb: misc: usb3503: Default to hub mode
      usb: misc: usb3503: Add USB3503A to the compatible list
      usb: misc: usb3503: Don't specify all DT properties as required
      usb: misc: usb3503: Support operation with no I2C control
      usb/hcd: Log error code if reset() fails

Mathias Nyman (2):
      Intel xhci: refactor EHCI/xHCI port switching
      xhci: fix port BESL LPM capability checking

Mikko Perttunen (6):
      arm: dts: tegra20: Rename USB UTMI parameters according to new definitions
      usb: phy: tegra: Read UTMIP parameters from device tree
      usb: tegra: Use regulators instead of GPIOs for USB PHY VBUS
      usb: tegra: Add vbus-supply property for host mode PHYs
      arm: tegra: Remove obsolete nvidia,vbus-gpio properties
      usb: tegra: Fix typo in tegra20-usb-phy documentation

Ming Lei (10):
      USB: check sg buffer size in usb_submit_urb
      USB: HCD: support giveback of URB in tasklet context
      USB: URB documentation: claim complete() will be run with IRQs enabled
      USB: EHCI: improve ehci_endpoint_disable
      USB: EHCI: improve interrupt qh unlink
      USB: EHCI: support running URB giveback in tasklet context
      USB: introduce usb_device_no_sg_constraint() helper
      USB: XHCI: mark no_sg_constraint
      USBNET: support DMA SG
      USBNET: ax88179_178a: enable tso if usb host supports sg dma

Oliver Neukum (1):
      USB: cdc-wdm: fix race between interrupt handler and tasklet

Paul Gortmaker (1):
      usb: limit OMAP related USB options to OMAP2PLUS platforms

Peter Chen (14):
      usb: chipidea: imx: delete the dead code
      usb: chipidea: move vbus regulator operation to core
      usb: chipidea: host: add vbus regulator control
      usb: chipidea: udc: otg_set_peripheral is useless for some chipidea users
      usb: chipidea: otg: add otg file used to access otgsc
      usb: chipidea: add role init and destroy APIs
      usb: chipidea: add flag CI_HDRC_DUAL_ROLE_NOT_OTG
      usb: chipidea: disable all interrupts and clear all interrupts status
      usb: chipidea: move otg related things to otg file
      usb: chipidea: add vbus interrupt handler
      usb: chipidea: add wait vbus lower than OTGSC_BSV before role starts
      usb: chipidea: udc: fix misuse of REGS_SHARED and PULLUP_ON_VBUS flags
      usb: chipidea: retire flag CI_HDRC_PULLUP_ON_VBUS
      usb: chipidea: udc: .pullup is valid only when vbus is there

Philippe De Swert (1):
      usb:gadget Fix comment for pointer to configfs

Roger Quadros (4):
      USB: host: Use usb_hcd_platform_shutdown() wherever possible
      usb: phy: make PHY driver selection possible by controller drivers
      usb: ehci-omap: select NOP_USB_XCEIV PHY driver
      usb: phy: omap-usb3: Improve DPLL parameter lookup code

Ruchika Kharwar (1):
      usb: dwc3: adapt to use dr_mode device tree helper

Sachin Kamat (1):
      usb: dwc3: Remove duplicate inclusion of otg.h

Sarah Sharp (6):
      xhci: Refactor port status into a new function.
      xhci: Report USB 2.1 link status for L1
      usb: Don't fail port power resume on device disconnect.
      xhci-plat: Don't enable legacy PCI interrupts.
      Merge tag 'for-usb-2013-08-15-step-1' into for-usb-next
      xhci: Fix warning introduced by disabling runtime PM.

Sascha Hauer (1):
      USB: chipidea: i.MX: simplify usbmisc

Sean O. Stalley (1):
      usb: rh_call_control tbuf overflow fix

Sebastian Andrzej Siewior (32):
      usb: musb: replace ifndef with ifdef for CONFIG_MUSB_PIO_ONLY
      usb: musb: musbhsdma: drop the controller check in dma_controller_destroy()
      usb: musb: dma: merge ->start/stop into create/destroy
      usb: musb: provide empty dma_controller_create() in PIO mode
      usb: musb: remove a few is_dma_capable() in init/exit code
      usb: musb: core: call dma_controller_destroy() in the err path
      usb: musb: unmap reqs in musb_gadget_queue()'s error case
      usb: musb: dsps: init / shutdown the phy
      usb: musb: remove ti81xx pieces from musb
      usb: musb: do not change dev's dma_mask
      usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
      usb: musb: dsps: remove EOI access
      usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv
      usb: phy: phy-generic: export init functions
      usb: phy: Add AM335x PHY driver
      usb: musb: dsps: remove the hardcoded phy pieces
      usb: musb: dsps: use proper child nodes
      usb: musb dma: add cppi41 dma driver
      usb: musb: Use is_cppi_enabled() and tusb_dma_omap() instead of the ifdef
      usb: musb: cppi41: Enable in device-TX mode
      usb: phy: am335x: include linux/err.h
      usb: musb: honour the return value of dma_map_single()
      usb: phy: am335x-control: make it compile with
      dma: cpp41: make it compile with CONFIG_BUG=n
      usb: musb: only remove host/udc if it has been added
      usb: musb: dsps fix the typo in reg-names of the dma node
      usb: usb: dsps: update device tree bindings
      usb: usb: dsps: update code according to the binding document
      usb: musb: dsps: do not set is_active on the first drvbus interrupt
      usb: musb: am335x-evm: Do not remove the session bit HOST-only mode
      usb: musb: am335x: add second port to beagle bone
      dma: cpp41: enable pm_runtime during init

Shawn Nematbakhsh (1):
      usb: xhci: Disable runtime PM suspend for quirky controllers

Thomas Pugliese (9):
      wusbcore: fix root hub hub_status_data to only return > 0 if status has actually changed
      wusbcore: clean up list locking in urb enqueue
      HWA RC: fix a kernel panic when unplugging the HWA dongle
      HWA: avoid constant suspend and resume on the root hub
      UWB: fix sysfs warning on HWA device unplug.
      USB: WUSBCORE: clear RPIPE stall for control endpoints
      USB: WUSBCORE: fix resource cleanup in error path in __wa_xfer_setup_segs
      USB: WUSBCORE: fix leak of urb in wa_xfer_destroy.
      USB: WUSBCORE: Use usb_init_urb instead of creating the URB manually

Tomasz Figa (1):
      usb: gadget: s3c-hsotg: Allow driver instantiation using device tree

Tuomas Tynkkynen (16):
      usb: phy: tegra: Remove unnecessary 'dev' field
      usb: host: tegra: Remove leftover code
      usb: tegra: host: Remove references to plat data
      ARM: tegra: Remove USB platform data
      usb: phy: tegra: Register as an USB PHY.
      usb: host: tegra: Locate a PHY via standard API
      usb: phy: tegra: Remove custom PHY locating APIs
      usb: phy: tegra: Use DT helpers for phy_type
      usb: phy: tegra: Use DT helpers for dr_mode
      usb: phy: tegra: Use switch instead of if-else
      usb: host: add has_tdi_phy_lpm capability bit
      usb: phy: tegra: Fix wrong PHY parameters
      usb: phy: tegra: Tegra30 support
      Documentation: New DT parameters for tegra30-usb-phy
      usb: phy: tegra: Program new PHY parameters
      usb: host: tegra: Tegra30 support

Vikas Sajjan (1):
      usb: xhci: add the suspend/resume functionality

Wei Yongjun (1):
      usb: musb: cppi41: fix missing unlock on error in cppi41_dma_callback()

Wolfram Sang (1):
      usb: phy: don't check resource with devm_ioremap_resource

Xenia Ragiadakou (19):
      xhci: replace xhci_info() with xhci_dbg()
      xhci: replace printk(KERN_DEBUG ...)
      xhci: remove CONFIG_USB_XHCI_HCD_DEBUGGING and unused code
      xhci: add traces for debug messages in xhci_address_device()
      xhci: add trace for debug messages related to changing contexts
      xhci: add trace for debug messages related to quirks
      xhci: add trace for debug messages related to endpoint reset
      xhci: add xhci_address_ctx trace event
      xhci: add xhci_cmd_completion trace event
      xhci: trace debug statements for urb cancellation
      xhci: trace debug messages related to driver initialization and unload
      xhci: trace debug statements related to ring expansion
      xhci: fix dma mask setup in xhci.c
      ehci: remove ehci_vdbg() verbose debugging statements
      ehci: enable debugging code when CONFIG_DYNAMIC_DEBUG is set
      ehci: remove duplicate debug_async_open() prototype in ehci-dbg.c
      ehci: remove debugging statement with ehci statistics in ehci_stop()
      usbcore: compare and release one bos descriptor in usb_reset_and_verify_device()
      usbcore: fix incorrect type in assignment in descriptors_changed()

Yacine Belkadi (1):
      usb: fix some scripts/kernel-doc warnings

Yann Droneaud (1):
      USB: serial: fix stringify operator in usb-serial-simple

Yuan-Hsin Chen (1):
      usb: host: Faraday fotg210-hcd driver

caizhiyong (1):
      USB: ohci_usb warn "irq nobody cared" on shutdown

 Documentation/ABI/stable/sysfs-bus-usb             |  142 +
 Documentation/ABI/testing/sysfs-bus-usb            |   89 -
 .../devicetree/bindings/usb/am33xx-usb.txt         |  222 +-
 Documentation/devicetree/bindings/usb/dwc3.txt     |    8 +-
 Documentation/devicetree/bindings/usb/generic.txt  |   24 +
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   17 +-
 .../devicetree/bindings/usb/samsung-hsotg.txt      |   40 +
 Documentation/devicetree/bindings/usb/usb-xhci.txt |   14 +
 Documentation/devicetree/bindings/usb/usb3503.txt  |    7 +-
 Documentation/usb/URB.txt                          |   21 +-
 Documentation/usb/proc_usb_info.txt                |    9 +-
 MAINTAINERS                                        |    1 -
 arch/arm/boot/dts/am335x-bone.dts                  |   29 +
 arch/arm/boot/dts/am335x-evm.dts                   |   29 +
 arch/arm/boot/dts/am335x-evmsk.dts                 |   16 +
 arch/arm/boot/dts/am33xx.dtsi                      |  143 +-
 arch/arm/boot/dts/omap5.dtsi                       |    2 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |    1 -
 arch/arm/boot/dts/tegra20-trimslice.dts            |    1 -
 arch/arm/boot/dts/tegra20-whistler.dts             |    2 -
 arch/arm/boot/dts/tegra20.dtsi                     |   28 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    4 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    4 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
 arch/arm/mach-omap2/usb-host.c                     |   10 +-
 arch/arm/mach-tegra/tegra.c                        |   38 +-
 drivers/dma/Kconfig                                |    8 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/cppi41.c                               | 1059 ++++
 drivers/net/usb/ax88179_178a.c                     |    8 +
 drivers/net/usb/usbnet.c                           |   45 +-
 drivers/usb/Kconfig                                |   17 +
 drivers/usb/Makefile                               |    3 +-
 drivers/usb/atm/Makefile                           |    3 -
 drivers/usb/atm/speedtch.c                         |    2 +-
 drivers/usb/atm/usbatm.c                           |   49 +-
 drivers/usb/atm/usbatm.h                           |   35 +-
 drivers/usb/c67x00/c67x00-drv.c                    |    4 +-
 drivers/usb/chipidea/Kconfig                       |    7 +-
 drivers/usb/chipidea/Makefile                      |    2 +-
 drivers/usb/chipidea/bits.h                        |   10 +
 drivers/usb/chipidea/ci.h                          |    8 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  110 +-
 drivers/usb/chipidea/ci_hdrc_imx.h                 |   17 +-
 drivers/usb/chipidea/ci_hdrc_msm.c                 |    1 -
 drivers/usb/chipidea/core.c                        |  197 +-
 drivers/usb/chipidea/host.c                        |   31 +-
 drivers/usb/chipidea/host.h                        |    6 +
 drivers/usb/chipidea/otg.c                         |  120 +
 drivers/usb/chipidea/otg.h                         |   35 +
 drivers/usb/chipidea/udc.c                         |   78 +-
 drivers/usb/chipidea/udc.h                         |    6 +
 drivers/usb/chipidea/usbmisc_imx.c                 |   95 +-
 drivers/usb/class/cdc-acm.c                        |    2 +-
 drivers/usb/class/cdc-wdm.c                        |   13 +-
 drivers/usb/class/usbtmc.c                         |   62 +-
 drivers/usb/core/buffer.c                          |    5 +-
 drivers/usb/core/config.c                          |    3 +-
 drivers/usb/core/devio.c                           |    6 +-
 drivers/usb/core/driver.c                          |   46 +-
 drivers/usb/core/endpoint.c                        |   37 +-
 drivers/usb/core/file.c                            |    2 +-
 drivers/usb/core/hcd-pci.c                         |    2 +
 drivers/usb/core/hcd.c                             |  227 +-
 drivers/usb/core/hub.c                             |  235 +-
 drivers/usb/core/message.c                         |   62 +-
 drivers/usb/core/port.c                            |   20 +-
 drivers/usb/core/sysfs.c                           |  303 +-
 drivers/usb/core/urb.c                             |   43 +-
 drivers/usb/core/usb.c                             |   60 +-
 drivers/usb/dwc3/Kconfig                           |   32 +
 drivers/usb/dwc3/Makefile                          |   13 +-
 drivers/usb/dwc3/core.c                            |  197 +-
 drivers/usb/dwc3/core.h                            |   53 +-
 drivers/usb/dwc3/debug.h                           |   34 +-
 drivers/usb/dwc3/debugfs.c                         |   34 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |   22 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   44 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   54 +-
 drivers/usb/dwc3/ep0.c                             |   49 +-
 drivers/usb/dwc3/gadget.c                          |  257 +-
 drivers/usb/dwc3/gadget.h                          |   34 +-
 drivers/usb/dwc3/host.c                            |   34 +-
 drivers/usb/dwc3/io.h                              |   34 +-
 drivers/usb/dwc3/platform_data.h                   |   27 +
 drivers/usb/gadget/Kconfig                         |   24 +-
 drivers/usb/gadget/Makefile                        |    1 -
 drivers/usb/gadget/amd5536udc.c                    |    4 +-
 drivers/usb/gadget/at91_udc.c                      |   25 +-
 drivers/usb/gadget/at91_udc.h                      |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   26 +-
 drivers/usb/gadget/bcm63xx_udc.c                   |    2 +-
 drivers/usb/gadget/composite.c                     |    8 +-
 drivers/usb/gadget/configfs.c                      |    4 +-
 drivers/usb/gadget/dummy_hcd.c                     |    8 +-
 drivers/usb/gadget/f_acm.c                         |    1 +
 drivers/usb/gadget/f_fs.c                          |    2 +-
 drivers/usb/gadget/f_mass_storage.c                |   18 +-
 drivers/usb/gadget/f_uac1.c                        |    4 +-
 drivers/usb/gadget/fotg210-udc.c                   |    4 +-
 drivers/usb/gadget/fsl_mxc_udc.c                   |    4 +-
 drivers/usb/gadget/fsl_udc_core.c                  |    6 +-
 drivers/usb/gadget/fusb300_udc.c                   |    2 +-
 drivers/usb/gadget/goku_udc.c                      |    2 +-
 drivers/usb/gadget/hid.c                           |    2 +-
 drivers/usb/gadget/imx_udc.c                       | 1544 -----
 drivers/usb/gadget/imx_udc.h                       |  351 --
 drivers/usb/gadget/inode.c                         |    4 -
 drivers/usb/gadget/m66592-udc.c                    |    4 +-
 drivers/usb/gadget/mv_u3d_core.c                   |   12 +-
 drivers/usb/gadget/mv_udc_core.c                   |    4 +-
 drivers/usb/gadget/net2272.c                       |    4 +-
 drivers/usb/gadget/net2280.c                       |   18 +-
 drivers/usb/gadget/omap_udc.c                      |    2 +-
 drivers/usb/gadget/pxa25x_udc.c                    |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    2 +-
 drivers/usb/gadget/r8a66597-udc.c                  |    2 +-
 drivers/usb/gadget/rndis.c                         |    4 +-
 drivers/usb/gadget/s3c-hsotg.c                     |   14 +-
 drivers/usb/gadget/s3c-hsudc.c                     |    4 +-
 drivers/usb/gadget/s3c2410_udc.c                   |    2 +-
 drivers/usb/gadget/storage_common.c                |   27 +-
 drivers/usb/gadget/u_uac1.c                        |    2 +-
 drivers/usb/gadget/udc-core.c                      |   26 +-
 drivers/usb/gadget/uvc_queue.c                     |    6 +-
 drivers/usb/host/Kconfig                           |   63 +-
 drivers/usb/host/Makefile                          |    5 +
 drivers/usb/host/ehci-dbg.c                        |    9 +-
 drivers/usb/host/ehci-fsl.c                        |   18 +-
 drivers/usb/host/ehci-grlib.c                      |   13 +-
 drivers/usb/host/ehci-hcd.c                        |   33 +-
 drivers/usb/host/ehci-hub.c                        |  232 +-
 drivers/usb/host/ehci-mem.c                        |    1 +
 drivers/usb/host/ehci-mv.c                         |    4 +-
 drivers/usb/host/ehci-mxc.c                        |   16 +-
 drivers/usb/host/ehci-octeon.c                     |    2 +-
 drivers/usb/host/ehci-omap.c                       |   14 +-
 drivers/usb/host/ehci-orion.c                      |    2 +-
 drivers/usb/host/ehci-pci.c                        |   42 -
 drivers/usb/host/ehci-platform.c                   |   12 +-
 drivers/usb/host/ehci-pmcmsp.c                     |    2 +-
 drivers/usb/host/ehci-ppc-of.c                     |   13 +-
 drivers/usb/host/ehci-ps3.c                        |    2 +-
 drivers/usb/host/ehci-q.c                          |  119 +-
 drivers/usb/host/ehci-s5p.c                        |   12 +-
 drivers/usb/host/ehci-sched.c                      |  105 +-
 drivers/usb/host/ehci-sead3.c                      |    2 +-
 drivers/usb/host/ehci-sh.c                         |    4 +-
 drivers/usb/host/ehci-tegra.c                      |   95 +-
 drivers/usb/host/ehci-tilegx.c                     |    6 +-
 drivers/usb/host/ehci-timer.c                      |   34 +-
 drivers/usb/host/ehci-w90x900.c                    |    2 +-
 drivers/usb/host/ehci-xilinx-of.c                  |   19 +-
 drivers/usb/host/ehci.h                            |   17 +-
 drivers/usb/host/fotg210-hcd.c                     | 6049 ++++++++++++++++++++
 drivers/usb/host/fotg210.h                         |  750 +++
 drivers/usb/host/fsl-mph-dr-of.c                   |    4 +-
 drivers/usb/host/hwa-hc.c                          |    7 +
 drivers/usb/host/imx21-hcd.c                       |    2 +-
 drivers/usb/host/isp116x-hcd.c                     |    2 +-
 drivers/usb/host/isp116x.h                         |   13 +-
 drivers/usb/host/isp1362-hcd.c                     |   85 +-
 drivers/usb/host/isp1362.h                         |   53 +-
 drivers/usb/host/isp1760-if.c                      |    2 +-
 drivers/usb/host/ohci-at91.c                       |   37 +-
 drivers/usb/host/ohci-da8xx.c                      |    8 +-
 drivers/usb/host/ohci-ep93xx.c                     |  137 +-
 drivers/usb/host/ohci-exynos.c                     |    2 +-
 drivers/usb/host/ohci-hcd.c                        |    2 +-
 drivers/usb/host/ohci-omap.c                       |    4 +-
 drivers/usb/host/ohci-omap3.c                      |   10 +-
 drivers/usb/host/ohci-pci.c                        |    2 +-
 drivers/usb/host/ohci-platform.c                   |   10 +-
 drivers/usb/host/ohci-ppc-of.c                     |   11 +-
 drivers/usb/host/ohci-pxa27x.c                     |    8 +-
 drivers/usb/host/ohci-s3c2410.c                    |   11 +-
 drivers/usb/host/ohci-tilegx.c                     |    4 +-
 drivers/usb/host/pci-quirks.c                      |   48 +-
 drivers/usb/host/pci-quirks.h                      |    3 +-
 drivers/usb/host/r8a66597-hcd.c                    |    6 +-
 drivers/usb/host/sl811-hcd.c                       |  109 +-
 drivers/usb/host/sl811.h                           |   21 +-
 drivers/usb/host/u132-hcd.c                        |    6 +-
 drivers/usb/host/xhci-dbg.c                        |   14 +
 drivers/usb/host/xhci-ext-caps.h                   |    2 +-
 drivers/usb/host/xhci-hub.c                        |  228 +-
 drivers/usb/host/xhci-mem.c                        |  187 +-
 drivers/usb/host/xhci-pci.c                        |   28 +-
 drivers/usb/host/xhci-plat.c                       |   48 +-
 drivers/usb/host/xhci-ring.c                       |  113 +-
 drivers/usb/host/xhci-trace.c                      |   15 +
 drivers/usb/host/xhci-trace.h                      |  151 +
 drivers/usb/host/xhci.c                            |  378 +-
 drivers/usb/host/xhci.h                            |   18 +-
 drivers/usb/misc/Kconfig                           |   14 +
 drivers/usb/misc/Makefile                          |    4 +-
 drivers/usb/misc/adutux.c                          |  200 +-
 drivers/usb/misc/ehset.c                           |  152 +
 drivers/usb/misc/ldusb.c                           |   31 +-
 drivers/usb/misc/legousbtower.c                    |  124 +-
 drivers/usb/misc/usb3503.c                         |  284 +-
 drivers/usb/misc/usbtest.c                         |    9 +-
 drivers/usb/misc/uss720.c                          |   24 +-
 drivers/usb/musb/Kconfig                           |    9 +
 drivers/usb/musb/Makefile                          |    4 +
 drivers/usb/musb/am35x.c                           |   16 +-
 drivers/usb/musb/blackfin.c                        |    4 +-
 drivers/usb/musb/cppi_dma.c                        |   18 +-
 drivers/usb/musb/da8xx.c                           |    4 +-
 drivers/usb/musb/davinci.c                         |    4 +-
 drivers/usb/musb/musb_am335x.c                     |   55 +
 drivers/usb/musb/musb_core.c                       |   31 +-
 drivers/usb/musb/musb_core.h                       |    8 -
 drivers/usb/musb/musb_cppi41.c                     |  557 ++
 drivers/usb/musb/musb_dma.h                        |   21 +-
 drivers/usb/musb/musb_dsps.c                       |  395 +-
 drivers/usb/musb/musb_gadget.c                     |  102 +-
 drivers/usb/musb/musb_host.c                       |    2 +
 drivers/usb/musb/musbhsdma.c                       |   17 +-
 drivers/usb/musb/omap2430.c                        |    8 +-
 drivers/usb/musb/tusb6010.c                        |    4 +-
 drivers/usb/musb/tusb6010_omap.c                   |   24 -
 drivers/usb/musb/ux500.c                           |    2 +-
 drivers/usb/musb/ux500_dma.c                       |   25 +-
 drivers/usb/phy/Kconfig                            |   50 +-
 drivers/usb/phy/Makefile                           |    7 +-
 drivers/usb/phy/am35x-phy-control.h                |   21 +
 drivers/usb/phy/phy-am335x-control.c               |  137 +
 drivers/usb/phy/phy-am335x.c                       |   99 +
 drivers/usb/phy/phy-fsl-usb.c                      |   12 +-
 drivers/usb/phy/phy-fsl-usb.h                      |    2 +-
 drivers/usb/phy/phy-fsm-usb.c                      |    2 +-
 drivers/usb/phy/phy-fsm-usb.h                      |   11 +-
 drivers/usb/phy/{phy-nop.c => phy-generic.c}       |  167 +-
 drivers/usb/phy/phy-generic.h                      |   20 +
 drivers/usb/phy/phy-gpio-vbus-usb.c                |   10 +-
 drivers/usb/phy/phy-isp1301-omap.c                 |    6 +-
 drivers/usb/phy/phy-msm-usb.c                      |    4 +-
 drivers/usb/phy/phy-mv-u3d-usb.c                   |    4 +-
 drivers/usb/phy/phy-mv-usb.c                       |    6 +-
 drivers/usb/phy/phy-mxs-usb.c                      |   13 +-
 drivers/usb/phy/phy-omap-control.c                 |    3 +-
 drivers/usb/phy/phy-omap-usb2.c                    |    7 +-
 drivers/usb/phy/phy-omap-usb3.c                    |   87 +-
 drivers/usb/phy/phy-rcar-usb.c                     |    9 +-
 drivers/usb/phy/phy-samsung-usb2.c                 |    2 +-
 drivers/usb/phy/phy-samsung-usb3.c                 |    2 +-
 drivers/usb/phy/phy-tegra-usb.c                    |  462 +-
 drivers/usb/phy/phy-twl4030-usb.c                  |    2 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |    2 +-
 drivers/usb/renesas_usbhs/common.c                 |    6 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |    6 +-
 drivers/usb/renesas_usbhs/mod_host.c               |    6 +-
 drivers/usb/renesas_usbhs/pipe.h                   |    6 +-
 drivers/usb/serial/Kconfig                         |   84 +-
 drivers/usb/serial/Makefile                        |    9 +-
 drivers/usb/serial/bus.c                           |    5 +-
 drivers/usb/serial/console.c                       |   27 +-
 drivers/usb/serial/cp210x.c                        |    3 -
 drivers/usb/serial/cypress_m8.c                    |    4 +-
 drivers/usb/serial/f81232.c                        |    3 +-
 drivers/usb/serial/flashloader.c                   |   39 -
 drivers/usb/serial/ftdi_sio.c                      |   67 +-
 drivers/usb/serial/funsoft.c                       |   40 -
 drivers/usb/serial/generic.c                       |   13 +-
 drivers/usb/serial/hp4x.c                          |   51 -
 drivers/usb/serial/io_edgeport.c                   |    2 -
 drivers/usb/serial/io_ti.c                         |   79 +-
 drivers/usb/serial/iuu_phoenix.c                   |    8 +-
 drivers/usb/serial/keyspan.c                       |  104 +-
 drivers/usb/serial/mos7720.c                       |    6 +-
 drivers/usb/serial/mos7840.c                       |   48 -
 drivers/usb/serial/moto_modem.c                    |   48 -
 drivers/usb/serial/oti6858.c                       |   10 +-
 drivers/usb/serial/pl2303.c                        |  352 +-
 drivers/usb/serial/quatech2.c                      |   35 +-
 drivers/usb/serial/safe_serial.c                   |   51 +-
 drivers/usb/serial/siemens_mpi.c                   |   47 -
 drivers/usb/serial/spcp8x5.c                       |    4 +-
 drivers/usb/serial/suunto.c                        |   41 -
 drivers/usb/serial/ti_usb_3410_5052.c              |  103 +-
 drivers/usb/serial/usb-serial-simple.c             |  110 +
 drivers/usb/serial/usb-serial.c                    |   14 +-
 drivers/usb/serial/vivopay-serial.c                |   43 -
 drivers/usb/serial/zio.c                           |   39 -
 drivers/usb/storage/scsiglue.c                     |   16 +-
 drivers/usb/usb-common.c                           |   49 +-
 drivers/usb/usb-skeleton.c                         |    3 +-
 drivers/usb/wusbcore/rh.c                          |   28 +-
 drivers/usb/wusbcore/wa-hc.h                       |   15 +-
 drivers/usb/wusbcore/wa-rpipe.c                    |   21 +
 drivers/usb/wusbcore/wa-xfer.c                     |  139 +-
 drivers/uwb/drp-ie.c                               |    4 +-
 drivers/uwb/hwa-rc.c                               |   16 +-
 drivers/uwb/pal.c                                  |   40 +-
 include/linux/device.h                             |   16 +-
 include/linux/platform_data/tegra_usb.h            |   32 -
 include/linux/usb.h                                |   32 +-
 include/linux/usb/chipidea.h                       |    7 +-
 include/linux/usb/gadget.h                         |    4 +
 include/linux/usb/hcd.h                            |   19 +-
 include/linux/usb/of.h                             |   10 +-
 include/linux/usb/phy.h                            |   18 +-
 include/linux/usb/tegra_usb_phy.h                  |   40 +-
 .../usb/{nop-usb-xceiv.h => usb_phy_gen_xceiv.h}   |    4 +-
 include/linux/usb/usbnet.h                         |    1 +
 include/linux/usb/wusb-wa.h                        |    1 +
 307 files changed, 14858 insertions(+), 7044 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-bus-usb
 create mode 100644 Documentation/devicetree/bindings/usb/generic.txt
 create mode 100644 Documentation/devicetree/bindings/usb/samsung-hsotg.txt
 create mode 100644 Documentation/devicetree/bindings/usb/usb-xhci.txt
 create mode 100644 drivers/dma/cppi41.c
 create mode 100644 drivers/usb/chipidea/otg.c
 create mode 100644 drivers/usb/chipidea/otg.h
 create mode 100644 drivers/usb/dwc3/platform_data.h
 delete mode 100644 drivers/usb/gadget/imx_udc.c
 delete mode 100644 drivers/usb/gadget/imx_udc.h
 create mode 100644 drivers/usb/host/fotg210-hcd.c
 create mode 100644 drivers/usb/host/fotg210.h
 create mode 100644 drivers/usb/host/xhci-trace.c
 create mode 100644 drivers/usb/host/xhci-trace.h
 create mode 100644 drivers/usb/misc/ehset.c
 create mode 100644 drivers/usb/musb/musb_am335x.c
 create mode 100644 drivers/usb/musb/musb_cppi41.c
 create mode 100644 drivers/usb/phy/am35x-phy-control.h
 create mode 100644 drivers/usb/phy/phy-am335x-control.c
 create mode 100644 drivers/usb/phy/phy-am335x.c
 rename drivers/usb/phy/{phy-nop.c => phy-generic.c} (66%)
 create mode 100644 drivers/usb/phy/phy-generic.h
 delete mode 100644 drivers/usb/serial/flashloader.c
 delete mode 100644 drivers/usb/serial/funsoft.c
 delete mode 100644 drivers/usb/serial/hp4x.c
 delete mode 100644 drivers/usb/serial/moto_modem.c
 delete mode 100644 drivers/usb/serial/siemens_mpi.c
 delete mode 100644 drivers/usb/serial/suunto.c
 create mode 100644 drivers/usb/serial/usb-serial-simple.c
 delete mode 100644 drivers/usb/serial/vivopay-serial.c
 delete mode 100644 drivers/usb/serial/zio.c
 delete mode 100644 include/linux/platform_data/tegra_usb.h
 rename include/linux/usb/{nop-usb-xceiv.h => usb_phy_gen_xceiv.h} (81%)
