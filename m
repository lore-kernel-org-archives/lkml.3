Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3KFW6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:58:07 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34022 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3KFW5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:57:22 -0500
Date: Wed, 6 Nov 2013 14:53:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.13-rc1
Message-ID: <20131106225314.GA8702@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.13-rc1

for you to fetch changes up to 7d49f0bac41ee9b012af1efe2f725d91a87a8fe9:

  USB: Maintainers change for usb serial drivers (2013-10-31 08:53:52 -0700)

----------------------------------------------------------------
USB driver update for 3.13-rc1

Here's the big USB driver update for 3.13-rc1.

It includes the usual xhci changes, EHCI updates to get the scheduling
of USB transactions working better, and a raft of gadget and musb
updates as well.

All of this has been in linux-next for a while with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (21):
      USB: see if URB comes from a completion handler
      USB: EHCI: code rearrangement in iso_stream_schedule()
      USB: EHCI: handle isochronous underruns with tasklets
      USB: fix substandard locking for the sysfs files
      USB: NS_TO_US should round up
      USB: EHCI: check the right uframes for CSPLIT
      USB: EHCI: compute full-speed bandwidth usage correctly
      USB: EHCI: No SSPLIT allowed in uframe 7
      USB: EHCI: change toggle only upon successful reset
      USB: EHCI: use consistent NO_FRAME value
      USB: EHCI: create a "periodic schedule info" struct
      USB: EHCI: use a bandwidth-allocation table
      USB: add a private-data pointer to struct usb_tt
      USB: EHCI: create per-TT bandwidth tables
      USB: EHCI: start new isochronous streams ASAP
      USB: EHCI: fix type mismatch in check_intr_schedule
      USB: EHCI: fix sparse errors
      USB: OHCI: fix and explain sparse errors
      USB: change dev_warn about missing reset-resume to dev_dbg
      USB: EHCI: add check for wakeup/suspend race
      USB: UHCI: check for wakeup/suspend race

Alexey Khoroshilov (1):
      USB: wusbcore: fix usb_dev leaks

Andreas Larsson (1):
      usb: gadget: Make VERBOSE_DEBUG enableable via Kconfig

Andrzej Pietrasiewicz (29):
      usb: gadget: configfs: add a method to unregister the gadget
      usb: gadget: create a utility module for mass_storage
      usb: gadget: f_mass_storage: factor out a header file
      usb: gadget: f_mass_storage: add a level of indirection for luns storage
      usb: gadget: f_mass_storage: use usb_gstrings_attach
      usb: gadget: f_mass_storage: create _fsg_common_free_buffers
      usb: gadget: f_mass_storage: make sysfs interface optional
      usb: gadget: f_mass_storage: create fsg_common_setup for use in fsg_common_init
      usb: gadget: f_mass_storage: create fsg_common_set_num_buffers for use in fsg_common_init
      usb: gadget: f_mass_storage: create lun handling helpers for use in fsg_common_init
      usb: gadget: f_mass_storage: create fsg_common_set_cdev for use in fsg_common_init
      usb: gadget: f_mass_storage: create lun creation helpers for use in fsg_common_init
      usb: gadget: f_mass_storage: create fsg_common_set_inquiry_string for use in fsg_common_init
      usb: gadget: f_mass_storage: create fsg_common_run_thread for use in fsg_common_init
      usb: gadget: f_mass_storage: convert to new function interface with backward compatibility
      usb: gadget: mass_storage: convert to new interface of f_mass_storage
      usb: gadget: storage_common: make attribute operations more generic
      usb: gadget: storage_common: add methods to show/store 'cdrom' and 'removable'
      usb: gadget: f_mass_storage: add configfs support
      usb: gadget: acm_ms: convert to new interface of f_mass_storage
      usb: gadget: multi: convert to new interface of f_ecm
      usb: gadget: multi: convert to new interface of f_rndis
      usb: gadget: multi: convert to new interface of f_mass_storage
      usb: gadget: f_mass_storage: remove compatibility layer
      usb: gadget: mass_storage: merge usb_f_mass_storage module with u_ms module
      usb: gadget: storage_common: use strtobool instead of kstrtouint
      usb: gadget: storage_common: pass filesem to fsg_store_cdrom
      usb: gadget: f_mass_storage: style corrections, cleanup & simplification
      usb/gadget: f_mass_storage: use string literal as format in dev_set_name

Anton Tikhomirov (10):
      usb: phy: Pass OTG FSM pointer to callback functions
      usb: phy: Check OTG FSM callback existance in helper functions
      usb: phy: Add and use missed helper functions
      usb: phy: Fix OTG FSM timer handling
      usb: phy: Add and use missed OTG FSM timers
      usb: phy: Rename OTG FSM informative variables
      usb: phy: Rename "B-device session end SRP" OTG FSM input
      usb: phy: Add and use missed OTG FSM inputs/outputs
      usb: phy: Reordering of OTG FSM variables
      USB: phy: samsung: Support multiple PHYs of same type

