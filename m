Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaFCFri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:47:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaFCFrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:47:35 -0400
Date: Mon, 2 Jun 2014 22:47:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver patches for 3.16-rc1
Message-ID: <20140603054732.GA14876@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.16-rc1

for you to fetch changes up to 4a95b1fce97756d0333f8232eb7ed6974e93b054:

  usb: hub_handle_remote_wakeup() only exists for CONFIG_PM=y (2014-06-02 15:16:33 -0700)

----------------------------------------------------------------
USB driver patches for 3.16-rc1

Here is the big USB driver pull request for 3.16-rc1.

Nothing huge here, but lots of little things in the USB core, and in
lots of drivers.  Hopefully the USB power management will be work better
now that it has been reworked to do per-port power control dynamically.
There's also a raft of gadget driver updates and fixes, CONFIG_USB_DEBUG
is finally gone now that everything has been converted over to the
dynamic debug inteface, the last hold-out drivers were cleaned up and
the config option removed.  There were also other minor things all
through the drivers/usb/ tree, the shortlog shows this pretty well.

All have been in linux-next, including the very last patch, which came
from linux-next to fix a build issue on some platforms.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: mutual exclusion for resetting a hub and power-managing a port

Aleksander Morgado (2):
      usb: qcserial: add Netgear AirCard 341U
      usb: qcserial: add additional Sierra Wireless QMI devices

Alexander Gordeev (1):
      xhci: Use pci_enable_msix_exact() instead of pci_enable_msix()

Alexander Shiyan (1):
      usb: chipidea: core: Add missing module owner field

Alexandre Belloni (1):
      usb: gadget: atmel_usba: always test udc->driver

Alexey Khoroshilov (1):
      usb: gadget: gr_udc: unconditionally use GFP_ATOMIC in gr_queue_ext()

Andreas Larsson (7):
      usb: gadget: gr_udc: improve platform_device variable name
      usb: gadget: gr_udc: Expand devicetree documentation
      usb: gadget: gr_udc: Use platform_get_irq instead of irq_of_parse_and_map
      usb: gadget: gr_udc: Use of_property_read_u32_index to access arrays
      usb: gadget: gr_udc: Add ep.maxpacket_limit to debugfs information
      usb: gadget: gr_udc: Return error code when trying to set ep.maxpacket > ep.maxpacket_limit
      usb: gadget: gr_udc: Use GFP_ATOMIC when allocating under held spinlock

Andrzej Pietrasiewicz (9):
      usb: gadget: FunctionFS: share VLA macros with all usb gadget files
      usb: gadget: OS String support
      usb: gadget: OS Feature Descriptors support
      usb: gadget: f_rndis: OS descriptors support
      usb: gadget: configfs: OS String support
      usb: gadget: configfs: OS Extended Compatibility descriptors support
      usb: gadget: f_rndis: OS Descriptors configfs support
      usb: gadget: configfs: OS Extended Properties descriptors support
      usb: gadget: f_uac2: don't queue new requests when shutting down

Andy Shevchenko (2):
      usb: dwc3: no need to initialize ret variable
      usb: dwc3: convert to pcim_enable_device()

Antoine Ténart (1):
      phy: exynos-mipi-video: fix check on array index

Apelete Seketeli (1):
      documentation: docbook: document process of writing an musb glue layer

Arnd Bergmann (9):
      PHY: Exynos: fix SATA phy license typo
      phy: kona2: use 'select GENERIC_PHY' in Kconfig
      usb: gadget: s3c2410_udc: don't use pr_debug return value
      usb: musb: tusb-dma can't be built-in if tusb is not
      usb: musb: omap2plus bus glue needs USB host support
      usb: phy: msm: reset controller is mandatory now
      usb: xhci: avoid warning for !PM_SLEEP
      usb: ohci-da8xx can only be built-in
      usb: ohci: sort out dependencies for lpc32xx and omap

Benoit Taine (1):
      USB: storage: ene_ub6250: Use kmemdup instead of kmalloc + memcpy

Bjørn Mork (4):
      usb: qcserial: fix multiline comment coding style
      usb: qcserial: refactor device layout selection
      usb: qcserial: define and use Sierra Wireless layout
      usb: qcserial: remove interface number matching

Boris BREZILLON (1):
      usb: ehci-platform: add optional reset controller retrieval

Dan Carpenter (2):
      usb: phy: msm: change devm_ioremap() to devm_ioremap_resource()
      usb: phy: msm: fix bug in probe()

Dan Williams (17):
      usb: catch attempts to submit urbs with a vmalloc'd transfer buffer
      usb: disable port power control if not supported in wHubCharacteristics
      usb: rename usb_port device objects
      usb: cleanup setting udev->removable from port_dev->connect_type
      usb: assign default peer ports for root hubs
      usb: assign usb3 external hub port peers
      usb: find internal hub tier mismatch via acpi
      usb: sysfs link peer ports
      usb: make usb_port flags atomic, rename did_runtime_put to child_usage
      usb: block suspension of superspeed port while hispeed peer is active
      usb: don't clear FEAT_C_ENABLE on usb_port_runtime_resume failure
      usb: usb3 ports do not support FEAT_C_ENABLE
      usb: refactor port handling in hub_events()
      usb: synchronize port poweroff and khubd
      usb: introduce port status lock
      usb: hub_handle_remote_wakeup() depends on CONFIG_PM_RUNTIME=y
      usb: resume child device when port is powered on

Daniel Mack (3):
      usb: musb: add reset hook to platform ops
      usb: musb: add a work_struct to recover from babble errors
      usb: musb: dsps: handle babble interrupts

