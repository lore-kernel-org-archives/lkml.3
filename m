Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaDASq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:46:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaDASq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:46:56 -0400
Date: Tue, 1 Apr 2014 11:49:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB patches for 3.15-rc1
Message-ID: <20140401184916.GA21938@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.15-rc1

for you to fetch changes up to 940ab8f1ef9369da5b58a1bec6820bfd4a7b9042:

  Merge tag 'for-usb-next-adventure' of git://git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci into usb-next (2014-03-21 10:47:56 -0700)

----------------------------------------------------------------

USB patches for 3.15-rc1

Here's the big USB pull request for 3.15-rc1.

The normal set of patches, lots of controller driver updates, and a
smattering of individual USB driver updates as well.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Adrian Huang (1):
      xhci: add the meaningful IRQ description if it is empty

Alan Stern (5):
      USB: ehci-platform: check for platform data misconfiguration
      USB: ohci-platform: check for platform data misconfiguration
      USB: complain if userspace resets an active endpoint
      USB: unbind all interfaces before rebinding any
      USB: disable reset-resume when USB_QUIRK_RESET is set

Alexander Shiyan (1):
      usb: chipidea: imx: Use dev_name() for ci_hdrc name to distinguish USBs

Alexandre Belloni (1):
      usb: gadget: atmel_usba: fix crash when no endpoint are specified

Andrzej Pietrasiewicz (4):
      usb: gadget: FunctionFS: dereference ffs_dev conditionally
      usb: gadget: code cleanup
      usb: gadget: FunctionFS: staticize functions used only in f_fs.c
      usb: gadget: FunctionFS: use consistent naming with regard to ffs_lock

Austin Beam (1):
      phy: omap-usb2: Provide workaround for USB2PHY false disconnect

Bjørn Mork (2):
      usb: core: let dynamic ids override static ids
      usb: hub: usb_ext_cap_descriptor.bmAttributes is le32

Bo Shen (2):
      usb: gadget: at91: fix the number of endpoint parameter
      usb: gadget: at91: using USBA_NR_DMAS for DMA channels

Christian Vogel (2):
      usb/misc/usbled: Add Riso Kagaku Webmail Notifier
      usbhid/quirks: Ignore Riso Kagaku Webmail Notifier

Chuansheng Liu (1):
      usb: gadget: return the right length in ffs_epfile_io()

Dan Carpenter (4):
      usb: phy: msm: tiny leak on error in probe()
      usb: gadget: gr_udc: remove some unneeded error handling
      usb: dwc3: gadget: cut and paste fixups in suspend/resume
      usb: dwc3: gadget: remove known conditions

Daniel Tang (2):
      usb: chipidea: add support for USB OTG controller on LSI Zevio SoCs
      devicetree: bindings: document lsi,zevio-usb

Dinh Nguyen (1):
      usb: dwc2: handle the Host Port Interrupt when it occurs in device mode

Fabio Estevam (1):
      usb: chipidea: Propagate the real error code on platform_get_irq() failure

Felipe Balbi (19):
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
      usb: gadget: lpc32xx_udc: fix wrong clk_put() sequence
      usb: gadget: f_subset: switch over to PTR_RET
      usb: gadget: inode: switch over to memdup_user()
      usb: gadget: composite: switch over to ERR_CAST()

Geert Uytterhoeven (1):
      usb: musb: USB_MUSB_DUAL_ROLE/USB_MUSB_GADGET should depend on HAS_DMA

George Cherian (6):
      usb: musb: musb_host: Enable ISOCH IN handling for AM335x host
      usb: musb: musb_cppi41: Make CPPI aware of high bandwidth transfers
      usb: musb: musb_cppi41: Handle ISOCH differently and not use the hrtimer.
      usb: musb: musb_cppi41: Dont reprogram DMA if tear down is initiated
      phy: omap-usb2: Adapt phy-omap-usb2 for AM437x
      phy: omap-usb2: Add different compatible for OMAP5

Gerd Hoffmann (6):
      xhci: fix usb3 streams
      uas: properly reinitialize in uas_eh_bus_reset_handler
      uas: make work list per-device
      uas: add dead request list
      uas: replace BUG_ON() + WARN_ON() with WARN_ON_ONCE()
      uas: remove BROKEN

