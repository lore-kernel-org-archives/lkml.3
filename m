Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3GARQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:16:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3GARQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:16:53 -0400
Date: Mon, 1 Jul 2013 10:16:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.11-rc1
Message-ID: <20130701171652.GA25575@kroah.com>
References: <20130614163851.GA25973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.11-rc1

for you to fetch changes up to 3a0ddc714a1b8fcbff24c135a1332a28b4668d78:

  usb: musb: omap2430: make it compile again (2013-06-25 16:41:07 -0700)

----------------------------------------------------------------
USB 3.11-rc1 merge

Here's the big USB 3.11-rc1 merge request.

Lots of gadget and finally, chipidea driver updates (they were much
needed), along with a new host controller driver, lots of little serial
driver fixes, the removal of the 255 usb-serial device limitation, and a
variety of other minor things.

All of these have been in the linux-next releases for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (3):
      USB: MUSB: upgrade the isochronous API
      USB: IMX21: upgrade the isochronous API
      USB: FHCI: upgrade the isochronous API

Alex Shi (1):
      usb/xhci: unify parameter of xhci_msi_irq

Alexander Shishkin (2):
      usb: chipidea: get rid of camelcase names
      usb: chipidea: drop "13xxx" infix

Alexandre Peixoto Ferreira (5):
      USB: usbtmc: Add flag rigol_quirk to usbtmc_device_data
      USB: usbtmc: TMC request code segregated from usbtmc_read
      USB: usbtmc: Set rigol_quirk if device is listed
      USB: usbtmc: usbtmc_read sends multiple TMC header based on rigol_quirk
      USB: usbtmc: Change magic number to constant

Alexey Khoroshilov (2):
      USB: fix PTR_ERR translation in init_usb_class()
      usb: gadget: r8a66597-udc: do not unlock unheld spinlock in r8a66597_sudmac_irq()

Andrzej Pietrasiewicz (43):
      usb: gadget: u_ether: convert into module
      usb: gadget: rndis: convert into module
      usb: gadget: u_ether: construct with default values and add setters/getters
      usb: gadget: f_ncm: convert to new function interface with backward compatibility
      usb: gadget: ncm: convert to new function interface
      usb: gadget: f_ncm: remove compatibility layer
      usb: gadget: f_ncm: use usb_gstrings_attach
      usb: gadget: f_ncm: add configfs support
      usb: gadget: add helpers for configfs support for USB Ethernet
      usb: gadget: f_ecm: convert to new function interface with backward compatibility
      usb: gadget: cdc2: convert to new interface of f_ecm
      usb: gadget: f_ecm: use usb_gstrings_attach
      usb: gadget: f_ecm: add configfs support
      usb: gadget: f_obex: use usb_gstrings_attach
      usb: gadget: nokia: convert to new interface of f_obex
      usb: gadget: f_obex: remove compatibility layer
      usb: gadget: phonet: move global dev variable to its user
      usb: gadget: f_phonet: convert to new function interface with backward compatibility
      usb: gadget: nokia: convert to new interface of f_phonet
      usb: gadget: f_phonet: remove compatibility layer
      usb: gadget: nokia: convert to new interface of f_ecm
      usb: gadget: f_phonet: add configfs support
      usb: gadget: u_ether: allow getting binary-form host address
      usb: gadget: ether: convert to new interface of f_ecm
      usb: gadget: f_eem: convert to new function interface with backward compatibility
      usb: gadget: ether: convert to new interface of f_eem
      usb: gadget: f_eem: remove compatibility layer
      usb: gadget: f_eem: use usb_gstrings_attach
      usb: gadget: f_eem: add configfs support
      usb: gadget: multi: Remove unused include
      usb: gadget: f_subset: convert to new function interface with backward compatibility
      usb: gadget: ether: convert to new interface of f_subset
      usb: gadget: f_subset: use usb_gstrings_attach
      usb: gadget: f_subset: add configfs support
      usb: gadget: f_rndis: convert to new function interface with backward compatibility
      usb: gadget: ether: convert to new interface of f_rndis
      usb: gadget: rndis: init & exit rndis at module load/unload
      usb: gadget: f_rndis: use usb_gstrings_attach
      usb: gadget: f_rndis: add configfs support
      usb: gadget: f_mass_storage: fix default product name
      usb/gadget: Kconfig: fix separate building of configfs-enabled functions
      Documentation/usb: gadget_configfs
      Documentation/ABI/testing: configfs-based usb gadgets

Andy Shevchenko (4):
      usb: serial: dump small buffers with help of %*ph
      uwb: use %*ph specifier to dump buffer
      usb: chipidea: remove superfluous pci_set_drvdata(pci, NULL)
      usb: chipidea: move to pcim_* functions

