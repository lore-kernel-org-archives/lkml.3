Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab3D2QYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:24:12 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43979 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3D2QXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:23:46 -0400
Date: Mon, 29 Apr 2013 09:23:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.10-rc1
Message-ID: <20130429162328.GA6963@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.10-rc1

for you to fetch changes up to 4626b8daf9bb00ce6b4d533c1a155211ad880f32:

  USB: ehci-msm: USB_MSM_OTG needs USB_PHY (2013-04-25 11:00:25 -0700)

----------------------------------------------------------------
USB patches for 3.10-rc1

Here's the big USB pull request for 3.10-rc1.

Lots of USB patches here, the majority being USB gadget changes and
USB-serial driver cleanups, the rest being ARM build fixes / cleanups,
and individual driver updates.  We also finally got some chipidea fixes,
which have been delayed for a number of kernel releases, as the
maintainer has now reappeared.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Adrian Thomasset (2):
      USB: ftdi_sio: correct ST Micro Connect Lite PIDs
      USB: ftdi_sio: enable two UART ports on ST Microconnect Lite

Alan Stern (18):
      USB: EHCI: split ehci-omap out to a separate driver
      USB: EHCI: decrease schedule-status poll timeout
      USB: EHCI: improve use of per-port status-change bits
      USB: EHCI: reorganize ehci_iaa_watchdog()
      USB: EHCI: don't turn on PORT_SUSPEND during port resume
      USB: EHCI: fix up incorrect merge resolution
      USB: EHCI: changes related to qh_refresh()
      USB: EHCI: change return value of qh_completions()
      USB: EHCI: split needs_rescan into two flags
      USB: EHCI: consolidate code in ehci_urb_dequeue()
      USB: EHCI: convert singly-linked lists to list_heads
      USB: EHCI: improve end_unlink_async()
      USB: EHCI: remove unused variable in unlink_empty_async()
      USB: avoid error messages when a device is disconnected
      USB: use "global suspend" for system sleep on USB-2 buses
      USB: remove CONFIG_USB_SUSPEND option
      USB: remove CONFIG_USB_SUSPEND from Documentation
      USB: improve port transitions when EHCI starts up

Alexander Shishkin (8):
      usb: chipidea: drop redundant includes
      usb: chipidea: trim include list in udc code
      usb: chipidea: trim include list in the core
      usb: chipidea: remove home-grown tracing facility
      usb: chipidea: convert debug entries in sysfs to debugfs
      usb: chipidea: move role to debugfs
      usb: chipidea: move debug files creation/removal to the core
      usb: chipidea: make pci platform datas static

Andi Kleen (1):
      USB: Fix initconst in ehci driver

Andrzej Pietrasiewicz (11):
      usb: gadget: use consistent naming scheme for usb function modules
      usb: gadget: nokia: remove unused include
      usb: gadget: f_serial: convert to new function interface with backward compatibility
      usb: gadget: serial: convert to new interface of f_serial
      usb: gadget: f_serial: remove compatibility layer
      usb: gadget: f_serial: add configfs support
      usb: gadget: f_obex: convert to new function interface with backward compatibility
      usb: gadget: serial: convert to new interface of f_obex
      usb: gadget: f_obex: add configfs support
      usb: gadget: f_sourcesink.c: correct a copy-paste misnomer
      usb: gadget: zero: put function instances on unbind

Arnd Bergmann (9):
      USB: EHCI: DT support for generic bus glue
      usb: ehci: mark unlink_empty_async_suspended() as __maybe_unused
      usb: exynos: do not include plat/usb-phy.h
      usb: phy: phy core cannot yet be a module
      usb: phy: tegra: don't call into tegra-ehci directly
      USB: lpc32xx: ISP1301 needs USB_PHY
      USB: OMAP: ISP1301 needs USB_PHY
      USB: OHCI: avoid conflicting platform drivers
      USB: ehci-msm: USB_MSM_OTG needs USB_PHY

Ben Jencks (1):
      usb/misc/appledisplay: Add 24" LED Cinema display

Bhupesh Sharma (6):
      usb: gadget: uvc: Add fix for UVC compliance test suite assertion 6.3.90 failure
      usb: gadget: uvc: Add fix for UVC compliance test suite's assertion 6.1.25 failure
      usb: gadget: uvc: Delay the status stage when setting alternate setting 1
      usb: gadget: uvc: Make video streaming buffer size comply with USB3.0 SS
      usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework
      usb: gadget/uvc: Add support for 'get_unmapped_area' for MMUless architectures

Bill Pemberton (1):
      Revert "USB: quatech2: only write to the tty if the port is open."

Bjørn Mork (2):
      USB: cdc-wdm: implement IOCTL_WDM_MAX_COMMAND
      USB: option: add a D-Link DWM-156 variant

Chao Xie (6):
      usb: gadget: mv_udc_core: remove unused clock
      usb: otg: mv_otg: remove unused clock
      usb: ehci: mv_ehci: remove unused clock
      arm: mmp: remove clock from usb pdata for aspenite
      arm: mmp: remove clock name from usb pdata for ttc
      usb: mv_usb: remove clock name from pdata

Chen Gang (3):
      usb: gadget: s3c-hsudc: delete outdated comment
      usb: gadget: uvc: Use strlcpy instead of strncpy
      USB: driver.c: processing failure, maching resume condition with suspend condition

Christian Engelmayer (1):
      EHCI: Quirk flag for port power handling on overcurrent.

Colin Ian King (1):
      usb: misc: sisusbvga: Avoid NULL pointer dereference from sisusb

Cyril Roelandt (1):
      usb: gadget: uvc: Use GFP_ATOMIC under spin lock

Dan Carpenter (5):
      usb: storage: onetouch: tighten a range check
      usb: gadget: uvc: use capped length value
      usb: chipidea: fix precedence bug in ci_requests_show()
      USB: keyspan: pull in one indent level
      USB: keyspan: add a sanity test on "len"

David Howells (2):
      xhci: Use ilog2() rather than __ffs() for calculating SEGMENT_SHIFT
      xhci: Rename SEGMENT_SIZE and SEGMENT_SHIFT as the former is used in a.out.h

David Linares (1):
      USB: hub: Avoid NULL pointer dereference when hub doesn't have any ports

David Rientjes (1):
      usb, gadget: use appropriate warning accessors

Denis Efremov (1):
      usb: phy: remove exported function from __init section

Dmitry Torokhov (1):
      USB: remove incorrect __exit markups

Doug Anderson (1):
      usb: ehci-s5p: Use devm for requesting ehci_vbus_gpio

Du Xing (1):
      USB: usb-skeleton.c: fix blocked forever in skel_read

Fabio Baltieri (14):
      usb: musb: drop dangling CONFIG_USB_MUSB_DEBUG
      usb: musb: ux500: implement musb_set_vbus
      usb: musb: ux500: add otg notifier support
      usb: otg: ab8500-usb: drop support for ab8500 pre v2.0
      usb: phy: ab8500-usb: update irq handling code
      usb: musb: ux500_dma: drop references to U5500
      usb: phy: ab8500-usb: convert to devm_kzalloc
      usb: phy: ab8500-usb: add regulator support
      usb: phy: ab8500-usb: split ab8500_usb_phy_ctrl
      usb: phy: ab8500-usb: enable/disable regulator on phy events
      usb: phy: ab8500-usb: fix last notifier arguments
      usb: phy: ab8500-usb: check regulator_enable return value
      usb: phy: twl4030-usb: check regulator_enable return value
      usb: phy: twl6030-usb: check regulator_enable return value

Fabio Estevam (3):
      usb: chipidea: usbmisc_imx6q: Staticize usbmisc_imx6q_drv_init/exit()
      usb: host: ehci-mxc: Remove unneeded header file
      usb: host: ehci-mxc: Remove dev_info on probe