Greg Kroah-Hartman (8):
      Merge 3.14-rc3 into usb-next
      Merge 3.14-rc4 into usb-next
      Merge 3.14-rc5 into usb-next
      Merge tag 'for-usb-next-2014-03-06' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge tag 'usb-for-v3.15' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'for_3.15' of git://git.kernel.org/.../kishon/linux-phy into usb-next
      Merge 3.14-rc6 into usb-next
      Merge tag 'for-usb-next-adventure' of git://git.kernel.org/.../sarah/xhci into usb-next

Gregory CLEMENT (1):
      usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled

Hans de Goede (72):
      ohci-platform: Add support for devicetree instantiation
      ehci-platform: Add support for clks and phy passed through devicetree
      ohci-platform: Add support for controllers with big-endian regs / descriptors
      ehci-platform: Add support for controllers with big-endian regs / descriptors
      ohci-platform: Change compatible string from usb-ohci to generic-ohci
      ehci-platform: Change compatible string from usb-ehci to generic-ehci
      uhci-platform: Change compatible string from platform-uhci to generic-uhci
      xhci-platform: Change compatible string from xhci-platform to generic-xhci
      phy-core: Don't allow building phy-core as a module
      PHY: sunxi: Add driver for sunxi usb phy
      xhci: Free streams when they are still allocated on a set_interface call
      xhci: Check size rather then number of streams when allocating stream ctxs
      xhci: For streams the css flag most be read from the stream-ctx on ep stop
      xhci: Set SCT field for Set TR dequeue on streams
      xhci: For streams the dequeue ptr must be read from the stream ctx
      xhci: use usb_ss_max_streams in xhci_check_streams_endpoint
      usb-core: Fix usb_free_streams return value documentation
      usb-core: Move USB_MAXENDPOINTS definitions to usb.h
      usb-core: Track if an endpoint has streams
      usb-core: Free bulk streams on interface release
      usbfs: Kill urbs on interface before doing a set_interface
      usbfs: proc_do_submiturb use a local variable for number_of_packets
      usbfs: Add support for bulk stream ids
      usbfs: Add ep_to_host_endpoint helper function
      usbfs: Add support for allocating / freeing streams
      uas: Urbs must be anchored before submitting them
      uas: Properly set interface to altsetting 0 on probe failure
      uas: Avoid unnecessary unlock / lock calls around unlink_data_urbs
      uas: uas_alloc_cmd_urb: drop unused stream_id parameter
      uas: Fix uas not working when plugged into an ehci port
      uas: Fix reset locking
      uas: Fix reset handling for externally triggered reset
      uas: s/response_ui/response_iu/
      uas: Fix response iu struct definition
      uas: Pack iu struct definitions
      uas: Use all available stream ids
      uas: Add a uas_find_uas_alt_setting helper function
      uas: Move uas detect code to uas-detect.h
      xhci: xhci_mem_cleanup: make sure cmd_ring_reserved_trbs really is 0
      xhci: The trb_address_map radix tree expects 1KB segment memory aligment
      xhci: Handle MaxPSASize == 0
      usb: Clear host_endpoint->streams when implicitly freeing streams
      usb: Reset USB-3 devices on USB-3 link bounce
      uas: Add the posibilty to blacklist uas devices from using the uas driver
      usb-storage: Don't bind to uas devices if the uas driver is enabled
      usb-storage: Modify and export adjust_quirks so that it can be used by uas
      uas: Honor no-uas quirk set in usb-storage's quirks module parameter
      uas: Add uas_find_endpoints() helper function
      uas: Fix bounds check in uas_find_endpoints
      uas: Move uas_find_endpoints to uas-detect.h
      uas: Drop fixed endpoint config handling
      uas: Verify endpoint descriptors from uas_use_uas_driver()
      uas: Not being able to alloc streams when connected through usb-3 is an error
      uas: task_mgmt: Kill the sense-urb if we fail to submit the cmd urb
      uas: Don't allow more then one task to run at the same time
      uas: Use GFP_NOIO rather then GFP_ATOMIC where possible
      uas: Add suspend/resume support
      uas: Reset device on reboot
      uas: Fix task-management not working when connected over USB-2
      uas: uas_alloc_data_urb: Remove unnecessary use_streams check
      uas: Properly complete inflight commands on bus-reset or disconnect
      uas: add uas_mark_cmd_dead helper function
      uas: cmdinfo: use only one list head
      uas: Fix command / task mgmt submission racing with disconnect
      uas: Fix memory management
      uas: Clear cmdinfo on command queue-ing
      uas: Use the right error codes for different kinds of errors
      uas: Improve error reporting
      uas: Add some data in/out ready iu sanity checks
      uas: Make sure sg elements are properly aligned
      uas: Add Hans de Goede as uas maintainer
      uas: Remove comment about registering a uas scsi controller for each usb bus

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