Arnaud Patard (1):
      usbmisc_imx: allow autoloading on according to dt ids

Arnd Bergmann (2):
      USB: OHCI: remove bogus #error
      usb: host: make USB_ARCH_HAS_?HCI obsolete

Boris BREZILLON (2):
      USB: ohci-at91: prepare clk before calling enable
      ehci-atmel.c: prepare clk before calling enable

Dan Williams (1):
      USB: option,qcserial: move Novatel Gobi1K IDs to qcserial

Daniel Mack (11):
      usb: gadget: drop unused USB_GADGET_MUSB_HDRC
      usb: musb: move function declarations to musb_{host,gadget}.h
      usb: musb: factor some host-specific functions
      usb: musb: gadget: remove hcd initialization
      usb: musb: move musb_start to musb_virthub.c
      usb: musb: factor out hcd initalization
      usb: musb: add Kconfig options for HOST, GAGDET or DUAL_ROLE modes
      usb: musb: add musb_host_setup() and musb_host_cleanup()
      usb: musb: re-introduce musb->port_mode
      usb: musb: use musb->port_mode
      usb: musb: eliminate musb_to_hcd

Dongjin Kim (3):
      usb: phy: samsung: Add support HSIC on Exynos4X12
      usb: misc: usb3503: Add to select the ports to disable
      usb: misc: usb3503: Adding device tree entry 'disabled-ports'

Emil Goode (2):
      USB: EHCI: Remove double assignment of .start in ehci_msp_hc_driver
      xhci: Add missing unlocks on error paths

Emilio López (2):
      usb: storage: sddr09: initialize variables directly
      usb: storage: alauda: initialize variables directly

Fabio Baltieri (7):
      usb: musb: various cosmetic fixes on ux500 files
      usb: phy: ab8500-usb: fix phy tuning value select logic
      usb: phy: ab8500-usb: add platform_device_id table
      usb: phy: ab8500-usb: move phy tuning values on separate functions
      usb: phy: ab8500-usb: add flag bits to control driver features
      usb: phy: ab8500-usb: add ab8540 support
      usb: phy: ab8500-usb: add ab9540 support

Fabio Estevam (7):
      usb: chipidea: ci13xxx_imx: let device core handle pinctrl
      usb: chipidea: usbmisc_imx: Staticize usbmisc_imx_drv_init/exit
      usb: chipidea: ci13xxx_imx: fix error path
      usb: chipidea: ci13xxx_imx: remove reg_vbus
      usb: chipidea: ci13xxx_imx: check if 'data->phy_np' is not NULL
      usb: chipidea: ci13xxx_imx: remove 'phy_np'
      usb: chipidea: ci_hdrc_imx: access phy via private data

Felipe Balbi (4):
      usb: musb: fix incorrect usage of resource pointer
      usb: musb: remove 'ignore_disconnect' flag
      Merge tag 'tegra-for-3.11-deps-for-usb' into next
      usb: musb: host: fix build warning

George Cherian (4):
      usb: dwc3: omap: Adding am437x specific register map changes
      usb: dwc3: omap: initialize the register offset values for omap5 and AM437x
      usb: dwc3: omap: Adds dwc3_omap_readl/writel wrappers
      usb: host: xhci-plat: release mem region while removing module

Greg Kroah-Hartman (11):
      Merge 3.10-rc3 into usb-next
      Merge tag 'for-usb-next-2013-06-06' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge 3.10-rc5 into usb-next
      USB: serial: ports: add minor and port number
      Merge tag 'usb-for-v3.11' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge 3.10-rc6 into usb-next
      USB: serial: make minor allocation dynamic
      USB: serial: increase the number of devices we support
      USB: cdc-acm: remove unneeded spin_lock_irqsave/restore on write path
      Merge tag 'for-usb-next-2013-06-17' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge 3.10-rc7 into usb-next

Jassi Brar (1):
      USB: gadget: f_uac2: Fix broken prm to uac2 mapping

Jingoo Han (13):
      USB: ehci-mv: remove unnecessary platform_set_drvdata()
      USB: ehci-mxc: remove unnecessary platform_set_drvdata()
      USB: ehci-octeon: remove unnecessary platform_set_drvdata()
      USB: ehci-sead3: remove unnecessary platform_set_drvdata()
      USB: ehci-sh: remove unnecessary platform_set_drvdata()
      USB: ehci-platform: remove unnecessary platform_set_drvdata()
      USB: ohci-jz4740: remove unnecessary platform_set_drvdata()
      USB: ohci-pxa27x: remove unnecessary platform_set_drvdata()
      USB: ohci-sm501: remove unnecessary platform_set_drvdata()
      USB: ohci-spear: remove unnecessary platform_set_drvdata()
      USB: ohci-platform: remove unnecessary platform_set_drvdata()
      usb: gadget: use platform_{get,set}_drvdata()
      USB: host: use platform_{get,set}_drvdata()