Felipe Balbi (200):
      usb: gadget: udc-core: allow udc class register gadget device
      usb: dwc3: gadget: let udc-core manage gadget->dev
      usb: musb: gadget: let udc-core manage gadget-dev
      usb: gadget: omap_udc: let udc-core manage gadget->dev
      usb: gadget: amd5536udc: let udc-core manage gadget->dev
      usb: gadget: at91_udc: let udc-core manage gadget->dev
      usb: gadget: atmel_usba_udc: let udc-core manage gadget->dev
      usb: gadget: bcm63xx_udc: let udc-core manage gadget->dev
      usb: gadget: dummy_hcd: let udc-core manage gadget->dev
      usb: gadget: fsl_qe_udc: let udc-core manage gadget->dev
      usb: gadget: fsl_udc_core: let udc-core manage gadget->dev
      usb: gadget: fusb300_udc: let udc-core manage gadget->dev
      usb: gadget: goku_udc: let udc-core manage gadget->dev
      usb: gadget: imx_udc: let udc-core manage gadget->dev
      usb: gadget: lpc32xx_udc: let udc-core manage gadget->dev
      usb: gadget: m66592-udc: let udc-core manage gadget->dev
      usb: gadget: mv_u3d_core: let udc-core manage gadget->dev
      usb: gadget: mv_u3d_core: fix a compile warning
      usb: gadget: mv_udc_core: let udc-core manage gadget->dev
      usb: gadget: net2272: let udc-core manage gadget->dev
      usb: gadget: net2280: let udc-core manage gadget->dev
      usb: gadget: pch_udc: let udc-core manage gadget->dev
      usb: gadget: r8a66597-udc: let udc-core manage gadget->dev
      usb: gadget: s3c-hsotg: let udc-core manage gadget->dev
      usb: gadget: s3c-hsudc: let udc-core manage gadget->dev
      usb: gadget: s3c2410_udc: let udc-core manage gadget->dev
      usb: renesas_usbhs: gadget: let udc-core manage gadget->dev
      usb: gadget: pxa25x_udc: let udc-core manage gadget->dev
      usb: gadget: pxa27x_udc: let udc-core manage gadget->dev
      usb: chipidea: let udc-core manage gadget->dev
      usb: gadget: drop now unnecessary flag
      usb: gadget: s3c-hsotg: switch over to usb_gadget_map/unmap_request()
      usb: gadget: amd5536udc: remove unused structure member
      usb: gadget: atmel_usba_udc: switch over to usb_gadget_map/unmap_request()
      usb: gadget: fsl_udc_core: switch over to usb_gadget_map/unmap_request()
      usb: gadget: fusb300: switch over to usb_gadget_map/unmap_request()
      usb: gadget: lpc32xx_udc: switch over to usb_gadget_map/unmap_request()
      usb: gadget: mv_udc_core: switch over to usb_gadget_map/unmap_request()
      usb: dwc3: core: explicitly setup and cleanup event buffers
      usb: dwc3: gadget: introduce and use enable/disable irq methods
      usb: dwc3: gadget: save state of pullups
      usb: dwc3: core: add power management support
      usb: dwc3: omap: introduce enable/disable IRQ methods
      usb: dwc3: omap: remove unused fields from private structure
      usb: dwc3: omap: add basic suspend/resume support
      usb: dwc3: pci: add basic suspend/resume support
      usb: musb: core: remove unnecessary pr_info()
      usb: musb: switch over to devm_ioremap_resource()
      usb: musb: gadget: delete wrong comment
      usb: musb: force PIO-only if we're building multiplatform kernels
      usb: musb: make davinci and da8xx glues depend on BROKEN
      usb: musb: dsps: add missing include
      usb: musb: ux500_dma: kill compile warnings
      usb: musb: dsps: fix possible compile warning
      usb: musb: gadget: fix compile warning
      usb: musb: Kconfig: drop unnecessary dependencies
      usb: dwc3: core: remove bogus comment to our structure
      usb: dwc3: add a flags field to event buffer
      usb: dwc3: add count field to event buffer
      usb: dwc3: gadget: move to threaded IRQ
      usb: common: introduce usb_state_string()
      usb: gadget: introduce gadget state tracking
      usb: dwc3: gadget: implement gadget state tracking
      usb: dwc3: remove our homebrew state mechanism
      usb: dwc3: debugfs: add two missing Link States
      usb: dwc3: debugfs: when unknown, print only the state value
      usb: dwc3: debugfs: mark our regset structure const
      usb: dwc3: debugfs: improve debugfs file creation
      usb: dwc3: core: avoid checkpatch.pl warning
      usb: gadget: pxa27x_udc: drop ARCH_PXA dependency
      usb: gadget: pxa27x_udc: switch over to module_platform_driver
      usb: gadget: udc-core: copy dma-related parameters from parent
      usb: gadget: udc-core: initialize parent
      usb: gadget: chipidea: remove unnecessary initializations
      usb: gadget: amd5536udc: remove unnecessary initializations
      usb: gadget: atmel_usba_udc: remove unnecessary initializations
      usb: gadget: bcm63xx_udc: remove unnecessary initializations
      usb: gadget: fusb300_udc: remove unnecessary initializations
      usb: gadget: goku_udc: remove unnecessary initializations
      usb: gadget: goku_udc: remove unused macro
      usb: gadget: imx_udc: remove unnecessary initializations
      usb: gadget: m66592-udc: remove unnecessary initializations
      usb: dwc3: gadget: remove unnecessary initializations
      usb: gadget: mv_u3d_core: remove unnecessary initializations
      usb: gadget: mv_udc_core: remove unnecessary initializations
      usb: gadget: net2272: remove unnecessary initializations
      usb: gadget: net2280: remove unnecessary initializations
      usb: gadget: omap_udc: remove unnecessary initializations
      usb: gadget: pch_udc: remove unnecessary initializations
      usb: gadget: pxa25x_udc: remove unnecessary initializations
      usb: gadget: pxa27x_udc: remove unnecessary initializations
      usb: gadget: r8a66597-udc: remove unnecessary initializations
      usb: gadget: s3c-hsotg: remove unnecessary initializations
      usb: gadget: s3c-hsudc: remove unnecessary initializations
      usb: gadget: s3c2410_udc: remove unnecessary initializations
      usb: musb: gadget: remove unnecessary initializations
      usb: gadget: fsl_udc_core: remove unnecessary initializations
      usb: gadget: udc-core: initialize gadget->dev.driver
      usb: dwc3: gadget: don't touch gadget.dev.driver
      usb: gadget: amd5536udc: don't touch gadget.dev.driver
      usb: gadget: at91_udc: don't touch gadget.dev.driver
      usb: gadget: atmel_usba_udc: don't touch gadget.dev.driver
      usb: gadget: bcm63xx_udc: don't touch gadget.dev.driver
      usb: gadget: dummy_hcd: don't touch gadget.dev.driver
      usb: gadget: fsl_qe_udc: don't touch gadget.dev.driver
      usb: gadget: fsl_udc_core: don't touch gadget.dev.driver
      usb: gadget: fusb300_udc: don't touch gadget.dev.driver
      usb: gadget: goku_udc: don't touch gadget.dev.driver
      usb: gadget: imx_udc: don't touch gadget.dev.driver
      usb: gadget: lpc32xx_udc: don't touch gadget.dev.driver
      usb: gadget: m66592-udc: don't touch gadget.dev.driver
      usb: gadget: mv_u3d_core: don't touch gadget.dev.driver
      usb: gadget: mv_udc_core: don't touch gadget.dev.driver
      usb: gadget: net2272: don't touch gadget.dev.driver
      usb: gadget: net2280: don't touch gadget.dev.driver
      usb: gadget: omap_udc: don't touch gadget.dev.driver
      usb: gadget: pch_udc: don't touch gadget.dev.driver
      usb: gadget: pxa25x_udc: don't touch gadget.dev.driver
      usb: gadget: pxa27x_udc: don't touch gadget.dev.driver
      usb: gadget: s3c-hsotg: don't touch gadget.dev.driver
      usb: gadget: s3c-hsudc: don't touch gadget.dev.driver
      usb: gadget: s3c2410_udc: don't touch gadget.dev.driver
      usb: renesas: gadget: don't touch gadget.dev.driver
      usb: gadget: udc-core: introduce usb_add_gadget_udc_release()
      usb: chipidea: udc: don't assign gadget.dev.release directly
      usb: dwc3: gadget: don't assign gadget.dev.release directly
      usb: gadget: amd5536udc: don't assign gadget.dev.release directly
      usb: gadget: bcm63xx_udc: don't assign gadget.dev.release directly
      usb: gadget: dummy_hcd: don't assign gadget.dev.release directly
      usb: gadget: fsl_qe_udc: don't assign gadget.dev.release directly
      usb: gadget: fsl_udc_core: don't assign gadget.dev.release directly
      usb: gadget: fusb300_udc: don't assign gadget.dev.release directly
      usb: gadget: goku_udc: don't assign gadget.dev.release directly
      usb: gadget: m66592-udc: don't assign gadget.dev.release directly
      usb: gadget: mv_u3d_core: don't assign gadget.dev.release directly
      usb: gadget: mv_udc_core: don't assign gadget.dev.release directly
      usb: gadget: net2272: don't assign gadget.dev.release directly
      usb: gadget: net2280: don't assign gadget.dev.release directly
      usb: gadget: omap_udc: don't assign gadget.dev.release directly
      usb: gadget: pch_udc: don't assign gadget.dev.release directly
      usb: gadget: r8a66597-udc: don't assign gadget.dev.release directly
      usb: gadget: s3c-hsotg: don't assign gadget.dev.release directly
      usb: musb: gadget: don't assign gadget.dev.release directly
      usb: renesas: gadget: don't assign gadget.dev.release directly
      usb: gadget: udc-core: remove protection when setting gadget.dev.release
      usb: gadget: udc-core: anywone can read 'speed' attributes
      usb: dwc3: core: define more revisions
      usb: dwc3: workaround: unexpected transtion U3 -> RESUME
      usb: dwc3: calculate the number of endpoints
      usb: dwc3: gadget: use num_(in|out)_eps from HW params
      usb: otg: prefix otg_state_string with usb_
      usb: otg: move usb_otg_state_string to usb-common.c
      usb: phy: convert EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
      usb: phy: move all PHY drivers to drivers/usb/phy/
      usb: phy: make it a menuconfig
      usb: power: pda_power: check against CONFIG_USB_PHY
      usb: gadget: mv_udc_core: check against CONFIG_USB_PHY
      usb: ehci: marvel: check against CONFIG_USB_PHY
      usb: ehci: tegra: check against CONFIG_USB_PHY
      usb: phy: remove CONFIG_USB_OTG_UTILS
      usb: phy: rename all phy drivers to phy-$name-usb.c
      usb: phy: isp1301: give it a context structure
      usb: phy: introduce ->set_vbus() method
      usb: phy: isp1301: implement PHY API
      usb: gadget: atmel: remove unused DMA_ADDR_INVALID
      usb: gadget: net2272: remove unused DMA_ADDR_INVALID
      usb: gadget: net2280: remove unused DMA_ADDR_INVALID
      usb: gadget: uvc: remove references to DMA_ADDR_INVALID
      usb: renesas: remove unused DMA_ADDR_INVALID
      usb: dwc3: omap: fix sparse warning
      usb: phy: return -ENXIO when PHY layer isn't enabled
      usb: dwc3: fix PHY error handling
      usb: gadget: mv_udc_core: fix PHY error handling
      usb: gadget: s3c-hsotg: fix PHY error handling
      usb: musb: omap2430: fix PHY error handling
      usb: host: ehci-msm: fix PHY error handling
      usb: host: ehci-mv: fix PHY error handling
      usb: host: ehci-s5p: fix PHY error handling
      usb: host: ohci-exynos: fix PHY error handling
      usb: phy: samsung: fix sparse warning
      usb: phy: gpio-vbus: don't ignore regulator APIs return value
      arm: tegra: fix Kconfig select clauses
      usb: host: ehci-tegra: fix PHY error handling
      usb: gadget: mv_u3d: remove unused headers
      usb: gadget: mv_u3d: remove outdated selects
      usb: gadget: mv_u3d: fix sparse warnings
      usb: gadget: mv_u3d: drop ARCH dependency
      usb: gadget: net2272: fix sparse warnings
      usb: gadget: net2280: fix sparse warnings
      usb: gadget: dummy: fix sparse warning
      usb: gadget: pch_udc: fix sparse warnings
      usb: gadget: mv_udc_core: fix sparse warnings
      usb: gadget: mv_u3d: fix sparse warnings
      usb: musb: ux500_dma: fix sparse warning
      usb: chipidea: core: switch over to devm_ioremap_resource
      usb: chipidea: don't redefine __ffs()
      usb: gadget: mv_u3d_core: remove unused clock
      usb: gadget: udc-core: prevent a memory leak
      usb: gadget: pxa27x_udc: fix Section Mismatches
      usb: gadget: nokia: include f_ecm.c

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145