Jingoo Han (2):
      usb: gadget: s3c-hsotg: use %pad for dma_addr_t
      usb: chipidea: use dev_get_platdata()

Joe Perches (1):
      USB: sisusb: Use static const, fix typo

Johan Hovold (7):
      USB: cypress_m8: fix potential scheduling while atomic
      USB: serial: make bulk_out_size a lower limit
      USB: serial: continue to read on errors
      USB: serial: continue to write on errors
      USB: serial: add missing braces
      USB: serial: add missing newlines to dev_<level> messages.
      USB: keyspan: remove dead debugging code

Julia Lawall (1):
      usb: gadget: fix error return code

Kamil Debski (4):
      phy: core: Add an exported of_phy_get function
      phy: core: Add devm_of_phy_get to phy-core
      phy: Add new Exynos USB 2.0 PHY driver
      phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver

Kees Cook (1):
      usb: gadget: tcm_usb_gadget: stop format strings

Kishon Vijay Abraham I (7):
      Documentation: dt bindings: move ..usb/usb-phy.txt to ..phy/ti-phy.txt
      usb: dwc3: core: support optional PHYs
      usb: dwc3: adapt dwc3 core to use Generic PHY Framework
      drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
      usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
      phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
      phy: rename struct omap_control_usb to struct omap_control_phy

Li Jun (1):
      usb: phy: fsm: update OTG HNP state transition conditions according to OTG and EH 2.0 spec.

Loc Ho (2):
      Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation
      PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver

Manu Gautam (1):
      usb: gadget: f_fs: Add support for SuperSpeed Mode

Marek Szyprowski (1):
      usb: gadget: s3c-hsotg: add proper suspend/resume support

Markus Pargmann (2):
      usb: musb: dsps, use devm_kzalloc
      usb: musb: dsps, debugfs files

Mathias Nyman (1):
      xhci: Prevent runtime pm from autosuspending during initialization

Matt Porter (1):
      usb: gadget: s3c-hsotg: fix build on x86 and other architectures

Michael Grzeschik (1):
      usb: chipidea: udc: add maximum-speed = full-speed option

Michal Nazarewicz (3):
      usb: gadget: functionfs: fix typo in the enum variable
      usb: gadget: functionfs: replace FFS_SETUP_STATUS with an inline function
      usb: gadget: f_fs: Add flags to descriptors block

Michal Simek (1):
      usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210

Oliver Neukum (3):
      hub: debug message for failing to enable device
      xhci: make warnings greppable
      storage: accept some UAS devices if streams are unavailable

Paul Bolle (3):
      USB: ELAN: Remove useless "default M" lines
      usb: host: remove USB_ARCH_HAS_?HCI
      usb: host: remove selects of USB_ARCH_HAS_?HCI

Paul Zimmerman (5):
      usb: dwc2: fix dereference before NULL check
      usb: dwc3: add 'saved_state' field to dwc3_ep structure
      usb: dwc3: gadget: implement dwc3_gadget_get_link_state
      usb: dwc3: gadget: add a 'restore' argument to set_ep_config
      usb: dwc3: gadget: add 'force' argument to stop_active_transfer