Julius Werner (4):
      usb: ehci: Only sleep for post-resume handover if devices use persist
      usb: misc: usb3503: Fix up whitespace
      usb: misc: usb3503: Remove 100ms sleep on reset, conform to data sheet
      usb: xhci-dbg: Display endpoint number and direction in context dump

Kishon Vijay Abraham I (1):
      usb: dwc3: omap: improve error handling of dwc3_omap_probe

Laurent Pinchart (1):
      usb: gadget: uvc: Remove unneeded endpoint descriptor fields initialization

Libo Chen (1):
      usb: fsl: add missing platform_driver owner

Lisa Nguyen (6):
      usb: misc: Replaced deprecated preprocessor in adutux.c
      usb: misc: Removed space before tabs in adutux.c
      usb: misc: Reformatted pointer variables in adutux.c
      usb: misc: Added space after comma in adutux.c
      usb: misc: Added space after closing brace in adutux.c
      usb: misc: Fixed assignment error in if statement

Luca Olivetti (1):
      USB: serial: pl2303 works at 500kbps

Manjunath Goudar (8):
      USB: OHCI: prepare to make ohci-hcd a library module
      USB: OHCI: Generic changes to make ohci-pci a separate driver
      USB: OHCI: make ohci-pci a separate driver
      USB: OHCI: make ohci-platform a separate driver
      USB: OHCI: add a name for the platform-private field
      usb: phy: export ulpi_viewport_access_ops
      USB: EHCI: export ehci_handshake for ehci-hcd sub-drivers
      USB: EHCI: make ehci-tegra a separate driver

Mathias Nyman (8):
      usb: xhci: check usb2 port capabilities before adding hw link PM support
      usb: xhci: define port register names and use them instead of magic numbers
      usb: xhci: add USB2 Link power management BESL support
      usb: add usb2 Link PM variables to sysfs and usb_device
      xhci: Remove BUG in xhci_setup_addressable_virt_dev
      xhci: remove BUG() in xhci_get_endpoint_type()
      xhci: check for failed dma pool allocation
      usb: check usb_hub_to_struct_hub() return value

Mian Yousaf Kaukab (2):
      usb: musb: enable ux500 host side dma support
      usb: phy: ab8500-usb: add transceiver clock control

Michael Grzeschik (7):
      usb: gadget: uvc: Implement videobuf2 .wait_prepare and .wait_finish operations
      usb: chipidea: udc: configure iso endpoints
      usb: chipidea: udc: manage dynamic amount of tds with a linked list
      usb: chipidea: udc: add multiple td support to hardware_{en,de}queue
      usb: add devicetree helpers for determining dr_mode and phy_type
      usb: chipidea: add PTW, PTS and STS handling
      usb: chipidea: ci13xxx-imx: move static pdata into probe function

Peter Chen (2):
      usb: chipidea: improve kconfig
      usb: fix build error without CONFIG_USB_PHY

Peter Huewe (1):
      uwb/whci: Use module_pci_driver to register driver

Philipp Zabel (1):
      usb: chipidea: usbmisc: use module_platform_driver

Roger Quadros (1):
      USB: ehci-omap: Tweak PHY initialization sequence

Ruchika Kharwar (1):
      usb: phy: omap-usb3: updated dpll M,N values to support DRA7xx devices

Sachin Kamat (27):
      USB: quatech2: Staticize local symbol
      usb: chipidea: ci13xxx_imx: Remove redundant platform_set_drvdata()
      usb: gadget: mv_u3d_core: Remove redundant platform_set_drvdata()
      usb: gadget: pxa27x_udc: Remove redundant platform_set_drvdata()
      usb: host: ehci-tilegx: Remove redundant platform_set_drvdata()
      usb: host: ohci-da8xx: Remove redundant platform_set_drvdata()
      usb: host: ohci-nxp: Remove redundant platform_set_drvdata()
      usb: host: ohci-octeon: Remove redundant platform_set_drvdata()
      usb: host: ohci-omap: Remove redundant platform_set_drvdata()
      usb: host: ohci-tilegx: Remove redundant platform_set_drvdata()
      usb: host: ohci-tmio: Remove redundant platform_set_drvdata()
      usb: host: oxu210hp-hcd: Remove redundant platform_set_drvdata()
      usb: host: uhci-platform: Remove redundant platform_set_drvdata()
      usb: host: fusbh200-hcd: Remove redundant platform_set_drvdata()
      usb: host: fusbh200-hcd: Staticize local symbols
      usb: host: ehci-omap: Remove redundant use of of_match_ptr
      usb: host: ehci-platform: Remove redundant use of of_match_ptr
      usb: host: ehci-spear: Remove redundant use of of_match_ptr
      usb: host: ehci-orion: Remove redundant use of of_match_ptr
      usb: host: ohci-omap3: Remove redundant use of of_match_ptr
      usb: host: ohci-spear: Remove redundant use of of_match_ptr
      usb: host: uhci-platform: Remove redundant use of of_match_ptr
      usb: phy: phy-nop: Remove redundant use of of_match_ptr
      usb: gadget: mv_u3d_core: Remove redundant platform_set_drvdata()
      usb: gadget: pxa27x_udc: Remove redundant platform_set_drvdata()
      usb: phy: phy-nop: Remove redundant use of of_match_ptr
      usb: host: ehci-spear: Remove redundant checks