Florian Fainelli (5):
      USB: regroup all depends on USB within an if USB block
      USB: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends on architecture symbol
      USB: enclose EHCI HCD drivers within an if USB_EHCI_HCD block
      USB: enclose all depends on USB_OHCI_HCD within an if USB_OHCI_HCD block
      USB: enclose USB_XHCI_HCD related symbols within a if USB_XHCI_HCD block

Geoff Levand (1):
      usb: PS3 EHCI remove unneeded ehci_shutdown

George Cherian (1):
      usb: dwc3: core: fix wrong OTG event regitser offset

Grazvydas Ignotas (10):
      usb: phy: twl4030-usb: don't enable PHY during init
      usb: phy: twl4030-usb: ignore duplicate events
      usb: phy: twl4030-usb: don't switch the phy on/off needlessly
      usb: phy: twl4030-usb: poll for ID disconnect
      usb: musb: core: honour initial transceiver state
      usb: musb: gadget: clear gadget_driver when gadget is stopped
      usb: musb: core: log VBUS error
      usb: phy: twl4030-usb: check if vbus is driven by twl itself
      usb: musb: omap2430: turn off vbus on cable disconnect
      usb: musb: gadget: use platform callback to enable vbus

Greg Kroah-Hartman (12):
      Staging: ccg: remove it from the build
      Merge branch 'usb-linus' into usb-next
      Merge 3.9-rc4 into usb-next
      Merge branch 'usb-linus' into usb-next
      Revert "USB: serial: fix hang when opening port"
      Merge v3.9-rc5 into usb-next
      Merge tag 'usb-for-v3.10' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge 3.9-rc6 into usb-next
      Merge tag 'for-usb-next-2012-04-08' of git://git.kernel.org/.../sarah/xhci into usb-next
      USB: serial: wishbone-serial: fix up minor sparse warning
      USB: storage: convert to use module_usb_driver()
      Merge tag 'usb-for-v3.10-part2' of git://git.kernel.org/.../balbi/usb into usb-next

Hans de Goede (1):
      usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep

Huang Rui (1):
      USB: fix an incorrect table index in comment

Jingoo Han (3):
      usb: gadget: mv_u3d: make mv_u3d_pm_ops static
      USB: ehci-spear: add CONFIG_PM_SLEEP to suspend/resume functions
      usb: dwc3: add CONFIG_PM_SLEEP to suspend/resume functions

Jiri Slaby (1):
      USB: io_ti, stop dereferencing potential NULL

Joe Perches (3):
      usb: storage: Add usb_stor_dbg, reduce object size
      usb: storage: Fix link error
      usb: storage: Convert US_DEBUGP to usb_stor_dbg