David Mosberger (1):
      Add support for using a MAX3421E chip as a host driver.

David Mosberger-Tang (4):
      usb: host: max3421-hcd: Fix potential NULL urb dereference
      usb: host: max3421-hcd: Fix missing unlock in max3421_urb_enqueue()
      usb: host: max3421-hcd: fix "spi_rd8" uses dynamic stack allocation warning
      usb: host: max3421-hcd: Allow platform-data to specify Vbus polarity

Denis Carikli (1):
      usb: chipidea: usbmisc: Add USB support for i.MX25/i.MX35 CPUs

Denis Turischev (1):
      xhci: Switch only Intel Lynx Point-LP ports to EHCI on shutdown.

Dinh Nguyen (5):
      usb: dwc2: add defines to support s3c-hsotg driver
      usb: dwc2/s3c-hsotg: move s3c-hsotg into dwc2 directory
      usb: dwc2: move s3c-hsotg data structures
      usb: dwc2: Disable descriptor dma mode by default
      usb: dwc2: Add function to calculate correct FIFO sizes

Duan Jiong (1):
      usb: gadget: f_subset: replace PTR_RET with PTR_ERR_OR_ZERO

Fabio Estevam (3):
      usb: xhci: Use IS_ENABLED() macro
      chipidea: usbmisc_imx: Allow USB OTG to work on mx51
      usb: dwc2: Remove '0x' notation when using %pad format

Felipe Balbi (16):
      usb: dwc3: gadget: clear stall when disabling endpoint
      usb: dwc3: core: refactor PHY initialization
      usb: phy: mv-u3d: switch over to writel/readl
      usb: dwc3: core: refactor mode initialization to its own function
      usb: gadget: only GPL drivers in the gadget and phy framework
      usb: phy: rename usb_nop_xceiv to usb_phy_generic
      usb: phy: rename <linux/usb/usb_phy_gen_xceiv.h> to <linux/usb/usb_phy_generic.h>
      usb: musb: move usb_phy_generic_{un,}register calls to probe()/remove()
      usb: phy: generic: allow multiples calls to usb_phy_generic_register()
      usb: phy: generic: switch over to IS_ENABLED()
      usb: dwc3: gadget: print both cmd string and number
      usb: dwc3: gadget: pretty print link states
      usb: dwc3: gadget: pretty print Generic CMDs
      usb: phy: msm: cast to enum msm_usb_phy_type
      usb: phy: msm: switch over to writel()
      usb: phy: msm: enable build on other architectures

George Cherian (1):
      usb: musb: Kconfig: Select the DMA driver if DMA mode of MUSB is enabled

Greg Kroah-Hartman (12):
      Merge 3.15-rc3 into usb-next
      Merge 3.15-rc5 into usb-next
      Merge tag 'for-3.16' of git://git.kernel.org/.../kishon/linux-phy into usb-next
      Merge tag 'usb-for-v3.16' of git://git.kernel.org/.../balbi/usb into usb-next
      USB: remove CONFIG_USB_DEBUG from defconfig files
      USB: usbip: remove CONFIG_USB_DEBUG reference
      Revert "usb: gadget: net2280: Add support for PLX USB338X"
      USB: media: redrat3: remove unneeded tracing macro
      USB: media: redrat3: remove CONFIG_USB_DEBUG usage
      USB: media: streamzap: remove CONFIG_USB_DEBUG
      USB: media: lirc: igorplugusb: remove CONFIG_USB_DEBUG support
      USB: orinoco_usb: remove CONFIG_USB_DEBUG support

Gregory CLEMENT (6):
      usb: ehci-orion: fix clock reference leaking
      usb: ehci-orion: add optional PHY support
      usb: host: xhci-plat: sort the headers in alphabetic order
      usb: host: xhci-plat: add clock support
      usb: host: xhci-plat: add support for the Armada 375/38x XHCI controllers
      Documentation: dt-bindings: update xhci-platform DT binding

Huang Rui (2):
      usb: usbtest: fix unlink write error with pattern 1
      usb: usbtest: add pattern check on pipe in phase of unlink read

Ivan T. Ivanov (20):
      usb: phy: msm: Make driver selectable on ARCH_QCOM
      usb: phy: msm: Move global regulators variables to driver state
      usb: phy: msm: Enable deferred driver probing
      usb: phy: msm: Migrate to Managed Device Resource allocation
      usb: phy: msm: Remove unnecessarily check for valid regulators.
      usb: phy: msm: Fix checkpatch.pl warnings
      usb: phy: msm: Replace custom enum usb_mode_type with enum usb_dr_mode
      usb: phy: msm: Remove unused pclk_src_name
      usb: phy: msm: Remove HSUSB prefix from regulator names
      usb: phy: msm: Properly check result from platform_get_irq()
      usb: phy: msm: Add device tree support and binding information
      usb: phy: msm: Use reset framework for LINK and PHY resets
      usb: phy: msm: Add support for secondary PHY control
      usb: phy: msm: Correct USB PHY Reset sequence for newer platform
      usb: phy: msm: Handle disconnect events
      usb: phy: msm: Vote for corner of VDD CX instead of voltage of VDD CX
      usb: phy: msm: Use usb_add_phy_dev() to register device
      usb: chipidea: msm: Add device tree binding information
      usb: chipidea: msm: Add device tree support
      usb: chipidea: msm: Initialize offset of the capability registers

Jean Delvare (2):
      usb: dwc3: add glue layer dependencies
      usb: phy: add run-time dependencies to R-Car driver