Sakethram Bommisetti (1):
      usb: phy: ab8500-usb: restart phy during probe

Sarah Sharp (2):
      xhci: Remove BUG_ON() in xhci_alloc_container_ctx.
      xhci: Remove BUG_ON in xhci_get_input_control_ctx.

Sascha Hauer (2):
      usb: chipidea: introduce dual role mode pdata flags
      usb: chipidea: i.MX: use devm_usb_get_phy_by_phandle to get phy

Sebastian Andrzej Siewior (1):
      usb: musb: omap2430: make it compile again

Stephen Warren (4):
      usb: phy: add MODULE_LICENSE to phy-tegra-usb.c
      USB: EHCI: tegra: remove all power management
      USB: EHCI: tegra: fix circular module dependencies
      USB: EHCI: tegra: make use of ehci->priv

Thierry Reding (1):
      USB: EHCI: tegra: Fix oops in error cleanup

Thomas Abraham (1):
      usb: ehci-s5p: skip phy setup for Exynos5440 based platforms

Thomas Pugliese (11):
      Allow the USB HCD to create Wireless USB root hubs
      wusbcore: reduce keepalive threshold from timeout/2 to timeout/3
      wusbhc: disable suspend and resume on the root hub.
      USB: wusbcore: add HWA-specific fields to usb_rpipe_descriptor
      UWB: HWA: add support for Alereon 5310 and 5611 devices
      wusbcore wire adapter: ignore HWA_NOTIF_BPST_ADJ notifications
      usb: wire adapter: add scatter gather support
      wusbcore: add sysfs attribute for DNTS count and interval
      wusbcore: add sysfs attribute for retry count
      wusbcore: add entries in Documentation/ABI for new wusbhc sysfs attributes
      USB: HWA: fix device probe failure

Tomasz Figa (6):
      usb: phy: samsung: Select common driver part implicitly
      usb: phy: samsung: Use clk_get to get reference clock
      usb: phy: samsung: Consolidate reference clock rate handling
      usb: phy: samsung: Pass set_isolation callback through driver data
      usb: phy: samsung: Pass enable/disable callbacks through driver data
      usb: phy: samsung: Add support for USB 2.0 PHY on Exynos 4x12

Tushar Behera (1):
      usb: phy: rcar-usb: Fix comment w.r.t. devm_ioremap_resource

Tülin İzer (5):
      usb: devio: Fixed warning: 'use <linux/uacces.h> instead <asm/uacces.h>'
      usb: devio: Fixed macro parenthesis error
      usb: devio: Fixed error: 'do not use assignment in if condition'
      usb: message: Fixed error: 'no space before bracket'
      usb: message: Fixed parenthesis error in sizeof function.

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed

Venu Byravarasu (8):
      ARM: tegra: finalize USB EHCI and PHY bindings
      ARM: tegra: modify ULPI reset GPIO properties
      ARM: tegra: update device trees for USB binding rework
      usb: phy: tegra: Return correct error value provided by clk_get_sys
      usb: phy: tegra: Get PHY mode using DT
      usb: phy: tegra: get ULPI reset GPIO info using DT.
      usb: phy: tegra: Add error handling & clean up.
      usb: phy: registering Tegra USB PHY as platform driver

Wei Shuai (1):
      USB: serial: add support Infineon modem USB flashloader driver

Wei Yongjun (6):
      usb: fusbh200-hcd: fix error handling in fusbh200_hcd_fusbh200_probe()
      usb: fusbh200-hcd: convert list_for_each to entry variant
      usb: gadget: f_ecm: fix missing unlock on error in ecm_alloc()
      usb: gadget: f_ncm: fix missing unlock on error in ncm_alloc()
      usb: gadget: f_subset: fix missing unlock on error in geth_alloc()
      usb: phy: tegra: remove duplicated include from phy-tegra-usb.c