Bjorn Helgaas (1):
      USB: correct the usb_disconnect() comment about usb_bus_list_lock

Bjørn Mork (1):
      usb: cdc-wdm: ignore speed change notifications

Boris BREZILLON (1):
      USB: ehci-atmel: add usb_clk for transition to CCF

Dan Carpenter (1):
      USB: cyberjack: fix buggy integer overflow test

Dan Williams (3):
      usb: hub_activate kill an 'else'
      usb: xhci: kill a conditional when toggling cycle
      usb: xhci: remove the unused ->address field

Daniel Mack (3):
      usb: musb: am35x: use SIMPLE_DEV_PM_OPS
      usb: musb: blackfin: use SIMPLE_DEV_PM_OPS
      usb: musb: ux500: use SIMPLE_DEV_PM_OPS

Dave Jones (1):
      USB: phy: Restrict AM335x PHY driver to only be built on !ARM when COMPILE_TEST is set.

David Cohen (2):
      usb: g_ffs: fix compilation warning
      usb: g_ffs: fix compilation warning

Deng-Cheng Zhu (2):
      USB/host: Use existing macros instead of hard-coded values in uhci-debug.c
      USB/host: Bugfix: Return length of copied buffer in uhci_hub_control()

Duan Jiong (1):
      usb: gadget: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))

Fabio Estevam (1):
      usb: gadget: udc-core: Do not report -EISNAM error from gadgetfs

Felipe Balbi (1):
      usb: dwc3: core: use pm_runtime_put_sync() on remove

Fengguang Wu (2):
      usb: pci-quirks: amd_chipset_sb_type_init() can be static
      usb: core: usb_amd_resume_quirk() can be static

Gabor Juhos (1):
      usb: phy: don't return with NULL from devm_usb_get_phy()

Greg KH (1):
      USB: Maintainers change for usb serial drivers

Greg Kroah-Hartman (15):
      Merge branch 'master' into usb-next
      Revert "Revert "USB: EHCI: support running URB giveback in tasklet context""
      Merge 3.12-rc3 into usb-next
      Merge 3.12-rc4 into usb-next
      Revert "USB: OHCI: Properly handle ohci-spear suspend"
      Revert "USB: OHCI: Properly handle ohci-exynos suspend"
      Revert "USB: OHCI: Properly handle ohci-ep93xx suspend"
      Revert "USB: OHCI: Properly handle ohci-da8xx suspend"
      Revert "USB: OHCI: Properly handle ohci-s3c2410 suspend"
      Revert "USB: OHCI: Properly handle ohci-at91 suspend"
      Revert "USB: OHCI: Properly handle OHCI controller suspend"
      Merge 3.12-rc6 into usb-next.
      Merge tag 'for-usb-next-2013-10-17' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge tag 'usb-for-v3.13' of git://git.kernel.org/.../balbi/usb into usb-next
      UWB: clean up attribute use by using ATTRIBUTE_GROUPS()

Greg Suarez (1):
      USB: cdc-wdm: support back-to-back USB_CDC_NOTIFY_RESPONSE_AVAILABLE notifications

H Hartley Sweeten (2):
      ARM: ep93xx_defconfig: cleanup ep93xx_defconfig
      usb: ohci: remove ep93xx bus glue platform driver

Hans de Goede (3):
      usb-core: Make usb_free_streams return an error
      usb-anchor: Ensure poisened gets initialized to 0
      usb-anchor: Delay usb_wait_anchor_empty_timeout wake up till completion is done

Heikki Krogerus (1):
      usb: remove intel_mid_otg.h

Huang Rui (11):
      usb: pci-quirks: refactor AMD quirk to abstract AMD chipset types
      usb: core: implement AMD remote wakeup quirk
      usb: usbtest: bmAttributes would better be masked
      usb: usbtest: bmAttributes would better be masked
      usb: ehci: use amd_chipset_type to filter for usb subsystem hang bug
      usb: ohci: use amd_chipset_type to filter for SB800 prefetch
      usb: usbtest: fix checkpatch warning as sizeof code style
      usb: usbtest: support bos descriptor test for usb 3.0
      usb: usbtest: support usb2 extension descriptor test
      usb: usbtest: support superspeed device capbility descriptor test
      usb: usbtest: support container id descriptor test

Ivan T. Ivanov (2):
      ehci-msm: Remove global struct usb_phy variable
      USB: ehci-msm: Add device tree support and binding information