Jingoo Han (8):
      usb: gadget: f_uac2: remove unnecessary OOM messages
      usb: gadget: fotg210-udc: remove unnecessary OOM messages
      usb: gadget: fsl_udc_core: remove unnecessary OOM messages
      usb: gadget: fusb300_udc: remove unnecessary OOM messages
      usb: gadget: m66592-udc: remove unnecessary OOM messages
      usb: gadget: mv_u3d_core: remove unnecessary OOM messages
      usb: gadget: r8a66597-udc: remove unnecessary OOM messages
      usb: gadget: tcm_usb_gadget: remove unnecessary OOM messages

Joe Perches (7):
      usb: ftdi-elan: Fix format fragments
      usb: ftdi-elan: Convert leading spaces to tabs
      usb: ftdi-elan: Coalesce formats
      usb: ftdi-elan: Coalesce string fragment
      usb: ftdi-elan: Use pr_<level>
      USB: appledisplay: Convert /n to \n
      USB: iowarrior: Convert local dbg macro to dev_dbg

Johan Hovold (61):
      USB: sierra: fix AA deadlock in open error path
      USB: sierra: fix use after free at suspend/resume
      USB: sierra: fix urb and memory leak in resume error path
      USB: sierra: fix urb and memory leak on disconnect
      USB: sierra: fix remote wakeup
      USB: sierra: fix characters being dropped at close
      USB: sierra: fix urbs not being killed on shutdown
      USB: sierra: fix resume error reporting
      USB: sierra: fix line-control pipe direction
      USB: sierra: remove bogus endpoint test
      USB: sierra: remove unused variable
      USB: sierra: remove unimplemented set_termios
      USB: sierra: remove disconnected test from close
      USB: sierra: do not resume I/O on closed ports
      USB: sierra: remove redundant modem-control requests
      USB: sierra: use interface-data accessors
      USB: sierra: clean up suspend
      USB: sierra: refactor delayed-urb submission
      USB: sierra: minimise no-suspend window during close
      USB: sierra: do not resume I/O on closing ports
      USB: option: fix runtime PM handling
      USB: option: fix line-control pipe direction
      USB: option: add missing usb_mark_last_busy
      USB: usb_wwan: fix write and suspend race
      USB: usb_wwan: fix urb leak at shutdown
      USB: usb_wwan: fix potential NULL-deref at resume
      USB: usb_wwan: fix potential blocked I/O after resume
      USB: usb_wwan: fix discarded writes on resume errors
      USB: usb_wwan: fix remote wakeup
      USB: usb_wwan: remove redundant modem-control request
      USB: usb_wwan: remove unimplemented set_termios
      USB: usb_wwan: remove redundant urb kill from port remove
      USB: usb_wwan: kill interrupt urb explicitly at suspend
      USB: usb_wwan: make resume error messages uniform
      USB: usb_wwan: use interface-data accessors
      USB: usb_wwan: clean up delayed-urb submission
      USB: usb_wwan: remove comment from close
      USB: usb_wwan: remove some superfluous comments
      USB: usb_wwan: remove bogus function prototype
      USB: usb_wwan: report failed submissions as errors
      USB: usb_wwan: do not resume I/O on closing ports
      USB: serial: fix potential runtime pm imbalance at device remove
      USB: serial: remove overly defensive port tests
      USB: kobil_sct: fix control requests without data stage
      USB: cdc-acm: fix write and suspend race
      USB: cdc-acm: fix write and resume race
      USB: cdc-acm: fix broken runtime suspend
      USB: cdc-acm: fix runtime PM for control messages
      USB: cdc-acm: fix shutdown and suspend race
      USB: cdc-acm: fix potential urb leak and PM imbalance in write
      USB: cdc-acm: fix open and suspend race
      USB: cdc-acm: fix failed open not being detected
      USB: cdc-acm: fix I/O after failed open
      USB: cdc-acm: fix runtime PM imbalance at shutdown
      USB: cdc-acm: simplify runtime PM locking
      USB: cdc-acm: remove redundant disconnected test from shutdown
      USB: cdc-acm: minimise no-suspend window during shutdown
      USB: cdc-acm: do not update PM busy on read errors
      USB: cdc-acm: remove redundant usb_mark_last_busy
      USB: cdc-acm: use tty-port dtr_rts
      USB: wusbcore: fix control-pipe directions

Julia Lawall (1):
      usb: gadget: make return of 0 explicit

Kamil Debski (1):
      usb: ehci-exynos: Change to use phy provided by the generic phy framework

Konrad Zapalowicz (1):
      usb: pci_quirks: fix sparse 'symbol not declared' warning

Laurent Pinchart (7):
      USB: OHCI: Export the OHCI hub control and status_data functions
      USB: EHCI: Export the ehci_hub_control function
      USB: ohci-pxa27x: Add support for external vbus regulators
      ARM: pxa: zeus: Replace OHCI init/exit functions with a regulator
      usb: gadget: uvc: Switch to monotonic clock for buffer timestamps
      usb: gadget: uvc: Set the V4L2 buffer field to V4L2_FIELD_NONE
      usb: gadget: uvc: Set the vb2 queue timestamp flags