Wolfram Sang (2):
      drivers/usb/host: don't check resource with devm_ioremap_resource
      drivers/usb/host: remove leftover release_mem_region

Yijing Wang (2):
      usb: dwc3: remove redundant D0 power state set
      usb, chipidea: remove redundant D0 power state set

Yuan-Hsin Chen (3):
      usb host: Faraday USB2.0 FUSBH200-HCD driver
      usb: host: fusbh200-hcd: rename two functions
      usb: gadget: add Faraday fotg210_udc driver

tpugliese (1):
      usb: uwb: use correct locking calls for rc data

 Documentation/ABI/testing/configfs-usb-gadget      |   81 +
 Documentation/ABI/testing/configfs-usb-gadget-acm  |    8 +
 Documentation/ABI/testing/configfs-usb-gadget-ecm  |   16 +
 Documentation/ABI/testing/configfs-usb-gadget-eem  |   14 +
 Documentation/ABI/testing/configfs-usb-gadget-ncm  |   15 +
 Documentation/ABI/testing/configfs-usb-gadget-obex |    9 +
 .../ABI/testing/configfs-usb-gadget-phonet         |    8 +
 .../ABI/testing/configfs-usb-gadget-rndis          |   14 +
 .../ABI/testing/configfs-usb-gadget-serial         |    9 +
 .../ABI/testing/configfs-usb-gadget-subset         |   14 +
 Documentation/ABI/testing/sysfs-bus-usb            |   27 +
 .../ABI/testing/sysfs-class-uwb_rc-wusbhc          |   19 +
 .../devicetree/bindings/usb/ci13xxx-imx.txt        |    6 +
 .../bindings/usb/nvidia,tegra20-ehci.txt           |   27 +-
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   41 +-
 Documentation/devicetree/bindings/usb/usb3503.txt  |    5 +
 Documentation/usb/gadget_configfs.txt              |  384 ++
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |    6 +-
 arch/arm/boot/dts/tegra20-harmony.dts              |   15 +-
 arch/arm/boot/dts/tegra20-iris-512.dts             |    9 +-
 arch/arm/boot/dts/tegra20-paz00.dts                |   15 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |   26 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |    4 +
 arch/arm/boot/dts/tegra20-trimslice.dts            |   25 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |   15 +-
 arch/arm/boot/dts/tegra20-whistler.dts             |   28 +
 arch/arm/boot/dts/tegra20.dtsi                     |   49 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   36 +-
 drivers/usb/Kconfig                                |   69 +-
 drivers/usb/Makefile                               |    1 +
 drivers/usb/chipidea/Kconfig                       |    6 +-
 drivers/usb/chipidea/Makefile                      |    6 +-
 drivers/usb/chipidea/bits.h                        |   16 +-
 drivers/usb/chipidea/ci.h                          |   51 +-
 .../usb/chipidea/{ci13xxx_imx.c => ci_hdrc_imx.c}  |  117 +-
 .../usb/chipidea/{ci13xxx_imx.h => ci_hdrc_imx.h}  |    0
 .../usb/chipidea/{ci13xxx_msm.c => ci_hdrc_msm.c}  |   49 +-
 .../usb/chipidea/{ci13xxx_pci.c => ci_hdrc_pci.c}  |   61 +-
 drivers/usb/chipidea/core.c                        |  109 +-
 drivers/usb/chipidea/debug.c                       |   61 +-
 drivers/usb/chipidea/debug.h                       |    8 +-
 drivers/usb/chipidea/host.c                        |   10 +-
 drivers/usb/chipidea/host.h                        |    4 +-
 drivers/usb/chipidea/udc.c                         |  785 +--
 drivers/usb/chipidea/udc.h                         |   26 +-
 drivers/usb/chipidea/usbmisc_imx.c                 |   15 +-
 drivers/usb/class/cdc-acm.c                        |   52 +-
 drivers/usb/class/usbtmc.c                         |  273 +-
 drivers/usb/core/devio.c                           |    7 +-
 drivers/usb/core/file.c                            |    2 +-
 drivers/usb/core/hcd.c                             |   28 +
 drivers/usb/core/hub.c                             |   23 +-
 drivers/usb/core/hub.h                             |    2 +-
 drivers/usb/core/message.c                         |   16 +-
 drivers/usb/core/port.c                            |    4 +-
 drivers/usb/core/sysfs.c                           |   54 +
 drivers/usb/core/usb.c                             |   33 +
 drivers/usb/dwc3/dwc3-omap.c                       |  251 +-
 drivers/usb/dwc3/dwc3-pci.c                        |    1 -
 drivers/usb/gadget/Kconfig                         |  176 +-
 drivers/usb/gadget/Makefile                        |   16 +
 drivers/usb/gadget/cdc2.c                          |   85 +-
 drivers/usb/gadget/ether.c                         |  180 +-
 drivers/usb/gadget/f_ecm.c                         |  197 +-
 drivers/usb/gadget/f_eem.c                         |  195 +-
 drivers/usb/gadget/f_mass_storage.c                |    6 +-
 drivers/usb/gadget/f_ncm.c                         |  220 +-
 drivers/usb/gadget/f_obex.c                        |   75 +-
 drivers/usb/gadget/f_phonet.c                      |  177 +-
 drivers/usb/gadget/f_rndis.c                       |  245 +-
 drivers/usb/gadget/f_subset.c                      |  181 +-
 drivers/usb/gadget/f_uac2.c                        |   20 +-
 drivers/usb/gadget/f_uvc.c                         |   13 +-
 drivers/usb/gadget/fotg210-udc.c                   | 1219 ++++
 drivers/usb/gadget/fotg210.h                       |  253 +
 drivers/usb/gadget/fsl_qe_udc.c                    |    4 +-
 drivers/usb/gadget/fusb300_udc.c                   |    4 +-
 drivers/usb/gadget/g_ffs.c                         |   18 +-
 drivers/usb/gadget/m66592-udc.c                    |    4 +-
 drivers/usb/gadget/multi.c                         |   18 +-
 drivers/usb/gadget/mv_u3d_core.c                   |    5 +-
 drivers/usb/gadget/ncm.c                           |   58 +-
 drivers/usb/gadget/nokia.c                         |  235 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    1 -
 drivers/usb/gadget/r8a66597-udc.c                  |    8 +-
 drivers/usb/gadget/rndis.c                         |   18 +
 drivers/usb/gadget/rndis.h                         |    4 +-
 drivers/usb/gadget/u_ecm.h                         |   36 +
 drivers/usb/gadget/u_eem.h                         |   36 +
 drivers/usb/gadget/u_ether.c                       |  232 +-
 drivers/usb/gadget/u_ether.h                       |  166 +-
 drivers/usb/gadget/u_ether_configfs.h              |  164 +
 drivers/usb/gadget/u_gether.h                      |   36 +
 drivers/usb/gadget/u_ncm.h                         |   36 +
 drivers/usb/gadget/u_phonet.h                      |   14 +-
 drivers/usb/gadget/u_rndis.h                       |   41 +
 drivers/usb/gadget/uvc_queue.c                     |   16 +
 drivers/usb/host/Kconfig                           |   24 +-
 drivers/usb/host/Makefile                          |    6 +
 drivers/usb/host/ehci-atmel.c                      |    8 +-
 drivers/usb/host/ehci-fsl.c                        |    1 +
 drivers/usb/host/ehci-grlib.c                      |    6 +-
 drivers/usb/host/ehci-hcd.c                        |   22 +-
 drivers/usb/host/ehci-hub.c                        |   20 +-
 drivers/usb/host/ehci-mv.c                         |   16 +-
 drivers/usb/host/ehci-mxc.c                        |    1 -
 drivers/usb/host/ehci-octeon.c                     |    2 -
 drivers/usb/host/ehci-omap.c                       |   13 +-
 drivers/usb/host/ehci-orion.c                      |    2 +-
 drivers/usb/host/ehci-platform.c                   |    3 +-
 drivers/usb/host/ehci-pmcmsp.c                     |    3 +-
 drivers/usb/host/ehci-ppc-of.c                     |    6 +-
 drivers/usb/host/ehci-s5p.c                        |   12 +
 drivers/usb/host/ehci-sead3.c                      |    1 -
 drivers/usb/host/ehci-sh.c                         |    1 -
 drivers/usb/host/ehci-spear.c                      |    6 +-
 drivers/usb/host/ehci-tegra.c                      |  515 +-
 drivers/usb/host/ehci-tilegx.c                     |    1 -
 drivers/usb/host/ehci-xilinx-of.c                  |    5 +-
 drivers/usb/host/ehci.h                            |    2 +
 drivers/usb/host/fhci-sched.c                      |    8 +-
 drivers/usb/host/fhci.h                            |    2 +-
 drivers/usb/host/fusbh200-hcd.c                    | 5972 ++++++++++++++++++++
 drivers/usb/host/fusbh200.h                        |  743 +++
 drivers/usb/host/hwa-hc.c                          |   16 +-
 drivers/usb/host/imx21-hcd.c                       |   43 +-
 drivers/usb/host/isp1760-if.c                      |   10 +-
 drivers/usb/host/ohci-at91.c                       |   12 +-
 drivers/usb/host/ohci-da8xx.c                      |    1 -
 drivers/usb/host/ohci-hcd.c                        |  156 +-
 drivers/usb/host/ohci-hub.c                        |    1 -
 drivers/usb/host/ohci-jz4740.c                     |    3 -
 drivers/usb/host/ohci-nxp.c                        |    3 -
 drivers/usb/host/ohci-octeon.c                     |    2 -
 drivers/usb/host/ohci-omap.c                       |    1 -
 drivers/usb/host/ohci-omap3.c                      |    2 +-
 drivers/usb/host/ohci-pci.c                        |  151 +-
 drivers/usb/host/ohci-platform.c                   |   89 +-
 drivers/usb/host/ohci-ppc-of.c                     |    5 +-
 drivers/usb/host/ohci-pxa27x.c                     |    1 -
 drivers/usb/host/ohci-q.c                          |    6 +-
 drivers/usb/host/ohci-sm501.c                      |    1 -
 drivers/usb/host/ohci-spear.c                      |    4 +-
 drivers/usb/host/ohci-tilegx.c                     |    1 -
 drivers/usb/host/ohci-tmio.c                       |    2 -
 drivers/usb/host/ohci.h                            |   20 +
 drivers/usb/host/oxu210hp-hcd.c                    |    2 -
 drivers/usb/host/pci-quirks.c                      |   13 +
 drivers/usb/host/pci-quirks.h                      |    2 +
 drivers/usb/host/uhci-grlib.c                      |    6 +-
 drivers/usb/host/uhci-platform.c                   |    5 +-
 drivers/usb/host/whci/hcd.c                        |    2 -
 drivers/usb/host/xhci-dbg.c                        |   10 +-
 drivers/usb/host/xhci-ext-caps.h                   |    1 +
 drivers/usb/host/xhci-hub.c                        |   16 +-
 drivers/usb/host/xhci-mem.c                        |   98 +-
 drivers/usb/host/xhci-plat.c                       |    3 +-
 drivers/usb/host/xhci-ring.c                       |    6 +-
 drivers/usb/host/xhci.c                            |  399 +-
 drivers/usb/host/xhci.h                            |   32 +-
 drivers/usb/misc/adutux.c                          |  141 +-
 drivers/usb/misc/usb3503.c                         |   41 +-
 drivers/usb/musb/Kconfig                           |   29 +
 drivers/usb/musb/Makefile                          |    4 +-
 drivers/usb/musb/blackfin.c                        |   18 +-
 drivers/usb/musb/da8xx.c                           |   18 +-
 drivers/usb/musb/davinci.c                         |   18 +-
 drivers/usb/musb/musb_core.c                       |  137 +-
 drivers/usb/musb/musb_core.h                       |   27 +-
 drivers/usb/musb/musb_gadget.c                     |   10 -
 drivers/usb/musb/musb_gadget.h                     |   38 +-
 drivers/usb/musb/musb_host.c                       |   99 +-
 drivers/usb/musb/musb_host.h                       |   57 +-
 drivers/usb/musb/musb_virthub.c                    |   54 +-
 drivers/usb/musb/omap2430.c                        |   20 +-
 drivers/usb/musb/tusb6010.c                        |   18 +-
 drivers/usb/musb/ux500.c                           |   18 +-
 drivers/usb/musb/ux500_dma.c                       |    6 +-
 drivers/usb/phy/Kconfig                            |    2 +-
 drivers/usb/phy/Makefile                           |    1 +
 drivers/usb/phy/of.c                               |   47 +
 drivers/usb/phy/phy-ab8500-usb.c                   |  846 ++-
 drivers/usb/phy/phy-nop.c                          |    2 +-
 drivers/usb/phy/phy-omap-usb3.c                    |    7 +-
 drivers/usb/phy/phy-rcar-usb.c                     |    2 +-
 drivers/usb/phy/phy-samsung-usb.c                  |  159 +-
 drivers/usb/phy/phy-samsung-usb.h                  |   24 +-
 drivers/usb/phy/phy-samsung-usb2.c                 |   62 +-
 drivers/usb/phy/phy-samsung-usb3.c                 |   23 +-
 drivers/usb/phy/phy-tegra-usb.c                    |  354 +-
 drivers/usb/phy/phy-ulpi-viewport.c                |    2 +
 drivers/usb/serial/Kconfig                         |   10 +
 drivers/usb/serial/Makefile                        |    1 +
 drivers/usb/serial/ark3116.c                       |    4 +-
 drivers/usb/serial/bus.c                           |    6 +-
 drivers/usb/serial/console.c                       |    8 +-
 drivers/usb/serial/cp210x.c                        |    2 -
 drivers/usb/serial/cypress_m8.c                    |    4 +-
 drivers/usb/serial/digi_acceleport.c               |    6 +-
 drivers/usb/serial/f81232.c                        |    7 +-
 drivers/usb/serial/flashloader.c                   |   39 +
 drivers/usb/serial/garmin_gps.c                    |    6 +-
 drivers/usb/serial/io_edgeport.c                   |   60 +-
 drivers/usb/serial/io_ti.c                         |   23 +-
 drivers/usb/serial/keyspan.c                       |   42 +-
 drivers/usb/serial/metro-usb.c                     |    4 +-
 drivers/usb/serial/mos7720.c                       |   39 +-
 drivers/usb/serial/mos7840.c                       |   57 +-
 drivers/usb/serial/opticon.c                       |    4 +-
 drivers/usb/serial/option.c                        |    4 -
 drivers/usb/serial/pl2303.c                        |   12 +-
 drivers/usb/serial/qcserial.c                      |    8 +-
 drivers/usb/serial/quatech2.c                      |   11 +-
 drivers/usb/serial/sierra.c                        |    2 +-
 drivers/usb/serial/ssu100.c                        |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   12 +-
 drivers/usb/serial/usb-serial.c                    |  133 +-
 drivers/usb/serial/usb_wwan.c                      |    4 +-
 drivers/usb/serial/whiteheat.c                     |   22 +-
 drivers/usb/storage/alauda.c                       |    6 +-
 drivers/usb/storage/sddr09.c                       |    6 +-
 drivers/usb/usb-common.c                           |   35 +
 drivers/usb/wusbcore/devconnect.c                  |    6 +-
 drivers/usb/wusbcore/mmc.c                         |   33 +-
 drivers/usb/wusbcore/pal.c                         |    5 +-
 drivers/usb/wusbcore/reservation.c                 |    3 +
 drivers/usb/wusbcore/rh.c                          |   20 -
 drivers/usb/wusbcore/wa-nep.c                      |    3 +-
 drivers/usb/wusbcore/wa-rpipe.c                    |   45 +-
 drivers/usb/wusbcore/wa-xfer.c                     |  181 +-
 drivers/usb/wusbcore/wusbhc.c                      |   79 +-
 drivers/usb/wusbcore/wusbhc.h                      |    7 +-
 drivers/uwb/drp.c                                  |    4 +-
 drivers/uwb/est.c                                  |    7 +-
 drivers/uwb/hwa-rc.c                               |    6 +
 drivers/uwb/pal.c                                  |    2 +
 drivers/uwb/rsv.c                                  |    4 +-
 drivers/uwb/uwb-internal.h                         |    3 +-
 drivers/uwb/whci.c                                 |   14 +-
 include/linux/platform_data/usb3503.h              |    5 +
 include/linux/usb.h                                |   21 +
 include/linux/usb/chipidea.h                       |   31 +-
 include/linux/usb/hcd.h                            |    1 +
 include/linux/usb/of.h                             |   32 +
 include/linux/usb/otg.h                            |    7 +
 include/linux/usb/phy.h                            |    9 +
 include/linux/usb/serial.h                         |   15 +-
 include/linux/usb/tegra_usb_phy.h                  |    9 +-
 include/linux/usb/wusb-wa.h                        |   17 +-
 249 files changed, 16059 insertions(+), 3376 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-acm
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-ecm
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-eem
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-ncm
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-obex
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-phonet
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-rndis
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-serial
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-subset
 create mode 100644 Documentation/usb/gadget_configfs.txt
 rename drivers/usb/chipidea/{ci13xxx_imx.c => ci_hdrc_imx.c} (66%)
 rename drivers/usb/chipidea/{ci13xxx_imx.h => ci_hdrc_imx.h} (100%)
 rename drivers/usb/chipidea/{ci13xxx_msm.c => ci_hdrc_msm.c} (58%)
 rename drivers/usb/chipidea/{ci13xxx_pci.c => ci_hdrc_pci.c} (67%)
 create mode 100644 drivers/usb/gadget/fotg210-udc.c
 create mode 100644 drivers/usb/gadget/fotg210.h
 create mode 100644 drivers/usb/gadget/u_ecm.h
 create mode 100644 drivers/usb/gadget/u_eem.h
 create mode 100644 drivers/usb/gadget/u_ether_configfs.h
 create mode 100644 drivers/usb/gadget/u_gether.h
 create mode 100644 drivers/usb/gadget/u_ncm.h
 create mode 100644 drivers/usb/gadget/u_rndis.h
 create mode 100644 drivers/usb/host/fusbh200-hcd.c
 create mode 100644 drivers/usb/host/fusbh200.h
 create mode 100644 drivers/usb/phy/of.c
 create mode 100644 drivers/usb/serial/flashloader.c
 create mode 100644 include/linux/usb/of.h