Johan Hovold (113):
      USB: ftdi_sio: remove obsolete port data refcounting
      USB: kl5kusb105: remove unnecessary urb kill on close
      USB: iuu_phoenix: remove unnecessary urb kill on close
      USB: pl2303: use interface device for debug
      USB: pl2303: make set_control_lines a port operation
      USB: serial: rename tty-port callbacks
      USB: serial: remove redundant comments
      USB: serial: clean up debug info
      USB: serial: remove redundant allocation error messages
      USB: serial: remove port number from generic-driver debug
      USB: ark3116: remove bogus disconnect test in close
      USB: cyberjack: remove bogus disconnect test in close
      USB: digi_acceleport: remove bogus disconnect test in close
      USB: iuu_phoenix: remove bogus disconnect test in close
      USB: keyspan: remove bogus disconnect test in close
      USB: keyspan_pda: remove bogus disconnect test from dtr_rts
      USB: keyspan_pda: remove bogus disconnect test in close
      USB: mos7840: remove bogus disconnect test in close
      USB: sierra: remove bogus disconnect test in close
      USB: usb_wwan: remove bogus disconnect test in close
      USB: serial: remove bogus disconnect test in cleanup
      USB: ssu100: remove explicit initialisation of disconnect
      USB: ssu100: remove custom close operation
      USB: serial: fix generic disconnect implementation
      USB: serial: remove generic disconnect callback
      USB: serial: remove generic release callback
      USB: serial: clean up generic-operation handling
      USB: cyberjack: fix disconnect handling
      USB: serial: fix port release
      USB: serial: rename port release
      USB: fix urb-poison imbalance
      USB: serial: use urb poison to reliably kill traffic
      USB: serial: clean up usb-serial bus device removal
      USB: serial: add tiocmiwait subdriver operation
      USB: serial: add generic TIOCMIWAIT implementation
      USB: serial: wake up MSR-wait queue on disconnect
      USB: serial: add generic get_icount implementation
      USB: ftdi_sio: use port icount
      USB: ftdi_sio: switch to generic TIOCMIWAIT implementation
      USB: ftdi_sio: switch to generic get_icount implementation
      USB: ark3116: switch to generic get_icount implementation
      USB: ark3116: switch to generic TIOCMIWAIT implementation
      USB: ch341: replace custom ioctl operation with tiocmiwait
      USB: ch341: fix TIOCMIWAIT and disconnect
      USB: cypress_m8: replace custom ioctl operation with tiocmiwait
      USB: cypress_m8: fix TIOCMIWAIT and disconnect
      USB: digi_acceleport: remove unused MSR-wait queue
      USB: f81232: add custom tiocmiwait operation
      USB: f81232: fix TIOCMIWAIT and disconnect
      USB: io_edgeport: switch to generic get_icount implementation
      USB: io_edgeport: switch to generic TIOCMIWAIT implementation
      USB: io_ti: switch to generic get_icount implementation
      USB: io_ti: switch to generic TIOCMIWAIT implementation
      USB: iuu_phoenix: remove unused MSR-wait queue
      USB: mct_u232: switch to generic get_icount implementation
      USB: mct_u232: switch to generic TIOCMIWAIT implementation
      USB: mos7720: remove broken get_icount and TIOCMIWAIT
      USB: mos7840: remove smp barriers from icount handling
      USB: mos7840: switch to generic get_icount implementation
      USB: mos7840: switch to generic TIOCMIWAIT implementation
      USB: oti6858: replace custom ioctl operation with tiocmiwait
      USB: oti6858: fix TIOCMIWAIT and disconnect
      USB: pl2303: add custom tiocmiwait operation
      USB: pl2303: fix TIOCMIWAIT and disconnect
      USB: quatech2: switch to generic get_icount implementation
      USB: quatech2: switch to generic TIOCMIWAIT implementation
      USB: spcp8x5: remove broken TIOCMIWAIT support
      USB: spcp8x5: remove broken uart-error handling
      USB: spcp8x5: clean up code
      USB: spcp8x5: pass usb-serial port to control functions
      USB: spcp8x5: clean up modem status retrieval
      USB: spcp8x5: reimplement device type detection
      USB: spcp8x5: add proper modem-status support
      USB: ssu100: switch to generic get_icount implementation
      USB: ssu100: switch to generic TIOCMIWAIT implementation
      USB: ti_usb_3410_5052: switch to generic get_icount implementation
      USB: ti_usb_3410_5052: switch to generic TIOCMIWAIT implementation
      USB: serial: remove unused MSR-wait queue
      USB: cp210x: always disable uart on close
      USB: cypress_m8: remove bogus disconnect test from close
      USB: io_ti: always disable uart on close
      USB: kl5kusb105: always disable uart on close
      USB: metro-usb: always disable uart on close
      USB: mos7720: always disable uart on close
      USB: opticon: fix return value of tiocmset
      USB: opticon: remove disconnect test from tiocmset
      USB: pl2303: fix return value of tiocmset
      USB: pl2303: remove disconnect test from tiocmset
      USB: quatech2: always disable uart on close
      USB: visor: always disable uart on close
      USB: garmin_gps: remove bogus disconnect test in close
      USB: garmin_gps: remove bogus disconnect test in bulk callback
      USB: iuu_phoenix: remove bogus disconnect test in close
      USB: serial: update copyright information
      USB: omninet: use kzalloc for private data
      USB: omninet: clean up protocol description
      USB: omninet: clean up protocol defines
      USB: omninet: refactor read-urb processing
      USB: omninet: switch to generic read implementation
      USB: kobil_sct: fix broken debug code
      USB: kobil_sct: remove unused endpoint address
      USB: kobil_sct: use port interrupt-out urb
      USB: mct_u232: clean up read implementation
      USB: symbolserial: use port interrupt-in urb
      USB: symbolserial: remove unused private data
      USB: symbolserial: move private-data allocation to port_probe
      USB: io_ti: fix TIOCGSERIAL
      USB: io_ti: remove redundant wait_until_sent
      USB: ti_usb_3410_5052: move write-fifo flushing to close
      USB: ti_usb_3410_5052: remove lsr from port data
      USB: ti_usb_3410_5052: query hardware-buffer status in chars_in_buffer
      USB: ti_usb_3410_5052: remove redundant drain from break_ctl
      USB: ti_usb_3410_5052: kill custom closing_wait

Julius Werner (1):
      usb: Make USB persist default configurable

Kishon Vijay Abraham I (10):
      usb: dwc3: omap: minor fixes to get dt working
      usb: dwc3: omap: remove platform data associated with dwc3-omap
      usb: dwc3: omap: stop using nop-usb-xceiv
      usb: dwc3: set dma_mask for dwc3_omap device
      usb: dwc3: dwc3-omap: return -EPROBE_DEFER if probe has not yet executed
      usb: musb: omap2430: replace *_* with *-* in property names
      usb: musb: omap: remove the check before calling otg_set_vbus
      usb: musb: omap: add usb_phy_init in omap2430_musb_init
      usb: phy: twl4030: use devres API for regulator get and request irq
      usb: phy: twl4030: fix cold plug on OMAP3

Kuninori Morimoto (1):
      usb: renesas_usbhs: fixup sparse errors for common.c

Laurent Pinchart (6):
      usb: gadget: uvc: clarify comment about string descriptors
      usb: gadget: uvc: Rename STATUS_BYTECOUNT to UVC_STATUS_MAX_PACKET_SIZE
      usb: gadget: uvc: Fix coding style issues introduced by SS support
      usb: gadget: uvc: Merge the SS/HS/FS control endpoint descriptors
      usb: gadget: uvc: Merge the streaming maxpacket and mult parameters
      usb: gadget: uvc: Configure the streaming endpoint based on the speed

Manjunath Goudar (5):
      USB: EHCI: make ehci-orion a separate driver
      USB: EHCI: make ehci-spear a separate driver
      USB: EHCI: make ehci-s5p a separate driver
      USB: EHCI: make ehci-atmel a separate driver
      USB: EHCI: make ehci-msm a separate driver

Marc Kleine-Budde (4):
      usb: phy: mxs: use readl(), writel() instead of the _relaxed() versions
      usb: chipidea: usbmisc: unset global varibale usbmisc on driver remove
      usb: chipidea: usbmisc: fix a potential race condition
      usb: chipidea: usbmisc: prepare driver to handle more than one soc

Mian Yousaf Kaukab (1):
      usb: phy: ab8500-usb: fix unbalanced clock and regulator disable warnings

Michael Grzeschik (12):
      usb: chipidea: usbmisc: rename file, struct and functions to usbmisc_imx
      usb: chipidea: usbmisc: add mx53 support
      usb: chipidea: usbmisc: add post handling and errata fix for mx25
      usb: chipidea: udc: only clear active and halted bits in qhead
      usb: chipidea: udc: rework ep_enable cap setting
      usb: chipidea: udc: move ZLT flag change to ep_enable
      usb: chipidea: udc: read status of td only once in hardware_dequeue
      usb: chipidea: udc: don't truncate requests to single tds
      usb: chipidea: udc: move _ep_queue into an unlocked function
      usb: chipidea: udc: add the define TD_PAGE_COUNT and fix all users
      usb: chipidea: udc: fix memory access of shared memory on armv5 machines
      usb: chipidea: udc: fix memory leak in _ep_nuke