Jingoo Han (13):
      USB: ehci-fsl: Remove casting the return value which is a void pointer
      usb: gadget: amd5536udc: remove unnecessary pci_set_drvdata()
      usb: gadget: goku_udc: remove unnecessary pci_set_drvdata()
      usb: gadget: pch_udc: remove unnecessary pci_set_drvdata()
      usb: gadget: net2280: remove unnecessary pci_set_drvdata()
      USB: ohci-exynos: Add missing usb_put_hcd() to prevent memory leak
      ARM: SAMSUNG: Remove unused s5p_device_ehci
      USB: ehci-s5p: Remove non-DT support
      USB: host: Rename ehci-s5p to ehci-exynos
      USB: ohci-exynos: Remove non-DT support
      phy: Add driver for Exynos DP PHY
      video: exynos_dp: remove non-DT support for Exynos Display Port
      video: exynos_dp: Use the generic PHY driver

Joe Perches (3):
      usb: Remove unnecessary semicolons
      printk: pr_debug_ratelimited: check state first to reduce "callbacks suppressed" messages
      usbatm: Fix dynamic_debug / ratelimited atm_dbg and atm_rldbg macros

Johan Hovold (4):
      USB: serial: clean up comments in generic driver
      USB: serial: add memory flags to usb_serial_generic_write_start
      USB: serial: export usb_serial_generic_write_start
      USB: mos7840: fix tiocmget error handling

Julius Werner (1):
      usb: hub: Clear Port Reset Change during init/resume

Kevin Hilman (1):
      USB: OHCI: ohci_init_driver(): sanity check overrides

Kishon Vijay Abraham I (7):
      drivers: phy: add generic PHY framework
      usb: phy: omap-usb2: use the new generic PHY framework
      usb: phy: twl4030: use the new generic PHY framework
      arm: omap3: twl: add phy consumer data in twl4030_usb_data
      ARM: dts: omap: update usb_otg_hs data
      usb: musb: omap2430: use the new generic PHY framework
      usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops

Linus Walleij (1):
      usb: musb: name ux500 platforms more broadly

Manjunath Goudar (21):
      USB: EHCI: make ehci-w90X900 a separate driver
      USB: OHCI: make ohci-exynos a separate driver
      USB: OHCI: make ohci-omap a separate driver
      USB: OHCI: make ohci-omap3 a separate driver
      USB: OHCI: make ohci-spear a separate driver
      USB: OHCI: make ohci-at91 a separate driver
      USB: OHCI: make ohci-s3c2410 a separate driver
      USB: OHCI: make ohci-nxp a separate driver
      USB: OHCI: make ohci-ep93xx a separate driver
      USB: OHCI: make ohci-pxa27x a separate driver
      USB: OHCI: Properly handle OHCI controller suspend
      USB: OHCI: Properly handle ohci-at91 suspend
      USB: OHCI: Properly handle ohci-s3c2410 suspend
      USB: OHCI: Properly handle ohci-da8xx suspend
      USB: OHCI: Properly handle ohci-ep93xx suspend
      USB: OHCI: Properly handle ohci-exynos suspend
      USB: OHCI: Properly handle ohci-omap suspend
      USB: OHCI: Properly handle ohci-platform suspend
      USB: OHCI: Properly handle ohci-pxa27x suspend
      USB: OHCI: Properly handle ohci-sm501 suspend
      USB: OHCI: Properly handle ohci-spear suspend

Mark Brown (1):
      usb: phy: nop: Defer clock prepare until PHY init

Mathias Nyman (1):
      xhci: Enable LPM support only for hardwired or BESL devices

Matthias Beyer (11):
      drivers: usb: core: hcd: moved asterix to variable
      drivers: usb: core: hcd: Whitespace fixes
      drivers: usb: core: hcd: replaced C99 // comments
      drivers: usb: core: hcd: removed braces for return statements
      drivers: usb: core: hcd: if-else-braces fixed
      drivers: usb: core: hcd.c: converted busmap from struct to bitmap
      drivers: usb: core: {file,hub,sysfs,usb}.c: Whitespace fixes
      drivers: usb: core: file.c: moved asterisk to variable name
      drivers: usb: core: hub.c: Comments shouldnt be C99 // comment style
      drivers: usb: core: devio.c: Spaces to tabs for proc_reapurbnonblock()
      drivers: usb: core: devio.c: Spaces to tabs for proc_control_compat()

Michael Opdenacker (4):
      usb: host: uhci-platform: remove deprecated IRQF_DISABLED
      usb: gadget: mv_u3d_core: remove deprecated IRQF_DISABLED
      usb: gadget: mv_u3d_core: remove deprecated IRQF_DISABLED
      usb/hcd: remove unnecessary local_irq_save

Pali Rohár (2):
      usb: musb: Add missing ATOMIC_INIT_NOTIFIER_HEAD
      usb: musb: Call atomic_notifier_call_chain when status is changed

Paul Chavent (2):
      USB: serial: call handle_dcd_change in ftdi driver.
      USB: serial: invoke dcd_change ldisc's handler.

Pavel Machek (1):
      usb: gadget: s3c-hsotg: fix CodingStyle issues