Peter Chen (15):
      usb: chipidea: refine PHY operation
      usb: chipidea: udc: refine ep operation at isr_tr_complete_handler
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
      usb: chipidea: udc: refine isr_tr_complete_handler

Richard Weinberger (1):
      Remove MACH_OMAP_H4_OTG

Robert Baldyga (6):
      usb: gadget: s3c-hsotg: stall ep0 in set_halt function
      usb: gadget: f_fs: fix setup request handling
      usb: gadget: f_fs: add poll for endpoint 0
      usb: gadget: f_fs: add aio support
      usb: gadget: at91_udc: fix ep maxpacket initialisation
      usb: gadget: f_fs: add missing spinlock and mutex unlock

Roger Quadros (11):
      phy: omap-control: Update DT binding information
      phy: omap-control: update dra7 and am437 usb2 Documentation bindings
      phy: ti-pipe3: Add clocks to PIPE3 PHY Documentation binding
      phy: ti-pipe3: Add SATA compatible to Documentation binding
      phy: omap-control: update dra7 and am437 usb2 bindings
      phy: ti-pipe3: cleanup clock handling
      phy: ti-pipe3: Add SATA DPLL support
      phy: ti-pipe3: Don't get 'wkupclk' and 'refclk' for SATA PHY
      phy: ti-pipe3: streamline PHY operations
      phy: ti-pipe3: Fix suspend/resume and module reload
      phy: omap: Depend on OMAP_OCP2SCP bus driver

Sachin Kamat (5):
      usb: gadget: s3c2410_udc: Fix build error
      usb: gadget: s3c-hsudc: remove unused label
      usb: phy: twl4030-usb: Silence checkpatch warnings
      usb: phy: twl4030-usb: Remove redundant semicolon
      usb: phy: bcm-kona-usb2: Use PTR_ERR_OR_ZERO

Sarah Sharp (5):
      usb/xhci: Change how we indicate a host supports Link PM.
      xhci: Remove segments from radix tree on failed insert.
      xhci: Refactor command watchdog and fix split string.
      xhci: Kill streams URBs when the host dies.
      xhci: Transition maintainership to Mathias Nyman.

Sebastian Hesselbarth (1):
      phy: mvebu-sata: prepare new Dove DT Kconfig variable

Sergei Shtylyov (1):
      usb: phy: rcar-gen2-usb: always use 'dev' variable in probe() method

Shaibal Dutta (1):
      usb: move hub init and LED blink work to power efficient workqueue

Sylwester Nawrocki (2):
      phy: Select PHY_EXYNOS_MIPI_VIDEO by default for ARCH_EXYNOS
      phy: Select PHY_EXYNOS_DP_VIDEO by default for ARCH_EXYNOS

Thierry Reding (1):
      USB: EHCI: tegra: Drop unused defines

Thomas Pugliese (13):
      usb: wusbcore: fix kernel panic on HWA unplug
      usb: wusbcore: fix stranded URB after HWA unplug
      usb: wusbcore: prevent urb dequeue and giveback race
      usb: wusbcore: add a convenience function for completing a transfer segment
      usb: wusbcore: adjust iterator correctly when searching for ep comp descriptor
      usb: wusbcore: read actual_length bytes isoc in segments
      usb: wusbcore: add info to HWA debug prints
      usb: wusbcore: fix compile warnings
      usb: wusbcore: fix potential double list_del on urb dequeue
      usb: wusbcore: don't mark WA_SEG_DTI_PENDING segs as done in urb_dequeue
      usb: wusbcore: disable transfer notifications for Alereon HWAs
      usb: wusbcore: combine iso transfer result frame reads when possible
      usb: wusbcore: use multiple urbs for HWA iso transfer result frame reads

Weinn Jheng (1):
      usb: gadget: u_ether: move hardware transmit to RX NAPI

Wolfram Sang (1):
      usb: dwc3: omap: don't check resource with devm_ioremap_resource

Yuvaraj Kumar C D (1):
      PHY: Exynos: Add Exynos5250 SATA PHY driver