Ming Lei (8):
      USB: adds comment on suspend callback
      USB: serial: comments on suspend failure
      USBHID: don't recover device if suspend fails in system sleep
      usbnet: cdc_mbim: comments on suspend failure
      usbnet: qmi_wwan: comments on suspend failure
      usbnet: smsc95xx: don't recover device if suspend fails in system sleep
      usbnet: smsc75xx: don't recover device if suspend fails in system sleep
      USB: usbtmc: remove unnecessary memory allocation

Nishanth Menon (1):
      USB: fix trivial usb_device kernel-doc errors

Nobuhiro Iwamatsu (2):
      usb: ehci-sh: Fix build error due to comma has been deleted
      usb: echi-sh: Remove driver variable which is not used

Patrice Chotard (1):
      usb: phy: ab8500-usb: adopt pinctrl support

Paul Vlase (1):
      usb: Use resource_size function

Peter Chen (1):
      Revert "USB: chipidea: add vbus detect for udc"

Peter Hurley (1):
      usb/serial: Remove unnecessary check for console

Ravi Babu (2):
      usb: musb: dsps: print babble message only when musb is active host
      usb: musb: gadget: read ep0 fifo only if rxcount is non zero

Roger Quadros (22):
      USB: ehci-omap: Use devm_ioremap_resource()
      USB: ehci-omap: Use PHY APIs to get the PHY device and put it out of suspend
      USB: ehci-omap: Remove PHY reset handling code
      USB: ehci-omap: Remove PHY regulator handling code
      USB: ehci-omap: Select NOP USB transceiver driver
      USB: ehci-omap: Get platform resources by index rather than by name
      USB: ohci-omap3: Get platform resources by index rather than by name
      USB: ohci-omap3: Add device tree support and binding information
      USB: ehci-omap: Add device tree support and binding information
      USB: ehci-omap: Try to get PHY even if not in PHY mode
      USB: ehci-omap: Fix detection in HSIC mode
      USB: ehci-omap: Get rid of omap_ehci_init()
      usb: phy: nop: Add some parameters to platform data
      usb: phy: nop: use devm_kzalloc()
      usb: phy: nop: Manage PHY clock
      usb: phy: nop: Handle power supply regulator for the PHY
      usb: phy: nop: Handle RESET for the PHY
      usb: phy: nop: use new PHY API to register PHY
      usb: phy: nop: Add device tree support and binding information
      USB: phy: nop: Defer probe if device needs VCC/RESET
      USB: ehci-omap: Don't select any PHY driver
      USB: ehci-omap: Improve PHY error handling

Ruslan Bilovol (1):
      usb: musb: implement (un)map_urb_for_dma hooks

Sachin Kamat (2):
      usb: gadget: fsl_udc_core: Use module_platform_driver_probe macro
      usb: phy: samsung: convert to devm_ioremap_resource()

Sakethram Bommisetti (4):
      usb: phy: ab8500-usb: set phy tuning values
      usb: phy: ab8500-usb: fix eye diagram for ab8500 v2.0
      usb: phy: ab8500-usb: drop link status delayed work
      usb: phy: ab8500-usb: call phy_dis_work only when necessary

Samuel Tardieu (1):
      USB: cdc-acm: Remove obsolete predefined speeds array

Sascha Hauer (2):
      usb: phy: move bulk of otg/otg.c to phy/phy.c
      usb: phy: mxs-phy: register phy with framework

Sebastian Andrzej Siewior (4):
      usb: gadget: nokia: use function framework for ACM
      usb: gadget: move the global the_dev variable to their users
      usb: gadget: push tty port allocation from gadget into f_acm
      usb: gadget: the start of the configfs interface

Shawn Guo (2):
      ARM: imx_v6_v7_defconfig: add CONFIG_USB_PHY
      ARM: mxs_defconfig: add CONFIG_USB_PHY

Shengzhou Liu (1):
      usb: remove redundant tdi_reset

Stefani Seibold (1):
      USB: add ftdi_sio USB ID for GDM Boost V1.x

Svetoslav Neykov (1):
      usb: chipidea: big-endian support

Syam Sidhardhan (2):
      usb: serial: Remove redundant NULL check before kfree
      usb: otg: fsl_otg: remove redundant NULL check before kfree

Thierry Reding (1):
      usb: host: ehci-tegra: Fix oops in error cleanup

Thomas Abraham (1):
      usb: ohci-exynos: skip phy setup for Exynos5440 based platforms

Tony Camuso (1):
      xhci - clarify compliance mode debug messages

Tony Prisk (1):
      usb: ehci: unlink_empty_async_suspended() only used with CONFIG_PM

Tormod Volden (1):
      usb-storage: CY7C68300A chips do not support Cypress ATACB

Venu Byravarasu (1):
      usb: host: tegra: Reset Tegra USB controller before init

Vikas Sajjan (1):
      usb: dwc3: exynos: add basic suspend/resume support

Virupax Sadashivpetimath (1):
      usb: musb: ux500_dma: add missing MEM resource check

Vivek Gautam (6):
      usb: dwc3: set 'mode' based on selected Kconfig choices
      usb: phy: samsung: Common out the generic stuff
      usb: phy: samsung: Add PHY support for USB 3.0 controller
      usb: dwc3: exynos: Use of_platform API to create dwc3 core pdev
      usb: dwc3: exynos: use clk_prepare_enable and clk_disable_unprepare
      usb: ehci-s5p: fix: Fix null pointer dereferencing

Wei Yongjun (5):
      USB: misc: usb3503: use module_i2c_driver to simplify the code
      usbatm: fix potential NULL pointer dereference
      usb: gadget: f_obex: fix error return code in obex_bind()
      usb: gadget: multi: fix error return code in rndis_do_config()
      usb: gadget: cdc2: fix error return code in cdc_do_config()

Wesley W. Terpstra (1):
      usb-serial: add support for USB Wishbone-serial adapters

Yuan-Hsin Chen (2):
      usb: gadget: fusb300_udc: add FUSB300_EPSET0_STL_CLR for clearing EP0 stall
      usb: gadget: fusb300_udc: bug fix of not doing idma reset for each time