Peter Chen (12):
      chipidea: udc: free pending TD at removal procedure
      usb: host: delete chipidea dependency
      usb: chipidea: udc: Consolidate the call of disconnect
      usb: chipidea: move platform related things to ci_get_platdata
      usb: chipidea: move PHY operation to core
      usb: chipidea: imx: remove PHY operations
      usb: chipidea: add ci_hdrc_enter_lpm API
      usb: gadget: zero: Add flexible auto remote wakeup test method
      usb: chipidea: udc: Fix spinlock recursion during bus reset
      usb: chipidea: udc: Fix calling spin_lock_irqsave at sleep context
      usb: chipidea: host: more enhancement when ci->hcd is NULL
      usb: chipidea: only get vbus regulator for non-peripheral mode

Robert Baldyga (13):
      usb: gadget: s3c-hsotg: fix maxpacket size
      usb: gadget: s3c-hsotg: fix set_ep_maxpacket function
      usb: gadget: s3c-hsotg: add isochronous transfers support
      usb: gadget: s3c-hsotg: add multi count support
      usb: gadget: s3c-hsotg: remove unused label
      usb: gadget: s3c-hsotg: fix "protocol stall" handling
      usb: gadget: s3c-hsotg: fix s3c_hsotg_write_fifo function for dedicated fifo mode
      usb: gadget: s3c-hsotg: fix endpoint interrupts handling
      usb: gadget: s3c-hsotg: add DAINT masking
      usb: gadget: s3c-hsotg: fix "halted" property updating
      usb: gadget: s3c-hsotg: fix clear feature ENDPOINT_HALT
      usb: gadget: s3c-hsotg: fix interrupt configuration in dedicated-fifo mode
      usb: gadget: s3c-hsotg: fix can_write limit for non-periodic endpoints

Roger Quadros (12):
      usb: phy: omap-control: Get rid of platform data
      usb: phy: omap: Add new device types and remove omap_control_usb3_phy_power()
      usb: phy: omap-usb2: Don't use omap_get_control_dev()
      usb: phy: omap-usb3: Don't use omap_get_control_dev()
      usb: musb: omap2430: Don't use omap_get_control_dev()
      usb: phy: omap: get rid of omap_get_control_dev()
      ARM: dts: omap4: update omap-control-usb nodes
      ARM: dts: omap5: update omap-control-usb node
      usb: phy: generic: Add gpio_reset to platform data
      usb: phy: generic: Don't use regulator framework for RESET line
      ARM: OMAP2+: omap-usb-host: Get rid of platform_data from struct usbhs_phy_data
      ARM: OMAP2+: usb-host: Adapt to USB phy-nop RESET line changes

Rui li (1):
      USB：add new zte 3g-dongle's pid to option.c

Russell King (1):
      usb: musb: use platform_device_register_full() to avoid directly messing with dma masks

Sachin Kamat (10):
      usb: dwc3: Remove redundant pci_set_drvdata
      usb: gadget: Remove redundant pci_set_drvdata
      usb: dwc3: Remove redundant pci_set_drvdata
      usb: musb_dsps: Remove redundant of_match_ptr
      usb: phy: am335x-control: Remove redundant of_match_ptr
      usb: phy: am335x: Remove redundant of_match_ptr
      usb: phy: tegra-usb: Remove redundant of_match_ptr
      usb: musb_am335x: Remove redundant of_match_ptr
      usb: xhci: Staticize xhci_del_comp_mod_timer
      usb: phy: twl6030-usb: Include linux/of.h header

Sarah Sharp (4):
      usb: Disable USB 2.0 Link PM before device reset.
      xhci: Set L1 device slot on USB2 LPM enable/disable.
      usb: Don't enable USB 2.0 Link PM by default.
      usb: Push USB2 LPM disable on disconnect into USB core.

Sebastian Andrzej Siewior (10):
      usb: phy: am335x: add wakeup support
      usb: musb: cancel work on removal
      usb: musb: call musb_start() only once in OTG mode
      usb: musb: dsps: move try_idle to start hook
      usb: musb: dsps: remove declartion for dsps_musb_try_idle()
      usb: musb: dsps: redo the otg timer
      usb: musb: dsps: run the timer only on OTG systems
      usb: musb: core: properly free host / device structs in err path
      usb: musb: core: Call dma_controller_destroy() in error path only once.
      usb: musb: cppi41: allow to defer probing if DMA isn't yet available

Sergei Shtylyov (1):
      usb: musb: davinci: fix resources passed to MUSB driver for DM6467

Sylwester Nawrocki (5):
      phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
      exynos4-is: Use the generic MIPI CSIS PHY driver
      video: exynos_mipi_dsim: Use the generic PHY driver
      ARM: Samsung: Remove the MIPI PHY setup code
      phy: exynos-mipi-video: Fix phy_power_off() callback