wenlin.kang (2):
      usb: gadget: printer: fix possible deadlock
      usb: gadget: printer: fix memory leak

 .../devicetree/bindings/phy/apm-xgene-phy.txt      |   79 +
 .../devicetree/bindings/phy/samsung-phy.txt        |   54 +
 .../devicetree/bindings/phy/sun4i-usb-phy.txt      |   26 +
 Documentation/devicetree/bindings/phy/ti-phy.txt   |   86 +
 .../devicetree/bindings/usb/ci-hdrc-imx.txt        |    2 +
 .../devicetree/bindings/usb/ci-hdrc-zevio.txt      |   17 +
 Documentation/devicetree/bindings/usb/dwc3.txt     |    6 +-
 Documentation/devicetree/bindings/usb/mxs-phy.txt  |    8 +-
 Documentation/devicetree/bindings/usb/omap-usb.txt |   24 -
 Documentation/devicetree/bindings/usb/usb-ehci.txt |   27 +-
 Documentation/devicetree/bindings/usb/usb-ohci.txt |   25 +
 Documentation/devicetree/bindings/usb/usb-phy.txt  |   48 -
 .../usb/{platform-uhci.txt => usb-uhci.txt}        |    4 +-
 Documentation/devicetree/bindings/usb/usb-xhci.txt |    4 +-
 .../devicetree/bindings/usb/via,vt8500-ehci.txt    |   15 -
 .../devicetree/bindings/usb/vt8500-ehci.txt        |   12 -
 Documentation/phy/samsung-usb2.txt                 |  135 ++
 MAINTAINERS                                        |    5 +-
 arch/arm/Kconfig                                   |    3 -
 arch/arm/mach-exynos/Kconfig                       |    1 -
 arch/arm/mach-omap2/Kconfig                        |    2 -
 arch/arm/mach-shmobile/Kconfig                     |    4 -
 arch/arm/mach-tegra/Kconfig                        |    1 -
 arch/mips/Kconfig                                  |    7 -
 arch/mips/ath79/Kconfig                            |    8 -
 arch/mips/ralink/Kconfig                           |    6 -
 arch/powerpc/platforms/44x/Kconfig                 |    1 -
 arch/powerpc/platforms/ps3/Kconfig                 |    2 -
 arch/sh/Kconfig                                    |    9 -
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/phy/Kconfig                                |  107 +-
 drivers/phy/Makefile                               |    9 +
 drivers/phy/phy-bcm-kona-usb2.c                    |    4 +-
 drivers/phy/phy-core.c                             |   76 +-
 drivers/phy/phy-exynos4210-usb2.c                  |  261 +++
 drivers/phy/phy-exynos4x12-usb2.c                  |  328 ++++
 drivers/phy/phy-exynos5250-sata.c                  |  251 +++
 drivers/phy/phy-exynos5250-usb2.c                  |  404 +++++
 drivers/{usb => }/phy/phy-omap-control.c           |  169 +-
 drivers/phy/phy-omap-usb2.c                        |  131 +-
 drivers/phy/phy-samsung-usb2.c                     |  228 +++
 drivers/phy/phy-samsung-usb2.h                     |   67 +
 drivers/phy/phy-sun4i-usb.c                        |  331 ++++
 drivers/phy/phy-ti-pipe3.c                         |  470 ++++++
 drivers/phy/phy-twl4030-usb.c                      |    6 +-
 drivers/phy/phy-xgene.c                            | 1750 ++++++++++++++++++++
 drivers/usb/Kconfig                                |   10 -
 drivers/usb/chipidea/Makefile                      |    1 +
 drivers/usb/chipidea/bits.h                        |    2 +
 drivers/usb/chipidea/ci.h                          |    2 -
 drivers/usb/chipidea/ci_hdrc_imx.c                 |    2 +-
 drivers/usb/chipidea/ci_hdrc_zevio.c               |   72 +
 drivers/usb/chipidea/core.c                        |   87 +-
 drivers/usb/chipidea/udc.c                         |  324 ++--
 drivers/usb/core/config.c                          |    1 -
 drivers/usb/core/devio.c                           |  174 +-
 drivers/usb/core/driver.c                          |  121 +-
 drivers/usb/core/hcd.c                             |   37 +-
 drivers/usb/core/hub.c                             |   97 +-
 drivers/usb/core/message.c                         |    7 +-
 drivers/usb/core/usb.h                             |    2 +-
 drivers/usb/dwc2/core_intr.c                       |   25 +-
 drivers/usb/dwc2/hcd_intr.c                        |   14 +-
 drivers/usb/dwc3/core.c                            |  251 ++-
 drivers/usb/dwc3/core.h                            |  105 +-
 drivers/usb/dwc3/dwc3-omap.c                       |    5 -
 drivers/usb/dwc3/gadget.c                          |  183 +-
 drivers/usb/dwc3/gadget.h                          |   12 -
 drivers/usb/gadget/Kconfig                         |    3 +-
 drivers/usb/gadget/at91_udc.c                      |   14 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   16 +-
 drivers/usb/gadget/atmel_usba_udc.h                |    2 +-
 drivers/usb/gadget/composite.c                     |    2 +-
 drivers/usb/gadget/f_fs.c                          |  616 +++++--
 drivers/usb/gadget/f_subset.c                      |    2 +-
 drivers/usb/gadget/gr_udc.c                        |   10 +-
 drivers/usb/gadget/inode.c                         |    9 +-
 drivers/usb/gadget/lpc32xx_udc.c                   |    4 +-
 drivers/usb/gadget/printer.c                       |    8 +-
 drivers/usb/gadget/s3c-hsotg.c                     |  143 +-
 drivers/usb/gadget/s3c-hsudc.c                     |    1 -
 drivers/usb/gadget/tcm_usb_gadget.c                |    2 +-
 drivers/usb/gadget/u_ether.c                       |  101 +-
 drivers/usb/gadget/u_fs.h                          |   30 +-
 drivers/usb/host/Kconfig                           |    1 -
 drivers/usb/host/ehci-platform.c                   |  182 +-
 drivers/usb/host/ehci-tegra.c                      |    4 -
 drivers/usb/host/hwa-hc.c                          |   42 +-
 drivers/usb/host/ohci-platform.c                   |  199 ++-
 drivers/usb/host/uhci-platform.c                   |    1 +
 drivers/usb/host/xhci-hub.c                        |    8 +-
 drivers/usb/host/xhci-mem.c                        |  212 ++-
 drivers/usb/host/xhci-pci.c                        |   18 +-
 drivers/usb/host/xhci-plat.c                       |    4 +
 drivers/usb/host/xhci-ring.c                       |  146 +-
 drivers/usb/host/xhci.c                            |   33 +-
 drivers/usb/host/xhci.h                            |    5 +-
 drivers/usb/misc/Kconfig                           |    1 -
 drivers/usb/misc/sisusbvga/sisusb.c                |   10 +-
 drivers/usb/misc/usbled.c                          |   34 +
 drivers/usb/musb/Kconfig                           |    2 +
 drivers/usb/musb/musb_core.c                       |    5 +-
 drivers/usb/musb/musb_cppi41.c                     |   69 +-
 drivers/usb/musb/musb_dsps.c                       |   58 +-
 drivers/usb/musb/musb_host.c                       |   30 +-
 drivers/usb/musb/omap2430.c                        |    2 +-
 drivers/usb/phy/Kconfig                            |   21 -
 drivers/usb/phy/Makefile                           |    2 -
 drivers/usb/phy/phy-fsm-usb.c                      |    9 +-
 drivers/usb/phy/phy-msm-usb.c                      |    3 +-
 drivers/usb/phy/phy-mxs-usb.c                      |  310 +++-
 drivers/usb/phy/phy-omap-usb3.c                    |  361 ----
 drivers/usb/phy/phy-rcar-gen2-usb.c                |    6 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |    2 +-
 drivers/usb/phy/phy-ulpi.c                         |    2 +
 drivers/usb/serial/ch341.c                         |    6 +-
 drivers/usb/serial/cyberjack.c                     |    2 +-
 drivers/usb/serial/cypress_m8.c                    |   21 +-
 drivers/usb/serial/generic.c                       |   61 +-
 drivers/usb/serial/iuu_phoenix.c                   |    2 +-
 drivers/usb/serial/keyspan.c                       |   30 -
 drivers/usb/serial/keyspan_pda.c                   |    2 +-
 drivers/usb/serial/kl5kusb105.c                    |    4 +-
 drivers/usb/serial/kobil_sct.c                     |    3 +-
 drivers/usb/serial/mos7720.c                       |   12 +-
 drivers/usb/serial/mos7840.c                       |    4 +-
 drivers/usb/serial/quatech2.c                      |    2 +-
 drivers/usb/serial/spcp8x5.c                       |    7 +-
 drivers/usb/serial/symbolserial.c                  |    4 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |    4 +-
 drivers/usb/serial/usb-serial.c                    |   17 +-
 drivers/usb/storage/Kconfig                        |    2 +-
 drivers/usb/storage/uas-detect.h                   |   96 ++
 drivers/usb/storage/uas.c                          |  687 +++++---
 drivers/usb/storage/unusual_devs.h                 |    5 +
 drivers/usb/storage/unusual_uas.h                  |   52 +
 drivers/usb/storage/usb.c                          |   26 +-
 drivers/usb/storage/usb.h                          |    3 +
 drivers/usb/wusbcore/devconnect.c                  |    4 +-
 drivers/usb/wusbcore/wa-hc.c                       |    2 -
 drivers/usb/wusbcore/wa-hc.h                       |   26 +-
 drivers/usb/wusbcore/wa-rpipe.c                    |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                     |  583 +++++--
 .../omap_control_usb.h => phy/omap_control_phy.h}  |   36 +-
 include/linux/{usb => phy}/omap_usb.h              |   14 +-
 include/linux/phy/phy.h                            |   15 +
 include/linux/usb.h                                |    4 +
 include/linux/usb/chipidea.h                       |    1 +
 include/linux/usb/hcd.h                            |    1 +
 include/linux/usb/phy.h                            |   16 +
 include/linux/usb/serial.h                         |    3 +-
 include/linux/usb/uas.h                            |   14 +-
 include/linux/usb_usual.h                          |    6 +-
 include/uapi/linux/usb/functionfs.h                |   44 +-
 include/uapi/linux/usbdevice_fs.h                  |   12 +-
 156 files changed, 9148 insertions(+), 2183 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/apm-xgene-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/sun4i-usb-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/ti-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
 create mode 100644 Documentation/devicetree/bindings/usb/usb-ohci.txt
 delete mode 100644 Documentation/devicetree/bindings/usb/usb-phy.txt
 rename Documentation/devicetree/bindings/usb/{platform-uhci.txt => usb-uhci.txt} (76%)
 delete mode 100644 Documentation/devicetree/bindings/usb/via,vt8500-ehci.txt
 delete mode 100644 Documentation/devicetree/bindings/usb/vt8500-ehci.txt
 create mode 100644 Documentation/phy/samsung-usb2.txt
 create mode 100644 drivers/phy/phy-exynos4210-usb2.c
 create mode 100644 drivers/phy/phy-exynos4x12-usb2.c
 create mode 100644 drivers/phy/phy-exynos5250-sata.c
 create mode 100644 drivers/phy/phy-exynos5250-usb2.c
 rename drivers/{usb => }/phy/phy-omap-control.c (53%)
 create mode 100644 drivers/phy/phy-samsung-usb2.c
 create mode 100644 drivers/phy/phy-samsung-usb2.h
 create mode 100644 drivers/phy/phy-sun4i-usb.c
 create mode 100644 drivers/phy/phy-ti-pipe3.c
 create mode 100644 drivers/phy/phy-xgene.c
 create mode 100644 drivers/usb/chipidea/ci_hdrc_zevio.c
 delete mode 100644 drivers/usb/phy/phy-omap-usb3.c
 create mode 100644 drivers/usb/storage/uas-detect.h
 create mode 100644 drivers/usb/storage/unusual_uas.h
 rename include/linux/{usb/omap_control_usb.h => phy/omap_control_phy.h} (68%)
 rename include/linux/{usb => phy}/omap_usb.h (86%)