Zhang Yanfei (1):
      driver: usb: storage: remove cast for kmalloc return value

 Documentation/ABI/testing/sysfs-bus-usb            |    6 +-
 .../devicetree/bindings/usb/ci13xxx-imx.txt        |    2 +
 .../devicetree/bindings/usb/ehci-omap.txt          |   32 +
 .../devicetree/bindings/usb/ohci-omap3.txt         |   15 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |   40 +-
 .../devicetree/bindings/usb/samsung-usbphy.txt     |   76 +-
 .../devicetree/bindings/usb/usb-nop-xceiv.txt      |   34 +
 Documentation/ioctl/ioctl-number.txt               |    1 +
 Documentation/usb/power-management.txt             |   10 +-
 arch/arm/Kconfig                                   |    2 +
 arch/arm/configs/imx_v6_v7_defconfig               |    1 +
 arch/arm/configs/lpc32xx_defconfig                 |    1 +
 arch/arm/configs/mxs_defconfig                     |    1 +
 arch/arm/configs/omap1_defconfig                   |    1 +
 arch/arm/mach-exynos/setup-usb-phy.c               |    8 +-
 arch/arm/mach-mmp/aspenite.c                       |    6 -
 arch/arm/mach-mmp/ttc_dkb.c                        |    6 -
 arch/arm/mach-s3c64xx/setup-usb-phy.c              |    4 +-
 arch/arm/mach-s5pv210/setup-usb-phy.c              |    4 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |    8 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |    8 +-
 arch/arm/mach-shmobile/board-mackerel.c            |   12 +-
 arch/arm/mach-tegra/Kconfig                        |    8 +-
 arch/arm/plat-samsung/include/plat/usb-phy.h       |    5 +-
 arch/mips/Kconfig                                  |    3 +
 arch/powerpc/platforms/44x/Kconfig                 |    2 +
 arch/powerpc/platforms/512x/Kconfig                |    2 +
 arch/sh/boards/mach-ecovec24/setup.c               |    4 +-
 arch/sparc/Kconfig                                 |    2 +
 drivers/Makefile                                   |    2 +-
 drivers/hid/usbhid/hid-core.c                      |   14 +-
 drivers/net/usb/cdc_mbim.c                         |    5 +
 drivers/net/usb/qmi_wwan.c                         |    5 +
 drivers/net/usb/smsc75xx.c                         |    6 +-
 drivers/net/usb/smsc95xx.c                         |    6 +-
 drivers/power/Kconfig                              |    2 +-
 drivers/power/pda_power.c                          |   14 +-
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/usb/Kconfig                                |   25 +-
 drivers/usb/Makefile                               |    4 +-
 drivers/usb/atm/Kconfig                            |    2 +-
 drivers/usb/atm/usbatm.c                           |    6 +-
 drivers/usb/chipidea/Makefile                      |    2 +-
 drivers/usb/chipidea/ci.h                          |   19 +-
 drivers/usb/chipidea/ci13xxx_imx.c                 |   12 +
 drivers/usb/chipidea/ci13xxx_imx.h                 |    3 +
 drivers/usb/chipidea/ci13xxx_pci.c                 |    6 +-
 drivers/usb/chipidea/core.c                        |   66 +-
 drivers/usb/chipidea/debug.c                       |  888 ++++-------------
 drivers/usb/chipidea/debug.h                       |   34 +-
 drivers/usb/chipidea/udc.c                         |  299 +++---
 drivers/usb/chipidea/udc.h                         |    4 +-
 drivers/usb/chipidea/usbmisc_imx.c                 |  261 +++++
 drivers/usb/chipidea/usbmisc_imx6q.c               |  162 ----
 drivers/usb/class/Kconfig                          |    6 +-
 drivers/usb/class/cdc-acm.c                        |    8 -
 drivers/usb/class/cdc-wdm.c                        |   19 +
 drivers/usb/class/usbtmc.c                         |   26 +-
 drivers/usb/core/Kconfig                           |   36 +-
 drivers/usb/core/devio.c                           |    2 +
 drivers/usb/core/driver.c                          |   25 +-
 drivers/usb/core/generic.c                         |    2 +-
 drivers/usb/core/hcd-pci.c                         |  214 +++--
 drivers/usb/core/hcd.c                             |   10 +-
 drivers/usb/core/hub.c                             |  136 ++-
 drivers/usb/core/port.c                            |    4 +-
 drivers/usb/core/quirks.c                          |   16 +-
 drivers/usb/core/sysfs.c                           |    4 +-
 drivers/usb/core/urb.c                             |    5 +-
 drivers/usb/core/usb.c                             |    4 +-
 drivers/usb/core/usb.h                             |    2 +-
 drivers/usb/dwc3/Kconfig                           |    1 -
 drivers/usb/dwc3/core.c                            |  201 +++-
 drivers/usb/dwc3/core.h                            |   72 +-
 drivers/usb/dwc3/debugfs.c                         |   52 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |   98 +-
 drivers/usb/dwc3/dwc3-omap.c                       |  245 +++--
 drivers/usb/dwc3/dwc3-pci.c                        |   38 +
 drivers/usb/dwc3/ep0.c                             |   33 +-
 drivers/usb/dwc3/gadget.c                          |  321 +++++--
 drivers/usb/gadget/Kconfig                         |   20 +-
 drivers/usb/gadget/Makefile                        |   13 +-
 drivers/usb/gadget/acm_ms.c                        |   15 +-
 drivers/usb/gadget/amd5536udc.c                    |   16 +-
 drivers/usb/gadget/amd5536udc.h                    |    1 -
 drivers/usb/gadget/at91_udc.c                      |   14 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   44 +-
 drivers/usb/gadget/atmel_usba_udc.h                |    6 -
 drivers/usb/gadget/bcm63xx_udc.c                   |   23 -
 drivers/usb/gadget/cdc2.c                          |   31 +-
 drivers/usb/gadget/composite.c                     |    1 +
 drivers/usb/gadget/configfs.c                      | 1003 ++++++++++++++++++++
 drivers/usb/gadget/dummy_hcd.c                     |   19 +-
 drivers/usb/gadget/ether.c                         |   20 +-
 drivers/usb/gadget/f_acm.c                         |  137 +--
 drivers/usb/gadget/f_ecm.c                         |    4 +-
 drivers/usb/gadget/f_eem.c                         |    3 +-
 drivers/usb/gadget/f_ncm.c                         |    4 +-
 drivers/usb/gadget/f_obex.c                        |  227 ++++-
 drivers/usb/gadget/f_rndis.c                       |    3 +-
 drivers/usb/gadget/f_serial.c                      |  174 +++-
 drivers/usb/gadget/f_sourcesink.c                  |    4 +-
 drivers/usb/gadget/f_subset.c                      |    4 +-
 drivers/usb/gadget/f_uvc.c                         |  262 +++--
 drivers/usb/gadget/f_uvc.h                         |   12 +-
 drivers/usb/gadget/fsl_qe_udc.c                    |   18 +-
 drivers/usb/gadget/fsl_udc_core.c                  |   83 +-
 drivers/usb/gadget/fusb300_udc.c                   |   46 +-
 drivers/usb/gadget/fusb300_udc.h                   |    2 +-
 drivers/usb/gadget/g_ffs.c                         |   35 +-
 drivers/usb/gadget/goku_udc.c                      |   20 +-
 drivers/usb/gadget/goku_udc.h                      |    3 +-
 drivers/usb/gadget/imx_udc.c                       |   16 +-
 drivers/usb/gadget/lpc32xx_udc.c                   |   51 +-
 drivers/usb/gadget/m66592-udc.c                    |   17 -
 drivers/usb/gadget/multi.c                         |   33 +-
 drivers/usb/gadget/mv_u3d_core.c                   |   65 +-
 drivers/usb/gadget/mv_udc.h                        |    3 +-
 drivers/usb/gadget/mv_udc_core.c                   |  117 +--
 drivers/usb/gadget/ncm.c                           |   13 +-
 drivers/usb/gadget/net2272.c                       |   25 +-
 drivers/usb/gadget/net2280.c                       |   25 +-
 drivers/usb/gadget/nokia.c                         |   95 +-
 drivers/usb/gadget/omap_udc.c                      |   21 +-
 drivers/usb/gadget/pch_udc.c                       |   21 +-
 drivers/usb/gadget/pxa25x_udc.c                    |   16 -
 drivers/usb/gadget/pxa27x_udc.c                    |   51 +-
 drivers/usb/gadget/r8a66597-udc.c                  |   14 +-
 drivers/usb/gadget/s3c-hsotg.c                     |   78 +-
 drivers/usb/gadget/s3c-hsudc.c                     |   16 -
 drivers/usb/gadget/s3c2410_udc.c                   |   15 -
 drivers/usb/gadget/serial.c                        |   59 +-
 drivers/usb/gadget/u_ether.c                       |   32 +-
 drivers/usb/gadget/u_ether.h                       |   27 +-
 drivers/usb/gadget/u_serial.h                      |    1 -
 drivers/usb/gadget/udc-core.c                      |   90 +-
 drivers/usb/gadget/uvc.h                           |    3 +-
 drivers/usb/gadget/uvc_queue.c                     |  538 ++++-------
 drivers/usb/gadget/uvc_queue.h                     |   32 +-
 drivers/usb/gadget/uvc_v4l2.c                      |   71 +-
 drivers/usb/gadget/uvc_video.c                     |   31 +-
 drivers/usb/gadget/zero.c                          |    2 +
 drivers/usb/host/Kconfig                           |  217 +++--
 drivers/usb/host/Makefile                          |    6 +
 drivers/usb/host/ehci-atmel.c                      |   88 +-
 drivers/usb/host/ehci-dbg.c                        |   15 +-
 drivers/usb/host/ehci-fsl.c                        |    9 +
 drivers/usb/host/ehci-hcd.c                        |  107 +--
 drivers/usb/host/ehci-hub.c                        |   23 +-
 drivers/usb/host/ehci-msm.c                        |   91 +-
 drivers/usb/host/ehci-mv.c                         |   56 +-
 drivers/usb/host/ehci-mxc.c                        |   10 +-
 drivers/usb/host/ehci-omap.c                       |  331 +++----
 drivers/usb/host/ehci-orion.c                      |   86 +-
 drivers/usb/host/ehci-pci.c                        |   14 +-
 drivers/usb/host/ehci-platform.c                   |   36 +-
 drivers/usb/host/ehci-ps3.c                        |    1 -
 drivers/usb/host/ehci-q.c                          |  241 ++---
 drivers/usb/host/ehci-s5p.c                        |  180 ++--
 drivers/usb/host/ehci-sched.c                      |   40 +-
 drivers/usb/host/ehci-sh.c                         |    5 +-
 drivers/usb/host/ehci-spear.c                      |  119 ++-
 drivers/usb/host/ehci-tegra.c                      |   34 +-
 drivers/usb/host/ehci-timer.c                      |   72 +-
 drivers/usb/host/ehci-vt8500.c                     |  150 ---
 drivers/usb/host/ehci.h                            |   16 +-
 drivers/usb/host/ohci-exynos.c                     |   14 +-
 drivers/usb/host/ohci-hcd.c                        |  136 ++-
 drivers/usb/host/ohci-hub.c                        |    6 -
 drivers/usb/host/ohci-omap3.c                      |   24 +-
 drivers/usb/host/sl811-hcd.c                       |    2 +-
 drivers/usb/host/u132-hcd.c                        |    9 +-
 drivers/usb/host/xhci-hub.c                        |    2 +-
 drivers/usb/host/xhci-mem.c                        |   16 +-
 drivers/usb/host/xhci.c                            |   18 +-
 drivers/usb/host/xhci.h                            |    4 +-
 drivers/usb/image/Kconfig                          |    4 +-
 drivers/usb/misc/Kconfig                           |   21 -
 drivers/usb/misc/appledisplay.c                    |    1 +
 drivers/usb/misc/sisusbvga/Kconfig                 |    2 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |    2 +-
 drivers/usb/misc/usb3503.c                         |   13 +-
 drivers/usb/mon/Kconfig                            |    1 -
 drivers/usb/musb/Kconfig                           |    8 +-
 drivers/usb/musb/am35x.c                           |    8 +-
 drivers/usb/musb/blackfin.c                        |    6 +-
 drivers/usb/musb/cppi_dma.c                        |   17 +-
 drivers/usb/musb/da8xx.c                           |    8 +-
 drivers/usb/musb/davinci.c                         |    4 +-
 drivers/usb/musb/musb_core.c                       |   71 +-
 drivers/usb/musb/musb_dsps.c                       |   14 +-
 drivers/usb/musb/musb_gadget.c                     |  156 +--
 drivers/usb/musb/musb_gadget_ep0.c                 |    6 +-
 drivers/usb/musb/musb_host.c                       |  119 ++-
 drivers/usb/musb/musb_virthub.c                    |    4 +-
 drivers/usb/musb/omap2430.c                        |   32 +-
 drivers/usb/musb/tusb6010.c                        |   14 +-
 drivers/usb/musb/ux500.c                           |  106 +++
 drivers/usb/musb/ux500_dma.c                       |   24 +-
 drivers/usb/otg/Kconfig                            |  141 ---
 drivers/usb/otg/Makefile                           |   24 -
 drivers/usb/otg/ab8500-usb.c                       |  596 ------------
 drivers/usb/phy/Kconfig                            |  180 +++-
 drivers/usb/phy/Makefile                           |   35 +-
 drivers/usb/phy/isp1301.c                          |   71 --
 drivers/usb/phy/phy-ab8500-usb.c                   |  924 ++++++++++++++++++
 drivers/usb/{otg/fsl_otg.c => phy/phy-fsl-usb.c}   |   34 +-
 drivers/usb/{otg/fsl_otg.h => phy/phy-fsl-usb.h}   |    0
 drivers/usb/{otg/otg_fsm.c => phy/phy-fsm-usb.c}   |    4 +-
 drivers/usb/{otg/otg_fsm.h => phy/phy-fsm-usb.h}   |    0
 .../{otg/gpio_vbus.c => phy/phy-gpio-vbus-usb.c}   |    9 +-
 .../{otg/isp1301_omap.c => phy/phy-isp1301-omap.c} |   10 +-
 drivers/usb/phy/phy-isp1301.c                      |  162 ++++
 drivers/usb/{otg/msm_otg.c => phy/phy-msm-usb.c}   |    0
 drivers/usb/phy/{mv_u3d_phy.c => phy-mv-u3d-usb.c} |    4 +-
 drivers/usb/phy/{mv_u3d_phy.h => phy-mv-u3d-usb.h} |    0
 drivers/usb/{otg/mv_otg.c => phy/phy-mv-usb.c}     |   30 +-
 drivers/usb/{otg/mv_otg.h => phy/phy-mv-usb.h}     |    3 +-
 drivers/usb/{otg/mxs-phy.c => phy/phy-mxs-usb.c}   |   41 +-
 drivers/usb/{otg/nop-usb-xceiv.c => phy/phy-nop.c} |  143 ++-
 .../phy/{omap-control-usb.c => phy-omap-control.c} |    0
 drivers/usb/phy/{omap-usb2.c => phy-omap-usb2.c}   |    0
 drivers/usb/phy/{omap-usb3.c => phy-omap-usb3.c}   |    0
 drivers/usb/phy/{rcar-phy.c => phy-rcar-usb.c}     |    0
 drivers/usb/phy/phy-samsung-usb.c                  |  236 +++++
 drivers/usb/phy/phy-samsung-usb.h                  |  327 +++++++
 drivers/usb/phy/phy-samsung-usb2.c                 |  509 ++++++++++
 drivers/usb/phy/phy-samsung-usb3.c                 |  347 +++++++
 .../usb/phy/{tegra_usb_phy.c => phy-tegra-usb.c}   |   13 +-
 .../{otg/twl4030-usb.c => phy/phy-twl4030-usb.c}   |  178 ++--
 .../{otg/twl6030-usb.c => phy/phy-twl6030-usb.c}   |   15 +-
 .../ulpi_viewport.c => phy/phy-ulpi-viewport.c}    |    0
 drivers/usb/{otg/ulpi.c => phy/phy-ulpi.c}         |    0
 drivers/usb/{otg/otg.c => phy/phy.c}               |   64 +-
 drivers/usb/phy/samsung-usbphy.c                   |  928 ------------------
 drivers/usb/renesas_usbhs/Kconfig                  |    2 +-
 drivers/usb/renesas_usbhs/fifo.c                   |    1 -
 drivers/usb/renesas_usbhs/fifo.h                   |    2 -
 drivers/usb/renesas_usbhs/mod_gadget.c             |   24 +-
 drivers/usb/serial/Kconfig                         |   19 +-
 drivers/usb/serial/Makefile                        |    1 +
 drivers/usb/serial/ark3116.c                       |   87 +-
 drivers/usb/serial/bus.c                           |    5 +-
 drivers/usb/serial/ch341.c                         |   30 +-
 drivers/usb/serial/cp210x.c                        |    6 +-
 drivers/usb/serial/cyberjack.c                     |   19 +-
 drivers/usb/serial/cypress_m8.c                    |   94 +-
 drivers/usb/serial/digi_acceleport.c               |   95 +-
 drivers/usb/serial/f81232.c                        |   13 +-
 drivers/usb/serial/ftdi_sio.c                      |  144 +--
 drivers/usb/serial/ftdi_sio_ids.h                  |    4 +-
 drivers/usb/serial/garmin_gps.c                    |   10 -
 drivers/usb/serial/generic.c                       |  144 ++-
 drivers/usb/serial/io_edgeport.c                   |   76 +-
 drivers/usb/serial/io_tables.h                     |   12 +-
 drivers/usb/serial/io_ti.c                         |   98 +-
 drivers/usb/serial/iuu_phoenix.c                   |   21 +-
 drivers/usb/serial/keyspan.c                       |   96 +-
 drivers/usb/serial/keyspan_pda.c                   |   19 +-
 drivers/usb/serial/kl5kusb105.c                    |   30 +-
 drivers/usb/serial/kobil_sct.c                     |  103 +-
 drivers/usb/serial/mct_u232.c                      |  131 +--
 drivers/usb/serial/metro-usb.c                     |    5 +-
 drivers/usb/serial/mos7720.c                       |   68 +-
 drivers/usb/serial/mos7840.c                       |  157 +--
 drivers/usb/serial/omninet.c                       |   81 +-
 drivers/usb/serial/opticon.c                       |   18 +-
 drivers/usb/serial/option.c                        |    8 +
 drivers/usb/serial/oti6858.c                       |   30 +-
 drivers/usb/serial/pl2303.c                        |   39 +-
 drivers/usb/serial/quatech2.c                      |  104 +-
 drivers/usb/serial/sierra.c                        |   39 +-
 drivers/usb/serial/spcp8x5.c                       |  301 ++----
 drivers/usb/serial/ssu100.c                        |  100 +-
 drivers/usb/serial/symbolserial.c                  |  130 +--
 drivers/usb/serial/ti_usb_3410_5052.c              |  163 +---
 drivers/usb/serial/usb-serial.c                    |  232 +++--
 drivers/usb/serial/usb_wwan.c                      |   25 +-
 drivers/usb/serial/visor.c                         |   16 +-
 drivers/usb/serial/wishbone-serial.c               |   95 ++
 drivers/usb/storage/Kconfig                        |    7 +-
 drivers/usb/storage/alauda.c                       |  101 +-
 drivers/usb/storage/cypress_atacb.c                |   18 +-
 drivers/usb/storage/datafab.c                      |   59 +-
 drivers/usb/storage/debug.c                        |   36 +-
 drivers/usb/storage/debug.h                        |   23 +-
 drivers/usb/storage/ene_ub6250.c                   |   86 +-
 drivers/usb/storage/freecom.c                      |   85 +-
 drivers/usb/storage/initializers.c                 |   10 +-
 drivers/usb/storage/isd200.c                       |  295 +++---
 drivers/usb/storage/jumpshot.c                     |   69 +-
 drivers/usb/storage/karma.c                        |    6 +-
 drivers/usb/storage/onetouch.c                     |    4 +-
 drivers/usb/storage/option_ms.c                    |   23 +-
 drivers/usb/storage/realtek_cr.c                   |  128 +--
 drivers/usb/storage/scsiglue.c                     |   13 +-
 drivers/usb/storage/sddr09.c                       |  146 ++-
 drivers/usb/storage/sddr55.c                       |   86 +-
 drivers/usb/storage/shuttle_usbat.c                |  119 +--
 drivers/usb/storage/sierra_ms.c                    |   43 +-
 drivers/usb/storage/transport.c                    |  181 ++--
 drivers/usb/storage/usb.c                          |  117 +--
 drivers/usb/usb-common.c                           |   47 +
 drivers/usb/usb-skeleton.c                         |   32 +-
 drivers/usb/wusbcore/Kconfig                       |    2 -
 include/linux/platform_data/dwc3-omap.h            |    4 -
 include/linux/platform_data/mv_usb.h               |    2 -
 include/linux/usb.h                                |   13 +-
 include/linux/usb/cdc-wdm.h                        |    2 +
 include/linux/usb/ch9.h                            |    9 +
 include/linux/usb/composite.h                      |    3 +
 include/linux/usb/dwc3-omap.h                      |    6 +-
 include/linux/usb/gadget.h                         |   11 +
 include/linux/usb/gadget_configfs.h                |  110 +++
 include/linux/usb/hcd.h                            |    6 +-
 include/linux/usb/musb-ux500.h                     |   31 +
 include/linux/usb/nop-usb-xceiv.h                  |    5 +
 include/linux/usb/otg.h                            |    9 +-
 include/linux/usb/phy.h                            |   33 +-
 include/linux/usb/renesas_usbhs.h                  |    6 +-
 include/linux/usb/serial.h                         |   12 +-
 include/linux/usb/tegra_usb_phy.h                  |   10 +-
 include/uapi/linux/usb/cdc-wdm.h                   |   21 +
 include/uapi/linux/usb/ch9.h                       |    4 +-
 325 files changed, 10498 insertions(+), 9858 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/ehci-omap.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-omap3.txt
 create mode 100644 Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
 create mode 100644 drivers/usb/chipidea/usbmisc_imx.c
 delete mode 100644 drivers/usb/chipidea/usbmisc_imx6q.c
 create mode 100644 drivers/usb/gadget/configfs.c
 delete mode 100644 drivers/usb/host/ehci-vt8500.c
 delete mode 100644 drivers/usb/otg/Kconfig
 delete mode 100644 drivers/usb/otg/Makefile
 delete mode 100644 drivers/usb/otg/ab8500-usb.c
 delete mode 100644 drivers/usb/phy/isp1301.c
 create mode 100644 drivers/usb/phy/phy-ab8500-usb.c
 rename drivers/usb/{otg/fsl_otg.c => phy/phy-fsl-usb.c} (97%)
 rename drivers/usb/{otg/fsl_otg.h => phy/phy-fsl-usb.h} (100%)
 rename drivers/usb/{otg/otg_fsm.c => phy/phy-fsm-usb.c} (99%)
 rename drivers/usb/{otg/otg_fsm.h => phy/phy-fsm-usb.h} (100%)
 rename drivers/usb/{otg/gpio_vbus.c => phy/phy-gpio-vbus-usb.c} (98%)
 rename drivers/usb/{otg/isp1301_omap.c => phy/phy-isp1301-omap.c} (99%)
 create mode 100644 drivers/usb/phy/phy-isp1301.c
 rename drivers/usb/{otg/msm_otg.c => phy/phy-msm-usb.c} (100%)
 rename drivers/usb/phy/{mv_u3d_phy.c => phy-mv-u3d-usb.c} (99%)
 rename drivers/usb/phy/{mv_u3d_phy.h => phy-mv-u3d-usb.h} (100%)
 rename drivers/usb/{otg/mv_otg.c => phy/phy-mv-usb.c} (97%)
 rename drivers/usb/{otg/mv_otg.h => phy/phy-mv-usb.h} (99%)
 rename drivers/usb/{otg/mxs-phy.c => phy/phy-mxs-usb.c} (84%)
 rename drivers/usb/{otg/nop-usb-xceiv.c => phy/phy-nop.c} (55%)
 rename drivers/usb/phy/{omap-control-usb.c => phy-omap-control.c} (100%)
 rename drivers/usb/phy/{omap-usb2.c => phy-omap-usb2.c} (100%)
 rename drivers/usb/phy/{omap-usb3.c => phy-omap-usb3.c} (100%)
 rename drivers/usb/phy/{rcar-phy.c => phy-rcar-usb.c} (100%)
 create mode 100644 drivers/usb/phy/phy-samsung-usb.c
 create mode 100644 drivers/usb/phy/phy-samsung-usb.h
 create mode 100644 drivers/usb/phy/phy-samsung-usb2.c
 create mode 100644 drivers/usb/phy/phy-samsung-usb3.c
 rename drivers/usb/phy/{tegra_usb_phy.c => phy-tegra-usb.c} (98%)
 rename drivers/usb/{otg/twl4030-usb.c => phy/phy-twl4030-usb.c} (84%)
 rename drivers/usb/{otg/twl6030-usb.c => phy/phy-twl6030-usb.c} (97%)
 rename drivers/usb/{otg/ulpi_viewport.c => phy/phy-ulpi-viewport.c} (100%)
 rename drivers/usb/{otg/ulpi.c => phy/phy-ulpi.c} (100%)
 rename drivers/usb/{otg/otg.c => phy/phy.c} (88%)
 delete mode 100644 drivers/usb/phy/samsung-usbphy.c
 create mode 100644 drivers/usb/serial/wishbone-serial.c
 create mode 100644 include/linux/usb/gadget_configfs.h
 create mode 100644 include/linux/usb/musb-ux500.h
 create mode 100644 include/uapi/linux/usb/cdc-wdm.h