Thomas Pugliese (22):
      usb: wusbcore: rename urb to tr_urb in struct wa_seg
      usb: wusbcore: rename fields in struct wahc
      usb: wusbcore: allow wa_xfer_destroy to clean up partially constructed xfers
      usb: wusbcore: resource cleanup fix in __wa_xfer_setup_segs
      usb: wusbcore: clean up the sg list that was created for out transfers
      usb: wusbcore: set pointers to NULL after freeing in error cases
      usb: wusbcore: fix endianess issues when using dwTransferID
      usb: wusbcore: include the xfer_id in debug prints
      usb: wusbcore: clean up urb dequeue process
      usb: wusbcore: fix build warning on 64-bit builds
      usb: wusbcore: avoid stack overflow in URB enqueue error path
      usb: wusbcore: implement hwahc_op_get_frame_number
      usb: wusbcore: set the RPIPE bOverTheAirInterval for isoc endpoints
      usb: wusbcore: Add isoc transfer type enum and packet definitions
      usb: wusbcore: add support for isoc out transfers
      usb: wusbcore: fix string formatting warnings on 64-bit builds
      usb: wusbcore: serialize access to the HWA data out endpoint
      usb: wusbcore: preserve endianness of cached descriptors
      usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
      usb: wusbcore: combine multiple isoc frames in a single transfer request.
      usb: wusbcore: add a quirk for Alereon HWA device isoc behavior
      usb: wusbcore: change WA_SEGS_MAX to a legal value

Tim Deegan (1):
      USB: ehci-dbgp: drop dead code.

Tom Gundersen (1):
      usb: ohci/uhci - add soft dependencies on ehci_pci

Valentin Ilie (1):
      usb: gadget: mv_u3d_core: fix memory leaks

Valentine Barshak (1):
      usb: phy: Add RCAR Gen2 USB phy

Vivek Gautam (1):
      usb: dwc3: Remove additional delay of 100ms when resuming

Wei Yongjun (2):
      USB: WUSBCORE: use list_move_tail instead of list_del/list_add_tail
      USB: EHCI: tegra: drop clk_put for devm_clk_get in tegra_ehci_probe()

Xenia Ragiadakou (20):
      usbcore: set lpm_capable field for LPM capable root hubs
      usbcore: fix incorrect type in assignment in usb_set_lpm_parameters()
      usbcore: fix read of usbdevfs_ctrltransfer fields in proc_control()
      xhci: remove unused argument from xhci_giveback_urb_in_irq()
      xhci: rename existing Command Completion Event handlers
      xhci: refactor TRB_ENABLE_SLOT case into function
      xhci: refactor TRB_DISABLE_SLOT case into function
      xhci: refactor TRB_ADDR_DEV case into function
      xhci: use completion event's slot id rather than dig it out of command
      xhci: refactor TRB_RESET_DEV case into function
      xhci: refactor TRB_NEC_GET_FW case into function
      xhci: refactor TRB_EVAL_CONTEXT case into function
      xhci: remove unused 'ep_ring' variable in handle_cmd_completion()
      xhci: refactor TRB_CONFIG_EP case into function
      xhci: add variable 'cmd_comp_code' in handle_cmd_completion()
      xhci: add variable 'cmd_trb' in handle_cmd_completion()
      xhci: add variable 'cmd_type' in handle_cmd_completion()
      xhci: replace 'xhci->cmd_ring->dequeue' with 'trb' in stop_ep cmd handler
      xhci: add argument 'slot_id' in stop_ep, set_deq and reset_ep cmd handlers
      xhci: replace 'event' with 'cmd_comp_code' in set_deq and reset_ep handlers