Li Jun (15):
      usb: chipidea: operate on otgsc register in a general way
      usb: chipidea: export interrupt enable and status register read functions
      usb: chipidea: debug: add debug file for controller registers dump
      usb: phy: otg-fsm: export symbol of otg_statemachine
      usb: chipidea: usb OTG fsm initialization.
      usb: chipidea: host: vbus control change for OTG HNP
      usb: chipidea: host: init otg port number
      usb: chipidea: udc: driver update for OTG HNP
      usb: chipidea: add OTG fsm operation functions implementation
      usb: chipidea: OTG fsm timers initialization
      usb: chipidea: OTG HNP and SRP fsm implementation
      usb: chipidea: add sys inputs for OTG fsm input
      usb: chipidea: debug: add debug file for OTG variables
      Documentation: ABI: usb: sysfs Description for chipidea USB OTG HNP and SRP
      Documentation: usb: add chipidea.txt for how to demo usb OTG HNP and SRP

Lin Wang (1):
      xhci: fix wrong port number reported when setting USB2.0 hardware LPM.

Liviu Dudau (2):
      usb: phy: Add SMSC USB334x PHY ID
      phy: Enable USB PHY support for arm64

Marek Szyprowski (1):
      usb: usb5303: add support for reference clock specified in device tree

Mathias Nyman (4):
      xhci: Use command structures when queuing commands on the command ring
      xhci: Add a global command queue
      xhci: Use completion and status in global command queue
      xhci: rework command timeout and cancellation,

Matwey V. Kornilov (2):
      usb: musb: tusb6010: Add tusb_revision to struct musb to store the revision.
      usb: musb: tusb6010: Use musb->tusb_revision instead of tusb_get_revision call.

Maxime Ripard (4):
      phy: sunxi: Rework phy initialization
      Documentation: dt: Add new compatible for the A31 USB Phy
      phy: usb: sunxi: Introduce Allwinner A31 USB PHY support
      usb: ohci-platform: Enable optional use of reset controller

Naoki MATSUMOTO (1):
      USB: delete CONFIG_USB_DEVICEFS from defconfig

Oliver Neukum (6):
      xhci: unified loggig of RESET_ON_RESUME
      USB: cdc-acm: use BIT macro
      USB: usbtmc: fix DMA on stack
      USB: appledisplay: fix race between reading and writing from the device
      USB: yurex: fix race between probe() and read()
      USB: udl: proper error reporting

Paul Bolle (3):
      usb: phy: mv_u3d: Remove usb phy driver for mv_u3d
      usb: musb: tusb: remove dead code
      usb: gadget: rename CONFIG_USB_GADGET_PXA25X

Paul Zimmerman (1):
      usb: dwc2: fix sparse warning

Peter Chen (13):
      usb: chipidea: coordinate usb phy initialization for different phy type
      usb: chipidea: add proper delay for waiting correct PHY status
      usb: gadget: set gadget state as configured
      usb: udc-core: set gadget state as not attached after unloading module
      usb: gadget: configfs: fix typo
      usb: chipidea: update TODO list
      usb: chipidea: udc: delete useless code
      usb: chipidea: using one inline function to cover queue work operations
      Doc: usb: chipidea: need to build both kernel Image and modules
      usb: chipidea: udc: update gadget states according to ch9
      usb: core: remove the Kconfig entry for USB_DEBUG
      usb: move usb/usb-common.c to usb/common/usb-common.c
      usb: common: rename phy-fsm-usb.c to usb-otg-fsm.c

Ricardo Ribalda Delgado (2):
      usb: gadget: net2280: Fix NULL pointer dereference
      usb: gadget: net2280: Add support for PLX USB338X

Rickard Strandqvist (1):
      USB: keyspan: fix potential null pointer dereference

Robert Baldyga (1):
      tools: usb: aio example applications

Roger Quadros (2):
      phy: omap-usb2: Use generic clock names "wkupclk" and "refclk"
      phy: omap-usb2: Add clock names to Documentation binding

Sachin Kamat (1):
      usb: host: max3421-hcd: Use module_spi_driver

Sarah Sharp (1):
      xhci: Report max device limit when Enable Slot command fails.

Stephen Rothwell (1):
      usb: hub_handle_remote_wakeup() only exists for CONFIG_PM=y

Thomas Petazzoni (3):
      usb: ehci-orion: use platform_get_irq() for DT probing
      usb: ehci-orion: rename error goto labels in ehci_orion_drv_probe()
      Documentation: dt-bindings: update ehci-orion binding documentation

Thomas Pugliese (5):
      uwb: fix channel change failure
      uwb: add error messages when reservation establish fails
      uwb: whitespace and line length cleanups
      uwb: comment typo fix
      uwb: fix variable set but not used warnings

Tim Bird (2):
      usb: phy: msm: Fix PTS definitions for MSM USB controller
      usb: phy: msm: Select secondary PHY via TCSR

Todd E Brandt (1):
      USB: separate usb_address0 mutexes for each bus

Vivek Gautam (14):
      usb: dwc3: exynos: Make provision for vdd regulators
      usb: ohci-exynos: Remove locks for 'ohci' in suspend callback
      Documentation: Document Exynos5 USB 3.0 DRD PHY
      phy: Add new Exynos5 USB 3.0 PHY driver
      phy: exynos5-usbdrd: Add facility for VBUS supply
      usb: ohci-exynos: Use struct device instead of platform_device
      usb: ehci-exynos: Use struct device instead of platform_device
      usb: ohci-exynos: Add facility to use phy provided by the generic phy framework
      usb: host: ehci-exynos: Use devm_ioremap_resource instead of devm_ioremap
      usb: host: ehci-msm: Use devm_ioremap_resource instead of devm_ioremap
      usb: host: ehci-mv: Use devm_ioremap_resource instead of devm_ioremap
      usb: host: ehci-spear: Use devm_ioremap_resource instead of devm_ioremap
      usb: host: ehci-tegra: Use devm_ioremap_resource instead of devm_ioremap
      usb: host: ohci-exynos: Use devm_ioremap_resource instead of devm_ioremap