xiao jin (1):
      xhci: correct the usage of USB_CTRL_SET_TIMEOUT

 .../ABI/testing/configfs-usb-gadget-mass-storage   |   31 +
 .../devicetree/bindings/phy/phy-bindings.txt       |   66 +
 .../devicetree/bindings/phy/samsung-phy.txt        |   22 +
 .../devicetree/bindings/usb/msm-hsusb.txt          |   17 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |   39 +-
 .../devicetree/bindings/usb/usb-nop-xceiv.txt      |    7 +-
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 +
 .../devicetree/bindings/video/exynos_dp.txt        |   17 +-
 Documentation/phy.txt                              |  166 +++
 Documentation/pps/pps.txt                          |   15 +
 MAINTAINERS                                        |   61 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    2 +
 arch/arm/boot/dts/omap3-evm.dts                    |    2 +
 arch/arm/boot/dts/omap3-overo.dtsi                 |    2 +
 arch/arm/boot/dts/omap4.dtsi                       |   23 +-
 arch/arm/boot/dts/omap5.dtsi                       |   20 +-
 arch/arm/boot/dts/twl4030.dtsi                     |    1 +
 arch/arm/configs/ep93xx_defconfig                  |   17 +-
 arch/arm/mach-ep93xx/clock.c                       |    2 +-
 arch/arm/mach-ep93xx/core.c                        |   39 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |    5 -
 arch/arm/mach-omap2/board-omap3beagle.c            |    6 -
 arch/arm/mach-omap2/twl-common.c                   |   11 +
 arch/arm/mach-omap2/usb-host.c                     |   18 +-
 arch/arm/mach-omap2/usb.h                          |    1 -
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    4 -
 arch/arm/plat-samsung/Kconfig                      |   10 -
 arch/arm/plat-samsung/Makefile                     |    1 -
 arch/arm/plat-samsung/devs.c                       |   34 -
 arch/arm/plat-samsung/include/plat/devs.h          |    1 -
 arch/arm/plat-samsung/setup-mipiphy.c              |   60 -
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/media/platform/exynos4-is/Kconfig          |    2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   13 +-
 drivers/phy/Kconfig                                |   54 +
 drivers/phy/Makefile                               |    9 +
 drivers/phy/phy-core.c                             |  698 +++++++++++
 drivers/phy/phy-exynos-dp-video.c                  |  111 ++
 drivers/phy/phy-exynos-mipi-video.c                |  176 +++
 drivers/{usb => }/phy/phy-omap-usb2.c              |   72 +-
 drivers/{usb => }/phy/phy-twl4030-usb.c            |   71 +-
 drivers/usb/atm/usbatm.h                           |   14 +-
 drivers/usb/chipidea/bits.h                        |    1 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |   21 +-
 drivers/usb/chipidea/core.c                        |  123 +-
 drivers/usb/chipidea/host.c                        |    6 +-
 drivers/usb/chipidea/udc.c                         |   56 +-
 drivers/usb/class/cdc-wdm.c                        |   42 +-
 drivers/usb/core/devio.c                           |   38 +-
 drivers/usb/core/driver.c                          |    7 +-
 drivers/usb/core/file.c                            |    8 +-
 drivers/usb/core/hcd-pci.c                         |    3 +
 drivers/usb/core/hcd.c                             |  122 +-
 drivers/usb/core/hub.c                             |  182 +--
 drivers/usb/core/message.c                         |    4 +
 drivers/usb/core/quirks.c                          |   37 +
 drivers/usb/core/sysfs.c                           |   64 +-
 drivers/usb/core/urb.c                             |   44 +-
 drivers/usb/core/usb.c                             |    2 +-
 drivers/usb/core/usb.h                             |    1 +
 drivers/usb/dwc3/core.c                            |    3 +-
 drivers/usb/dwc3/dwc3-pci.c                        |    2 -
 drivers/usb/dwc3/ep0.c                             |    6 +-
 drivers/usb/early/ehci-dbgp.c                      |    4 -
 drivers/usb/gadget/Kconfig                         |   34 +-
 drivers/usb/gadget/Makefile                        |    5 +-
 drivers/usb/gadget/acm_ms.c                        |  125 +-
 drivers/usb/gadget/amd5536udc.c                    |    2 -
 drivers/usb/gadget/composite.c                     |    2 +-
 drivers/usb/gadget/configfs.c                      |   10 +-
 drivers/usb/gadget/configfs.h                      |    6 +
 drivers/usb/gadget/dummy_hcd.c                     |    6 +-
 drivers/usb/gadget/f_mass_storage.c                | 1254 ++++++++++++++-----
 drivers/usb/gadget/f_mass_storage.h                |  166 +++
 drivers/usb/gadget/g_ffs.c                         |    2 +
 drivers/usb/gadget/goku_udc.c                      |    3 +-
 drivers/usb/gadget/mass_storage.c                  |  125 +-
 drivers/usb/gadget/multi.c                         |  247 +++-
 drivers/usb/gadget/mv_u3d_core.c                   |    4 +-
 drivers/usb/gadget/net2280.c                       |    5 +-
 drivers/usb/gadget/pch_udc.c                       |    1 -
 drivers/usb/gadget/rndis.c                         |    2 +-
 drivers/usb/gadget/s3c-hsotg.c                     |  167 ++-
 drivers/usb/gadget/storage_common.c                |  430 ++-----
 drivers/usb/gadget/storage_common.h                |  229 ++++
 drivers/usb/gadget/tcm_usb_gadget.c                |    4 +-
 drivers/usb/gadget/udc-core.c                      |    3 +-
 drivers/usb/gadget/zero.c                          |   25 +-
 drivers/usb/host/Kconfig                           |   59 +-
 drivers/usb/host/Makefile                          |   11 +-
 drivers/usb/host/ehci-atmel.c                      |   16 +-
 drivers/usb/host/ehci-dbg.c                        |  113 +-
 drivers/usb/host/{ehci-s5p.c => ehci-exynos.c}     |  164 ++-
 drivers/usb/host/ehci-fsl.c                        |    4 +-
 drivers/usb/host/ehci-grlib.c                      |    2 +-
 drivers/usb/host/ehci-hcd.c                        |   42 +-
 drivers/usb/host/ehci-mem.c                        |    4 +-
 drivers/usb/host/ehci-msm.c                        |   20 +-
 drivers/usb/host/ehci-mv.c                         |    2 +-
 drivers/usb/host/ehci-octeon.c                     |    2 +-
 drivers/usb/host/ehci-pci.c                        |   24 +-
 drivers/usb/host/ehci-pmcmsp.c                     |    2 +-
 drivers/usb/host/ehci-ppc-of.c                     |    2 +-
 drivers/usb/host/ehci-ps3.c                        |    2 +-
 drivers/usb/host/ehci-q.c                          |   64 +-
 drivers/usb/host/ehci-sched.c                      | 1033 +++++++++-------
 drivers/usb/host/ehci-sead3.c                      |    2 +-
 drivers/usb/host/ehci-sh.c                         |    2 +-
 drivers/usb/host/ehci-sysfs.c                      |   15 +-
 drivers/usb/host/ehci-tegra.c                      |    4 +-
 drivers/usb/host/ehci-tilegx.c                     |    2 +-
 drivers/usb/host/ehci-w90x900.c                    |   89 +-
 drivers/usb/host/ehci-xilinx-of.c                  |    2 +-
 drivers/usb/host/ehci.h                            |   81 +-
 drivers/usb/host/fotg210-hcd.c                     |    2 +-
 drivers/usb/host/fusbh200-hcd.c                    |    2 +-
 drivers/usb/host/hwa-hc.c                          |   33 +-
 drivers/usb/host/isp1362-hcd.c                     |    2 +-
 drivers/usb/host/ohci-at91.c                       |  156 ++-
 drivers/usb/host/ohci-dbg.c                        |    2 +-
 drivers/usb/host/ohci-ep93xx.c                     |  184 ---
 drivers/usb/host/ohci-exynos.c                     |  184 ++-
 drivers/usb/host/ohci-hcd.c                        |  159 +--
 drivers/usb/host/ohci-hub.c                        |    9 +-
 drivers/usb/host/ohci-nxp.c                        |  123 +-
 drivers/usb/host/ohci-omap.c                       |  169 +--
 drivers/usb/host/ohci-omap3.c                      |  118 +-
 drivers/usb/host/ohci-pci.c                        |   15 +-
 drivers/usb/host/ohci-platform.c                   |   11 +-
 drivers/usb/host/ohci-pxa27x.c                     |  249 ++--
 drivers/usb/host/ohci-s3c2410.c                    |  128 +-
 drivers/usb/host/ohci-sm501.c                      |   11 +-
 drivers/usb/host/ohci-spear.c                      |  140 +--
 drivers/usb/host/pci-quirks.c                      |  137 ++-
 drivers/usb/host/pci-quirks.h                      |    2 +
 drivers/usb/host/sl811-hcd.c                       |    4 +-
 drivers/usb/host/uhci-debug.c                      |   16 +-
 drivers/usb/host/uhci-hub.c                        |   40 +-
 drivers/usb/host/uhci-pci.c                        |   19 +-
 drivers/usb/host/uhci-platform.c                   |    3 +-
 drivers/usb/host/whci/hcd.c                        |    4 +-
 drivers/usb/host/xhci-hub.c                        |    5 +-
 drivers/usb/host/xhci-mem.c                        |   10 -
 drivers/usb/host/xhci-ring.c                       |  324 ++---
 drivers/usb/host/xhci.c                            |  182 +--
 drivers/usb/host/xhci.h                            |    3 +-
 drivers/usb/misc/usbtest.c                         |  172 ++-
 drivers/usb/musb/Kconfig                           |    5 +-
 drivers/usb/musb/am35x.c                           |   63 +-
 drivers/usb/musb/blackfin.c                        |   13 +-
 drivers/usb/musb/da8xx.c                           |   49 +-
 drivers/usb/musb/davinci.c                         |   59 +-
 drivers/usb/musb/musb_am335x.c                     |    2 +-
 drivers/usb/musb/musb_core.c                       |   19 +-
 drivers/usb/musb/musb_core.h                       |    2 +
 drivers/usb/musb/musb_cppi41.c                     |    8 +-
 drivers/usb/musb/musb_dsps.c                       |   96 +-
 drivers/usb/musb/musb_gadget.c                     |    2 +-
 drivers/usb/musb/musb_host.c                       |    2 +-
 drivers/usb/musb/musb_virthub.c                    |   19 +-
 drivers/usb/musb/omap2430.c                        |   54 +-
 drivers/usb/musb/tusb6010.c                        |   49 +-
 drivers/usb/musb/ux500.c                           |   13 +-
 drivers/usb/phy/Kconfig                            |   35 +-
 drivers/usb/phy/Makefile                           |    3 +-
 drivers/usb/phy/phy-am335x-control.c               |   44 +-
 drivers/usb/phy/phy-am335x.c                       |   44 +-
 drivers/usb/phy/phy-fsl-usb.c                      |   96 +-
 drivers/usb/phy/phy-fsl-usb.h                      |    4 +-
 drivers/usb/phy/phy-fsm-usb.c                      |   72 +-
 drivers/usb/phy/phy-fsm-usb.h                      |  179 ++-
 drivers/usb/phy/phy-generic.c                      |  108 +-
 drivers/usb/phy/phy-generic.h                      |    7 +-
 drivers/usb/phy/phy-omap-control.c                 |  208 ++--
 drivers/usb/phy/phy-omap-usb3.c                    |   32 +-
 drivers/usb/phy/phy-rcar-gen2-usb.c                |  248 ++++
 drivers/usb/phy/phy-samsung-usb2.c                 |    3 +-
 drivers/usb/phy/phy-samsung-usb3.c                 |    3 +-
 drivers/usb/phy/phy-tegra-usb.c                    |    2 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |    1 +
 drivers/usb/phy/phy-ulpi-viewport.c                |    2 +-
 drivers/usb/phy/phy.c                              |    2 +-
 drivers/usb/serial/cyberjack.c                     |    2 +-
 drivers/usb/serial/ftdi_sio.c                      |   10 +-
 drivers/usb/serial/generic.c                       |   82 +-
 drivers/usb/serial/mos7840.c                       |    4 +
 drivers/usb/serial/option.c                        |   17 +
 drivers/usb/wusbcore/cbaf.c                        |    7 +-
 drivers/usb/wusbcore/devconnect.c                  |    2 +-
 drivers/usb/wusbcore/wa-hc.c                       |   18 +-
 drivers/usb/wusbcore/wa-hc.h                       |   42 +-
 drivers/usb/wusbcore/wa-rpipe.c                    |   22 +-
 drivers/usb/wusbcore/wa-xfer.c                     | 1261 +++++++++++++++-----
 drivers/uwb/lc-dev.c                               |   16 +-
 drivers/video/exynos/Kconfig                       |    3 +-
 drivers/video/exynos/exynos_dp_core.c              |  132 +-
 drivers/video/exynos/exynos_dp_core.h              |  110 ++
 drivers/video/exynos/exynos_dp_reg.c               |    2 -
 drivers/video/exynos/exynos_mipi_dsi.c             |   19 +-
 include/linux/i2c/twl.h                            |    2 +
 include/linux/phy/phy.h                            |  270 +++++
 include/linux/platform_data/mipi-csis.h            |    9 -
 include/linux/platform_data/usb-ehci-s5p.h         |   21 -
 include/linux/platform_data/usb-ohci-exynos.h      |   21 -
 include/linux/platform_data/usb-rcar-gen2-phy.h    |   22 +
 include/linux/printk.h                             |   16 +-
 include/linux/usb.h                                |   10 +-
 include/linux/usb/hcd.h                            |   16 +-
 include/linux/usb/intel_mid_otg.h                  |  180 ---
 include/linux/usb/musb.h                           |    2 -
 include/linux/usb/omap_control_usb.h               |   33 +-
 include/linux/usb/serial.h                         |    2 +
 include/linux/usb/usb_phy_gen_xceiv.h              |    3 +-
 include/linux/usb/wusb-wa.h                        |   51 +-
 include/video/exynos_dp.h                          |  131 --
 include/video/exynos_mipi_dsim.h                   |    5 +-
 217 files changed, 9035 insertions(+), 5000 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-mass-storage
 create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/msm-hsusb.txt
 create mode 100644 Documentation/phy.txt
 delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c
 create mode 100644 drivers/phy/Kconfig
 create mode 100644 drivers/phy/Makefile
 create mode 100644 drivers/phy/phy-core.c
 create mode 100644 drivers/phy/phy-exynos-dp-video.c
 create mode 100644 drivers/phy/phy-exynos-mipi-video.c
 rename drivers/{usb => }/phy/phy-omap-usb2.c (81%)
 rename drivers/{usb => }/phy/phy-twl4030-usb.c (94%)
 create mode 100644 drivers/usb/gadget/configfs.h
 create mode 100644 drivers/usb/gadget/f_mass_storage.h
 create mode 100644 drivers/usb/gadget/storage_common.h
 rename drivers/usb/host/{ehci-s5p.c => ehci-exynos.c} (55%)
 delete mode 100644 drivers/usb/host/ohci-ep93xx.c
 create mode 100644 drivers/usb/phy/phy-rcar-gen2-usb.c
 create mode 100644 include/linux/phy/phy.h
 delete mode 100644 include/linux/platform_data/usb-ehci-s5p.h
 delete mode 100644 include/linux/platform_data/usb-ohci-exynos.h
 create mode 100644 include/linux/platform_data/usb-rcar-gen2-phy.h
 delete mode 100644 include/linux/usb/intel_mid_otg.h
 delete mode 100644 include/video/exynos_dp.h