Wolfram Sang (1):
      usb: musb: dsps: compile suspend/resume only with PM_SLEEP

Yijing Wang (1):
      usb: remove redundant D0 power state set

Yoshihiro Shimoda (2):
      usb: host: xhci-plat: add xhci_plat_start()
      Documentation: dt-bindings: update xhci-platform DT binding for R-Car H2 and M2

xiao jin (2):
      USB: usb_wwan: fix urb leak in write error path
      USB: usb_wwan: fix race between write and resume

 Documentation/ABI/testing/configfs-usb-gadget      |   45 +
 .../ABI/testing/sysfs-platform-chipidea-usb-otg    |   56 +
 Documentation/DocBook/Makefile                     |    3 +-
 Documentation/DocBook/writing_musb_glue_layer.tmpl |  873 ++++
 .../devicetree/bindings/phy/samsung-phy.txt        |   47 +
 .../devicetree/bindings/phy/sun4i-usb-phy.txt      |   23 +-
 Documentation/devicetree/bindings/phy/ti-phy.txt   |    7 +
 .../devicetree/bindings/usb/ci-hdrc-qcom.txt       |   17 +
 .../devicetree/bindings/usb/ehci-orion.txt         |    5 +
 .../devicetree/bindings/usb/exynos-usb.txt         |   31 +
 Documentation/devicetree/bindings/usb/gr-udc.txt   |   22 +-
 .../devicetree/bindings/usb/msm-hsusb.txt          |   78 +
 Documentation/devicetree/bindings/usb/usb-ehci.txt |    1 +
 Documentation/devicetree/bindings/usb/usb-ohci.txt |    1 +
 Documentation/devicetree/bindings/usb/usb-xhci.txt |    8 +-
 Documentation/devicetree/bindings/usb/usb3503.txt  |    8 +
 Documentation/usb/chipidea.txt                     |   71 +
 arch/arm/configs/badge4_defconfig                  |    2 -
 arch/arm/configs/cm_x2xx_defconfig                 |    1 -
 arch/arm/configs/cm_x300_defconfig                 |    1 -
 arch/arm/configs/colibri_pxa270_defconfig          |    1 -
 arch/arm/configs/colibri_pxa300_defconfig          |    2 -
 arch/arm/configs/corgi_defconfig                   |    1 -
 arch/arm/configs/davinci_all_defconfig             |    1 -
 arch/arm/configs/em_x270_defconfig                 |    1 -
 arch/arm/configs/ep93xx_defconfig                  |    1 -
 arch/arm/configs/footbridge_defconfig              |    2 -
 arch/arm/configs/ixp4xx_defconfig                  |    1 -
 arch/arm/configs/keystone_defconfig                |    1 -
 arch/arm/configs/kzm9g_defconfig                   |    1 -
 arch/arm/configs/mini2440_defconfig                |    1 -
 arch/arm/configs/mv78xx0_defconfig                 |    1 -
 arch/arm/configs/neponset_defconfig                |    2 -
 arch/arm/configs/omap1_defconfig                   |    2 -
 arch/arm/configs/omap2plus_defconfig               |    1 -
 arch/arm/configs/pcm027_defconfig                  |    1 -
 arch/arm/configs/raumfeld_defconfig                |    1 -
 arch/arm/configs/s3c2410_defconfig                 |    1 -
 arch/arm/configs/s3c6400_defconfig                 |    1 -
 arch/arm/configs/spitz_defconfig                   |    1 -
 arch/arm/configs/tct_hammer_defconfig              |    1 -
 arch/arm/configs/trizeps4_defconfig                |    1 -
 arch/arm/configs/viper_defconfig                   |    1 -
 arch/arm/configs/zeus_defconfig                    |    1 -
 arch/arm/mach-msm/board-msm7x30.c                  |    2 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    1 -
 arch/arm/mach-omap2/usb-host.c                     |   10 +-
 arch/arm/mach-pxa/zeus.c                           |   89 +-
 arch/avr32/configs/hammerhead_defconfig            |    1 -
 arch/blackfin/configs/BF526-EZBRD_defconfig        |    1 -
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig     |    1 -
 arch/blackfin/configs/BF527-EZKIT_defconfig        |    1 -
 arch/blackfin/configs/BF548-EZKIT_defconfig        |    1 -
 arch/blackfin/configs/CM-BF527_defconfig           |    1 -
 arch/blackfin/configs/CM-BF548_defconfig           |    1 -
 arch/blackfin/configs/IP0X_defconfig               |    1 -
 arch/ia64/configs/bigsur_defconfig                 |    1 -
 arch/ia64/configs/generic_defconfig                |    1 -
 arch/ia64/configs/gensparse_defconfig              |    1 -
 arch/ia64/configs/tiger_defconfig                  |    1 -
 arch/mips/configs/fuloong2e_defconfig              |    1 -
 arch/mips/configs/lemote2f_defconfig               |    1 -
 arch/mips/configs/mpc30x_defconfig                 |    1 -
 arch/mips/configs/msp71xx_defconfig                |    1 -
 arch/mips/configs/mtx1_defconfig                   |    1 -
 arch/mips/configs/rm200_defconfig                  |    1 -
 arch/mips/configs/sb1250_swarm_defconfig           |    1 -
 arch/mips/configs/tb0219_defconfig                 |    1 -
 arch/mips/configs/tb0226_defconfig                 |    1 -
 arch/parisc/configs/c3000_defconfig                |    2 -
 arch/parisc/configs/default_defconfig              |    1 -
 arch/parisc/configs/generic-64bit_defconfig        |    1 -
 arch/powerpc/configs/40x/ep405_defconfig           |    1 -
 arch/powerpc/configs/44x/canyonlands_defconfig     |    1 -
 arch/powerpc/configs/44x/currituck_defconfig       |    1 -
 arch/powerpc/configs/44x/sam440ep_defconfig        |    1 -
 arch/powerpc/configs/52xx/cm5200_defconfig         |    1 -
 arch/powerpc/configs/52xx/pcm030_defconfig         |    1 -
 arch/powerpc/configs/52xx/tqm5200_defconfig        |    1 -
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig    |    1 -
 arch/powerpc/configs/83xx/sbc834x_defconfig        |    1 -
 arch/powerpc/configs/85xx/ge_imp3a_defconfig       |    1 -
 arch/powerpc/configs/85xx/socrates_defconfig       |    1 -
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig    |    1 -
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig   |    1 -
 arch/powerpc/configs/amigaone_defconfig            |    1 -
 arch/powerpc/configs/c2k_defconfig                 |    1 -
 arch/powerpc/configs/cell_defconfig                |    1 -
 arch/powerpc/configs/celleb_defconfig              |    1 -
 arch/powerpc/configs/chrp32_defconfig              |    1 -
 arch/powerpc/configs/g5_defconfig                  |    1 -
 arch/powerpc/configs/linkstation_defconfig         |    1 -
 arch/powerpc/configs/maple_defconfig               |    1 -
 arch/powerpc/configs/mpc5200_defconfig             |    1 -
 arch/powerpc/configs/mpc86xx_defconfig             |    1 -
 arch/powerpc/configs/pmac32_defconfig              |    1 -
 arch/powerpc/configs/ppc6xx_defconfig              |    2 -
 arch/powerpc/configs/storcenter_defconfig          |    1 -
 arch/sh/configs/apsh4ad0a_defconfig                |    1 -
 arch/sh/configs/ecovec24_defconfig                 |    1 -
 arch/sh/configs/landisk_defconfig                  |    1 -
 arch/sh/configs/rsk7203_defconfig                  |    1 -
 arch/sh/configs/rsk7264_defconfig                  |    1 -
 arch/sh/configs/rsk7269_defconfig                  |    1 -
 arch/sh/configs/sdk7780_defconfig                  |    2 -
 arch/sh/configs/se7343_defconfig                   |    2 -
 arch/sh/configs/se7780_defconfig                   |    1 -
 arch/sh/configs/sh2007_defconfig                   |    1 -
 arch/sh/configs/sh7785lcr_defconfig                |    1 -
 arch/sh/configs/titan_defconfig                    |    1 -
 arch/sh/configs/urquell_defconfig                  |    1 -
 arch/unicore32/configs/unicore32_defconfig         |    1 -
 arch/x86/configs/i386_defconfig                    |    1 -
 arch/x86/configs/x86_64_defconfig                  |    1 -
 drivers/gpu/drm/udl/udl_main.c                     |    3 +-
 drivers/media/rc/redrat3.c                         |  102 +-
 drivers/media/rc/streamzap.c                       |    9 -
 drivers/net/wireless/orinoco/orinoco_usb.c         |   50 +-
 drivers/phy/Kconfig                                |   13 +-
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos-mipi-video.c                |    2 +-
 drivers/phy/phy-exynos5-usbdrd.c                   |  676 +++
 drivers/phy/phy-exynos5250-sata.c                  |    2 +-
 drivers/phy/phy-omap-usb2.c                        |   30 +-
 drivers/phy/phy-sun4i-usb.c                        |   75 +-
 drivers/staging/media/lirc/lirc_igorplugusb.c      |   30 +-
 drivers/staging/usbip/userspace/README             |    1 -
 drivers/usb/Makefile                               |    3 +-
 drivers/usb/chipidea/Makefile                      |    1 +
 drivers/usb/chipidea/bits.h                        |   10 +
 drivers/usb/chipidea/ci.h                          |   23 +
 drivers/usb/chipidea/ci_hdrc_msm.c                 |   24 +-
 drivers/usb/chipidea/core.c                        |   92 +-
 drivers/usb/chipidea/debug.c                       |  135 +
 drivers/usb/chipidea/host.c                        |   21 +-
 drivers/usb/chipidea/otg.c                         |   48 +-
 drivers/usb/chipidea/otg.h                         |   23 +-
 drivers/usb/chipidea/otg_fsm.c                     |  842 ++++
 drivers/usb/chipidea/otg_fsm.h                     |  129 +
 drivers/usb/chipidea/udc.c                         |   69 +-
 drivers/usb/chipidea/usbmisc_imx.c                 |   68 +
 drivers/usb/class/cdc-acm.c                        |  177 +-
 drivers/usb/class/cdc-acm.h                        |   14 +-
 drivers/usb/class/usbtmc.c                         |    6 +-
 drivers/usb/common/Makefile                        |    6 +
 drivers/usb/{ => common}/usb-common.c              |    0
 .../{phy/phy-fsm-usb.c => common/usb-otg-fsm.c}    |    1 +
 drivers/usb/core/Kconfig                           |   16 +-
 drivers/usb/core/hcd-pci.c                         |    1 -
 drivers/usb/core/hcd.c                             |   49 +-
 drivers/usb/core/hub.c                             |  956 ++--
 drivers/usb/core/hub.h                             |   41 +-
 drivers/usb/core/port.c                            |  289 +-
 drivers/usb/core/usb-acpi.c                        |  107 +-
 drivers/usb/core/usb.h                             |   16 +-
 drivers/usb/dwc2/Kconfig                           |   61 +-
 drivers/usb/dwc2/Makefile                          |   37 +-
 drivers/usb/dwc2/core.c                            |   68 +
 drivers/usb/dwc2/core.h                            |  182 +
 drivers/usb/{gadget/s3c-hsotg.c => dwc2/gadget.c}  |  598 +--
 drivers/usb/dwc2/hw.h                              |   12 +-
 drivers/usb/dwc2/platform.c                        |    6 +
 drivers/usb/dwc3/Kconfig                           |    4 +-
 drivers/usb/dwc3/core.c                            |  253 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |   71 +-
 drivers/usb/dwc3/dwc3-omap.c                       |    2 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   21 +-
 drivers/usb/dwc3/gadget.c                          |   83 +-
 drivers/usb/gadget/Kconfig                         |   10 +-
 drivers/usb/gadget/Makefile                        |    1 -
 drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
 drivers/usb/gadget/composite.c                     |  316 +-
 drivers/usb/gadget/configfs.c                      |  556 ++-
 drivers/usb/gadget/configfs.h                      |   12 +
 drivers/usb/gadget/dummy_hcd.c                     |    4 +-
 drivers/usb/gadget/f_fs.c                          |   33 +-
 drivers/usb/gadget/f_rndis.c                       |   33 +-
 drivers/usb/gadget/f_subset.c                      |    2 +-
 drivers/usb/gadget/f_uac2.c                        |   10 +-
 drivers/usb/gadget/fotg210-udc.c                   |    8 +-
 drivers/usb/gadget/fsl_udc_core.c                  |    8 +-
 drivers/usb/gadget/fusb300_udc.c                   |    8 +-
 drivers/usb/gadget/gr_udc.c                        |   55 +-
 drivers/usb/gadget/inode.c                         |    3 +-
 drivers/usb/gadget/m66592-udc.c                    |    1 -
 drivers/usb/gadget/mv_u3d_core.c                   |   14 +-
 drivers/usb/gadget/net2280.c                       |    4 +-
 drivers/usb/gadget/r8a66597-udc.c                  |    1 -
 drivers/usb/gadget/rndis.c                         |   28 +-
 drivers/usb/gadget/s3c-hsotg.h                     |  378 --
 drivers/usb/gadget/s3c2410_udc.c                   |    3 +-
 drivers/usb/gadget/storage_common.c                |   52 +-
 drivers/usb/gadget/tcm_usb_gadget.c                |   16 +-
 drivers/usb/gadget/u_ether.c                       |   32 +-
 drivers/usb/gadget/u_f.c                           |    2 +-
 drivers/usb/gadget/u_f.h                           |   26 +
 drivers/usb/gadget/u_os_desc.h                     |   90 +
 drivers/usb/gadget/u_rndis.h                       |    3 +
 drivers/usb/gadget/udc-core.c                      |    2 +
 drivers/usb/gadget/uvc_queue.c                     |   12 +-
 drivers/usb/host/Kconfig                           |   34 +-
 drivers/usb/host/Makefile                          |    4 +
 drivers/usb/host/ehci-exynos.c                     |  141 +-
 drivers/usb/host/ehci-hub.c                        |   12 +-
 drivers/usb/host/ehci-msm.c                        |    7 +-
 drivers/usb/host/ehci-mv.c                         |   16 +-
 drivers/usb/host/ehci-orion.c                      |   92 +-
 drivers/usb/host/ehci-platform.c                   |   26 +-
 drivers/usb/host/ehci-spear.c                      |   13 +-
 drivers/usb/host/ehci-tegra.c                      |   15 +-
 drivers/usb/host/ehci.h                            |    3 +
 drivers/usb/host/max3421-hcd.c                     | 1957 ++++++++
 drivers/usb/host/ohci-at91.c                       |   11 +-
 drivers/usb/host/ohci-exynos.c                     |  145 +-
 drivers/usb/host/ohci-hcd.c                        |    2 +-
 drivers/usb/host/ohci-hub.c                        |    8 +-
 drivers/usb/host/ohci-platform.c                   |   27 +-
 drivers/usb/host/ohci-pxa27x.c                     |   68 +
 drivers/usb/host/ohci-s3c2410.c                    |   13 +-
 drivers/usb/host/ohci.h                            |    3 +
 drivers/usb/host/pci-quirks.h                      |    1 +
 drivers/usb/host/xhci-hub.c                        |   43 +-
 drivers/usb/host/xhci-mem.c                        |   17 +-
 drivers/usb/host/xhci-mvebu.c                      |   72 +
 drivers/usb/host/xhci-mvebu.h                      |   21 +
 drivers/usb/host/xhci-pci.c                        |   10 +-
 drivers/usb/host/xhci-plat.c                       |   51 +-
 drivers/usb/host/xhci-ring.c                       |  587 +--
 drivers/usb/host/xhci.c                            |  271 +-
 drivers/usb/host/xhci.h                            |   49 +-
 drivers/usb/misc/appledisplay.c                    |   15 +-
 drivers/usb/misc/ftdi-elan.c                       | 4878 ++++++++++----------
 drivers/usb/misc/iowarrior.c                       |   38 +-
 drivers/usb/misc/usb3503.c                         |   59 +-
 drivers/usb/misc/usbtest.c                         |   13 +
 drivers/usb/misc/yurex.c                           |    3 +-
 drivers/usb/musb/Kconfig                           |    5 +-
 drivers/usb/musb/am35x.c                           |   14 +-
 drivers/usb/musb/blackfin.c                        |   14 +-
 drivers/usb/musb/da8xx.c                           |   16 +-
 drivers/usb/musb/davinci.c                         |    8 +-
 drivers/usb/musb/musb_core.c                       |   35 +
 drivers/usb/musb/musb_core.h                       |    9 +
 drivers/usb/musb/musb_dsps.c                       |   29 +-
 drivers/usb/musb/tusb6010.c                        |   28 +-
 drivers/usb/musb/tusb6010.h                        |    8 -
 drivers/usb/musb/tusb6010_omap.c                   |    2 +-
 drivers/usb/phy/Kconfig                            |   27 +-
 drivers/usb/phy/Makefile                           |    2 -
 drivers/usb/phy/phy-am335x.c                       |    4 +-
 drivers/usb/phy/phy-generic.c                      |   65 +-
 drivers/usb/phy/phy-generic.h                      |    8 +-
 drivers/usb/phy/phy-keystone.c                     |    4 +-
 drivers/usb/phy/phy-msm-usb.c                      |  702 +--
 drivers/usb/phy/phy-mv-u3d-usb.c                   |  338 --
 drivers/usb/phy/phy-mv-u3d-usb.h                   |  105 -
 drivers/usb/phy/phy-ulpi.c                         |    1 +
 drivers/usb/serial/bus.c                           |   14 +-
 drivers/usb/serial/keyspan.c                       |    4 +-
 drivers/usb/serial/kobil_sct.c                     |   22 +-
 drivers/usb/serial/option.c                        |   13 +-
 drivers/usb/serial/qcserial.c                      |  143 +-
 drivers/usb/serial/sierra.c                        |  198 +-
 drivers/usb/serial/usb-serial.c                    |   38 +-
 drivers/usb/serial/usb-wwan.h                      |    6 +-
 drivers/usb/serial/usb_wwan.c                      |  234 +-
 drivers/usb/storage/ene_ub6250.c                   |    3 +-
 drivers/usb/wusbcore/wa-rpipe.c                    |    4 +-
 drivers/uwb/beacon.c                               |    7 +-
 drivers/uwb/drp.c                                  |  294 +-
 drivers/uwb/est.c                                  |    2 -
 drivers/uwb/ie-rcv.c                               |    2 -
 drivers/uwb/radio.c                                |    2 +-
 drivers/uwb/rsv.c                                  |   21 +-
 include/linux/mfd/syscon/exynos5-pmu.h             |   44 +
 include/linux/platform_data/max3421-hcd.h          |   24 +
 include/linux/usb.h                                |    2 +
 include/linux/usb/composite.h                      |   79 +
 include/linux/usb/msm_hsusb.h                      |   39 +-
 include/linux/usb/msm_hsusb_hw.h                   |   14 +-
 .../usb/{usb_phy_gen_xceiv.h => usb_phy_generic.h} |   13 +-
 .../multibuff/device_app/aio_multibuff.c           |  349 ++
 .../ffs-aio-example/multibuff/host_app/Makefile    |   13 +
 .../usb/ffs-aio-example/multibuff/host_app/test.c  |  146 +
 .../ffs-aio-example/simple/device_app/aio_simple.c |  335 ++
 tools/usb/ffs-aio-example/simple/host_app/Makefile |   13 +
 tools/usb/ffs-aio-example/simple/host_app/test.c   |  148 +
 291 files changed, 14364 insertions(+), 6800 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-chipidea-usb-otg
 create mode 100644 Documentation/DocBook/writing_musb_glue_layer.tmpl
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt
 create mode 100644 Documentation/usb/chipidea.txt
 create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
 create mode 100644 drivers/usb/chipidea/otg_fsm.c
 create mode 100644 drivers/usb/chipidea/otg_fsm.h
 create mode 100644 drivers/usb/common/Makefile
 rename drivers/usb/{ => common}/usb-common.c (100%)
 rename drivers/usb/{phy/phy-fsm-usb.c => common/usb-otg-fsm.c} (99%)
 rename drivers/usb/{gadget/s3c-hsotg.c => dwc2/gadget.c} (85%)
 delete mode 100644 drivers/usb/gadget/s3c-hsotg.h
 create mode 100644 drivers/usb/gadget/u_os_desc.h
 create mode 100644 drivers/usb/host/max3421-hcd.c
 create mode 100644 drivers/usb/host/xhci-mvebu.c
 create mode 100644 drivers/usb/host/xhci-mvebu.h
 delete mode 100644 drivers/usb/phy/phy-mv-u3d-usb.c
 delete mode 100644 drivers/usb/phy/phy-mv-u3d-usb.h
 create mode 100644 include/linux/mfd/syscon/exynos5-pmu.h
 create mode 100644 include/linux/platform_data/max3421-hcd.h
 rename include/linux/usb/{usb_phy_gen_xceiv.h => usb_phy_generic.h} (53%)
 create mode 100644 tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c
 create mode 100644 tools/usb/ffs-aio-example/multibuff/host_app/Makefile
 create mode 100644 tools/usb/ffs-aio-example/multibuff/host_app/test.c
 create mode 100644 tools/usb/ffs-aio-example/simple/device_app/aio_simple.c
 create mode 100644 tools/usb/ffs-aio-example/simple/host_app/Makefile
 create mode 100644 tools/usb/ffs-aio-example/simple/host_app/test.c
