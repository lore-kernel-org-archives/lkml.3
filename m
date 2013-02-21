Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3BUSjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:39:44 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:34850 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3BUSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:39:41 -0500
Date: Thu, 21 Feb 2013 10:40:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130221184010.GA24692@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 200e0d994d9d1919b28c87f1a5fb99a8e13b8a0f:

  USB: storage: optimize to match the Huawei USB storage devices and support new switch command (2013-02-04 10:41:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.9-rc1

for you to fetch changes up to 6166805c3de539a41cfcae39026c5bc273d7c6aa:

  Revert "USB: EHCI: make ehci-vt8500 a separate driver" (2013-02-20 10:26:31 -0800)

----------------------------------------------------------------
USB patches for 3.9-rc1

Here's the big USB merge for 3.9-rc1

Nothing major, lots of gadget fixes, and of course, xhci stuff.

All of this has been in linux-next for a while, with the exception of
the last 3 patches, which were reverts of patches in the tree that
caused problems, they went in yesterday.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (1):
      usb: musb: omap2430: fix the readiness check in omap_musb_mailbox

Alan Stern (3):
      USB: fix sign-extension bug in the hub driver
      USB: altsetting overrides for usbtest
      USB: GADGET: optionally force full-speed for net2280 UDC

Andrzej Pietrasiewicz (1):
      usb: gadget: f_mass_storage: remove unused operations

Armando Visconti (1):
      usb: gadget zero: avoid unnecessary reinit of data in f_sourcesink

Arnd Bergmann (1):
      USB: update host controller Kconfig entries

Arvid Brodin (1):
      usb/isp1760: declare schedule_ptds() and errata2_function() static

Bjørn Mork (3):
      USB: option: add and update Alcatel modems
      USB: option: add Yota / Megafon M100-1 4g modem
      USB: option: add Huawei "ACM" devices using protocol = vendor

Cesar Eduardo Barros (1):
      usb: phy: mv-otg: use to_delayed_work instead of cast

Chao Xie (6):
      usb: gadget: mv_udc: use udc_start and udc_stop functions
      usb: gadget: mv_udc: use devm_xxx for probe
      usb: gadget: mv_udc: fix the warning of mv_udc_remove
      usb: otg: mv_otg: use devm_xxx for probe
      usb: host: ehci-mv: remove unused variable
      usb: gadget: mv_udc: fix the value of tranceiver

Chen Gang (5):
      USB: ohci: set urb->hcpriv = NULL immediately, after free it
      USB: uhci: check buffer length to avoid memory overflow
      USB: uhci: beautify source code
      drivers/usb/core: using strlcpy instead of strncpy
      drivers/usb/gadget: using strlcpy instead of strncpy

Dan Carpenter (2):
      USB: c67x00-ll-hpi.c: signedness bug in ll_recv_msg()
      USB: wusbcore/wa-xfer: error handling fixes in setup_segs()

Dongjin Kim (4):
      USB: misc: Add USB3503 High-Speed Hub Controller
      USB: misc: fixup smatch WARNING
      USB: misc: usb3503: add dt support
      USB: misc: usb3503: Fix compiler warning

Fabio Baltieri (1):
      usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare

Fabio Estevam (1):
      USB: chipidea: ci13xxx_imx: Remove sparse warning

Felipe Balbi (21):
      usb: dwc3: decrease event buffer size
      usb: dwc3: gadget: don't redefine 'ret'
      usb: dwc3: debugfs: convert our regdump to use regsets
      usb: gadget: f_uac2: fix compile warning
      usb: gadget: fix two sparse warnings
      usb: dwc3: gadget: change HIRD threshold to 12
      usb: gadget: amd5536udc: convert to udc_start/udc_stop
      usb: gadget: fusb300_udc: convert to udc_start/udc_stop
      usb: gadget: goku_udc: convert to udc_start/udc_stop
      usb: gadget: fsl_udc_core: convert to udc_start/udc_stop
      usb: gadget: m66592-udc: convert to udc_start/udc_stop
      usb: gadget: omap_udc: convert to udc_start/udc_stop
      usb: gadget: pch_udc: convert to udc_start/udc_stop
      usb: gadget: pxa25x_udc: convert to udc_start/udc_stop
      usb: gadget: pxa27x_udc: convert to udc_start/udc_stop
      usb: gadget: s3c2410: convert to udc_start/udc_stop
      usb: gadget: completely remove ->start/->stop
      usb: gadget: constify all struct usb_gadget_ops
      usb: phy: fix Kconfig warning
      usb: omap_control_usb: fix compile warning
      usb: gadget: imx_udc: make it depend on BROKEN

Fengguang Wu (1):
      usb: misc: usb3503_probe() can be static

Frans Klaver (1):
      usb: add driver for xsens motion trackers

Gerd Hoffmann (8):
      uas: new function to cancel data urbs
      uas: add UNLINK_DATA_URBS flag
      uas: add IS_IN_WORK_LIST flag
      uas: improve abort handler
      uas: improve device reset
      uas: fail any request submitted while resetting the device.
      usb-uas: set max_lun and max_channel
      usb-uas: update MAINTAINERS entry

Greg Kroah-Hartman (11):
      Merge tag 'for-usb-next-2013-01-03' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge 3.8-rc4 into usb-next
      Merge tag 'musb-for-v3.9' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'dwc3-for-v3.9' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'gadget-for-v3.9' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'xceiv-for-v3.9' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge 3.8-rc5 into usb-next
      Merge usb-linus branch into usb-next
      Revert "USB: update host controller Kconfig entries"
      Revert "USB: EHCI: make ehci-orion a separate driver"
      Revert "USB: EHCI: make ehci-vt8500 a separate driver"

Heiko Carstens (1):
      drivers/usb: add missing GENERIC_HARDIRQS dependencies

Javier Martinez Canillas (1):
      usb: host: xhci: remove unused trb var in xhci_irq()

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: gadget: at91_adc: fix pullup pin validity check

Jingoo Han (1):
      usb: dwc3: exynos: use devm_ functions

Johan Hovold (6):
      USB: io_ti: move write-fifo flushing to close
      USB: io_ti: use tty-port drain delay
      USB: serial: grab disconnect mutex in chars_in_buffer
      USB: io_ti: query hardware-buffer status in chars_in_buffer
      USB: io_ti: kill custom closing_wait implementation
      USB: serial: fix null-pointer dereferences on disconnect

Josh Boyer (1):
      USB: usb-storage: unusual_devs update for Super TOP SATA bridge

Julia Lawall (1):
      drivers/usb/chipidea/core.c: adjust duplicate test

Kishon Vijay Abraham I (21):
      usb: dwc3: omap: use device_for_each_child to handle child removal
      usb: dwc3: omap: use of_platform API to create dwc3 core pdev
      usb: dwc3: omap: use runtime API's to enable clocks
      usb: dwc3: omap: Remove explicit writes to SYSCONFIG register
      usb: dwc3: omap: Add an API to write to dwc mailbox
      usb: dwc3: core: enable the USB2 and USB3 phy in probe
      usb: dwc3: core: stray statements are removed
      usb: otg: add an api to bind the usb controller and phy
      usb: otg: utils: add facilities in phy lib to support multiple PHYs of same type
      usb: otg: add device tree support to otg library
      usb: phy: add a new driver for usb part of control module
      usb: start using the control module driver
      usb: phy: add a new driver for usb3 phy
      usb: musb: omap: make use of the new PHY lib APIs
      usb: musb: omap: get phy by phandle for dt boot
      usb: phy: omap-usb2: enable 960Mhz clock for omap5
      usb: dwc3: core: add dt support for dwc3 core
      ARM: OMAP4: remove control module address space from PHY and OTG
      ARM: OMAP: devices: create device for usb part of control module
      ARM: OMAP2: MUSB: Specify omap4 has mailbox
      ARM: OMAP: USB: Add phy binding information

Lan Tianyu (12):
      usb: Add driver/usb/core/(port.c,hub.h) files
      usb: fix compilation error and warning of driver/usb/core/port.c on arm and blackfin
      usb: Add "portX/connect_type" attribute to expose usb port's connect type
      usb: Create link files between child device and usb port device.
      USB: Set usb port's DeviceRemovable according acpi information
      usb: Register usb port's acpi power resources
      PM/Qos: Expose dev_pm_qos_flags symbol
      usb: add runtime pm support for usb port device
      usb: add usb port auto power off mechanism
      usb: expose usb port's pm qos flags to user space
      usb: enable usb port device's async suspend.
      Revert "usb: Register usb port's acpi power resources"

Manjunath Goudar (2):
      USB: EHCI: make ehci-vt8500 a separate driver
      USB: EHCI: make ehci-orion a separate driver

Matt Sealey (1):
      USB: ehci-mxc: remove Efika MX-specific CHRGVBUS hack

Michal Nazarewicz (1):
      usb: gadget: FunctionFS: Use kstrtoul()

Ming Lei (3):
      usb: musb: core: fix failure path
      usb: musb: fix dependency on transceiver driver
      USB: storage: avoid scanning other targets for single target device

Peter Chen (1):
      usb: phy: mxs-phy: add set_suspend API

Pratyush Anand (8):
      usb: dwc3: Enable usb2 LPM only when connected as usb2.0
      usb: dwc3: gadget: fix missed isoc
      usb: dwc3: gadget: correct return from ep_queue
      usb: dwc3: gadget: fix isoc END TRANSFER Condition
      usb: dwc3: gadget: fix skip LINK_TRB on ISOC
      usb: dwc3: gadget: no need to pass params in case of UPDATE_TRANSFER
      usb: dwc3: gadget: fix scatter gather implementation
      usb: dwc3: gadget: req->queued must be forced to false in cleanup

Praveen Paneri (2):
      usb: phy: samsung: Introducing usb phy driver for hsotg
      usb: phy: s3c-hsotg: adding phy driver support

Roger Quadros (2):
      USB: ehci-omap: Don't free gpios that we didn't request
      USB: ehci-omap: Fix autoloading of module

Sachin Kamat (3):
      usb: gadget: s3c-hsudc: Use devm_regulator_bulk_get
      usb: gadget: s3c-hsotg: Use devm_regulator_bulk_get API
      usb: musb: dsps: Remove duplicate inclusion of linux/of.h

Sarah Sharp (6):
      USB: Don't use EHCI port sempahore for USB 3.0 hubs.
      USB: Prepare for refactoring by adding extra udev checks.
      USB: Rip out recursive call on warm port reset.
      USB: Fix connected device switch to Inactive state.
      USB: Use helper function hub_set_port_link_state
      USB: Refactor hub_port_wait_reset.

Sasha Levin (1):
      tools/usb: remove unneeded 'continue' and simplify condition

Sebastian Andrzej Siewior (28):
      usb: gadget: file_storage: remove its last pieces
      usb: gadget: ncm: make global variable ndp*_opts read only
      usb: gadget: mass_storage: remove >= 0 check for unsigned type
      usb: gadget: consider link speed for bMaxPower
      usb/core: consider link speed while looking at bMaxPower
      usb/core: update power budget for SuperSpeed
      usb: gadget: composite: don't call driver's unbind() if bind() failed
      usb: gadget: remove u32 castings of address passed to readl()
      usb: gadget: provide a wrapper around SourceSink's setup function
      usb: gadget: move source sink's config descriptor out of f_sourcesink
      usb: gadget: move loopback's config descriptor out of f_loopback
      usb: gadget: add some infracture to register/unregister functions
      usb: gadget: convert source sink and loopback to new function interface
      usb: gadget: f_acm: remove empty function
      usb: gadget: g_serial: split the three possible functions into three bind functions
      usb: gadget: u_serial: convert into a module
      usb: gadget: composite: add usb_remove_function()
      usb: gadget: allocate & giveback serial ports instead hard code them
      usb: gadget: f_acm: convert to new function interface with backwards compatibility
      usb: gadget: acm_ms: use function framework for ACM
      usb: gadget: cdc2: use function framework for ACM
      usb: gadget: multi: use function framework for ACM
      usb: gadget: add a forward pointer from usb_function to its "instance"
      usb: gadget: udc-core: introduce UDC binding by name
      usb: gadget: factor out two helper functions from composite_bind()
      usb: gadget: export composite's setup & disconnect function
      usb: gadget: composite: introduce usb_gstrings_attach()
      usb: gadget: f_acm: use usb_gstrings_attach()

Sergei Shtylyov (3):
      usb: musb: omap2430: kill redundant assignments in omap2430_probe()
      usb: musb: omap2430: fix wrong devm_kzalloc() result check
      testusb: remove all mentions of 'usbfs'

Stefan Hubner (1):
      usb: serial: keyspan: fixed coding style issues

Tejun Heo (1):
      usb: gadget: at91_udc: don't use [delayed_]work_pending()

Vivek Gautam (11):
      usb: dwc3: remove dwc3 dependency on host AND gadget.
      usb: phy: samsung: Add support to set pmu isolation
      ARM: EXYNOS: Update & move usb-phy types to generic include layer
      usb: phy: samsung: Add host phy support to samsung-phy driver
      USB: ehci-s5p: Add phy driver support
      USB: ohci-exynos: Add phy driver support
      usb: phy: samsung: Remove __devinit, __devexit_p and __exit annotations
      usb: ehci-s5p/ohci-exynos: Fix compatible strings for the device
      usb: dwc3: exynos: fix compatible strings for the device
      usb: dwc3: exynos/omap: Change platform device IDs for no_op_xceive to AUTO
      usb: dwc3: host: Change platform device ID for xhci-hcd to AUTO

Wei Yongjun (1):
      usb: gadget: remove unused variable in uac2_pcm_trigger()

Woody Suwalski (1):
      USB: UHCI: remove unused definition

fangxiaozhi (1):
      USB: storage: properly handle the endian issues of idProduct

supriya karanth (3):
      usb: musb: set TXMAXP and AUTOSET for full speed bulk in device mode
      usb: musb: set AUTOSET for full speed bulk DMA transfer in host mode
      usb: musb: Double buffering issues in host mode TX

 Documentation/ABI/testing/sysfs-bus-usb            |   9 +
 Documentation/devicetree/bindings/usb/dwc3.txt     |  22 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |  34 +-
 .../devicetree/bindings/usb/samsung-usbphy.txt     |  55 ++
 Documentation/devicetree/bindings/usb/usb-phy.txt  |  35 +-
 Documentation/devicetree/bindings/usb/usb3503.txt  |  20 +
 MAINTAINERS                                        |   3 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   2 +
 arch/arm/mach-omap2/board-3430sdp.c                |   2 +
 arch/arm/mach-omap2/board-4430sdp.c                |   2 +
 arch/arm/mach-omap2/board-cm-t35.c                 |   2 +
 arch/arm/mach-omap2/board-devkit8000.c             |   2 +
 arch/arm/mach-omap2/board-igep0020.c               |   2 +
 arch/arm/mach-omap2/board-ldp.c                    |   2 +
 arch/arm/mach-omap2/board-omap3beagle.c            |   2 +
 arch/arm/mach-omap2/board-omap3evm.c               |   2 +
 arch/arm/mach-omap2/board-omap3logic.c             |   2 +
 arch/arm/mach-omap2/board-omap3pandora.c           |   2 +
 arch/arm/mach-omap2/board-omap3stalker.c           |   2 +
 arch/arm/mach-omap2/board-omap3touchbook.c         |   2 +
 arch/arm/mach-omap2/board-omap4panda.c             |   2 +
 arch/arm/mach-omap2/board-overo.c                  |   2 +
 arch/arm/mach-omap2/board-rm680.c                  |   2 +
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   2 +
 arch/arm/mach-omap2/devices.c                      |  45 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  13 -
 arch/arm/mach-omap2/usb-musb.c                     |   3 +
 drivers/base/power/qos.c                           |   1 +
 drivers/usb/c67x00/c67x00-ll-hpi.c                 |   2 +-
 drivers/usb/chipidea/ci13xxx_imx.h                 |   2 +-
 drivers/usb/chipidea/core.c                        |   2 +-
 drivers/usb/core/Makefile                          |   1 +
 drivers/usb/core/devices.c                         |  13 +-
 drivers/usb/core/devio.c                           |   3 +-
 drivers/usb/core/generic.c                         |   2 +-
 drivers/usb/core/hcd.c                             |   5 +-
 drivers/usb/core/hub.c                             | 616 ++++++++------
 drivers/usb/core/hub.h                             | 122 +++
 drivers/usb/core/message.c                         |   2 +-
 drivers/usb/core/port.c                            | 202 +++++
 drivers/usb/core/sysfs.c                           |  31 +-
 drivers/usb/core/usb.h                             |  12 +
 drivers/usb/dwc3/Kconfig                           |  31 +-
 drivers/usb/dwc3/Makefile                          |  10 +-
 drivers/usb/dwc3/core.c                            |  31 +-
 drivers/usb/dwc3/core.h                            |  24 +-
 drivers/usb/dwc3/debugfs.c                         |  38 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |  57 +-
 drivers/usb/dwc3/dwc3-omap.c                       | 152 ++--
 drivers/usb/dwc3/gadget.c                          | 292 ++++---
 drivers/usb/dwc3/host.c                            |   2 +-
 drivers/usb/gadget/Kconfig                         |  24 +-
 drivers/usb/gadget/Makefile                        |   8 +-
 drivers/usb/gadget/acm_ms.c                        |  42 +-
 drivers/usb/gadget/amd5536udc.c                    |  59 +-
 drivers/usb/gadget/amd5536udc.h                    |   2 +
 drivers/usb/gadget/at91_udc.c                      |   5 +-
 drivers/usb/gadget/cdc2.c                          |  36 +-
 drivers/usb/gadget/composite.c                     | 326 ++++++--
 drivers/usb/gadget/dbgp.c                          |  14 +-
 drivers/usb/gadget/f_acm.c                         | 153 ++--
 drivers/usb/gadget/f_fs.c                          |   5 +-
 drivers/usb/gadget/f_loopback.c                    | 103 +--
 drivers/usb/gadget/f_mass_storage.c                |  37 +-
 drivers/usb/gadget/f_ncm.c                         |  18 +-
 drivers/usb/gadget/f_obex.c                        |   4 -
 drivers/usb/gadget/f_serial.c                      |   4 -
 drivers/usb/gadget/f_sourcesink.c                  | 200 +++--
 drivers/usb/gadget/f_uac2.c                        |   9 +-
 drivers/usb/gadget/f_uvc.c                         |   3 +-
 drivers/usb/gadget/fsl_qe_udc.c                    |   2 +-
 drivers/usb/gadget/fsl_udc_core.c                  |  60 +-
 drivers/usb/gadget/functions.c                     | 116 +++
 drivers/usb/gadget/fusb300_udc.c                   |  67 +-
 drivers/usb/gadget/fusb300_udc.h                   |   2 +
 drivers/usb/gadget/g_zero.h                        |  35 +-
 drivers/usb/gadget/gmidi.c                         |   2 +-
 drivers/usb/gadget/goku_udc.c                      |  70 +-
 drivers/usb/gadget/goku_udc.h                      |   1 +
 drivers/usb/gadget/m66592-udc.c                    |  72 +-
 drivers/usb/gadget/m66592-udc.h                    |   1 +
 drivers/usb/gadget/multi.c                         |  71 +-
 drivers/usb/gadget/mv_udc_core.c                   | 246 +++---
 drivers/usb/gadget/net2280.c                       |  15 +
 drivers/usb/gadget/nokia.c                         |  43 +-
 drivers/usb/gadget/omap_udc.c                      |  51 +-
 drivers/usb/gadget/pch_udc.c                       |  67 +-
 drivers/usb/gadget/pxa25x_udc.c                    |  62 +-
 drivers/usb/gadget/pxa25x_udc.h                    |   1 +
 drivers/usb/gadget/pxa27x_udc.c                    |  61 +-
 drivers/usb/gadget/pxa27x_udc.h                    |   1 +
 drivers/usb/gadget/r8a66597-udc.c                  |   2 +-
 drivers/usb/gadget/s3c-hsotg.c                     |  44 +-
 drivers/usb/gadget/s3c-hsudc.c                     |  13 +-
 drivers/usb/gadget/s3c2410_udc.c                   |  65 +-
 drivers/usb/gadget/s3c2410_udc.h                   |   1 +
 drivers/usb/gadget/serial.c                        | 118 ++-
 drivers/usb/gadget/storage_common.c                |  61 --
 drivers/usb/gadget/u_serial.c                      | 313 +++----
 drivers/usb/gadget/u_serial.h                      |  13 +-
 drivers/usb/gadget/udc-core.c                      | 157 ++--
 drivers/usb/gadget/webcam.c                        |   2 +-
 drivers/usb/gadget/zero.c                          | 233 ++++--
 drivers/usb/host/Kconfig                           |   2 +-
 drivers/usb/host/ehci-mv.c                         |   1 -
 drivers/usb/host/ehci-mxc.c                        |  20 -
 drivers/usb/host/ehci-omap.c                       |  10 +-
 drivers/usb/host/ehci-s5p.c                        |  83 +-
 drivers/usb/host/isp1760-hcd.c                     |   4 +-
 drivers/usb/host/ohci-exynos.c                     |  87 +-
 drivers/usb/host/ohci-q.c                          |   1 +
 drivers/usb/host/uhci-debug.c                      | 178 ++--
 drivers/usb/host/uhci-hcd.c                        |  31 +-
 drivers/usb/host/uhci-hcd.h                        |   4 -
 drivers/usb/host/uhci-hub.c                        |   4 +-
 drivers/usb/host/uhci-q.c                          |   2 +-
 drivers/usb/host/xhci-ring.c                       |   2 -
 drivers/usb/misc/Kconfig                           |   6 +
 drivers/usb/misc/Makefile                          |   1 +
 drivers/usb/misc/usb3503.c                         | 325 +++++++
 drivers/usb/misc/usbtest.c                         |  13 +-
 drivers/usb/musb/Kconfig                           |   2 +
 drivers/usb/musb/am35x.c                           |   2 +-
 drivers/usb/musb/blackfin.c                        |   2 +-
 drivers/usb/musb/da8xx.c                           |   7 +-
 drivers/usb/musb/davinci.c                         |   7 +-
 drivers/usb/musb/musb_core.c                       |   1 +
 drivers/usb/musb/musb_dsps.c                       |   3 +-
 drivers/usb/musb/musb_gadget.c                     |  22 +-
 drivers/usb/musb/musb_host.c                       |  44 +-
 drivers/usb/musb/omap2430.c                        |  91 +-
 drivers/usb/musb/omap2430.h                        |   9 -
 drivers/usb/musb/tusb6010.c                        |   2 +-
 drivers/usb/musb/ux500.c                           |  12 +-
 drivers/usb/otg/mv_otg.c                           |  84 +-
 drivers/usb/otg/mxs-phy.c                          |  20 +
 drivers/usb/otg/otg.c                              | 235 +++++-
 drivers/usb/otg/twl4030-usb.c                      |   3 +-
 drivers/usb/phy/Kconfig                            |  28 +
 drivers/usb/phy/Makefile                           |   3 +
 drivers/usb/phy/omap-control-usb.c                 | 295 +++++++
 drivers/usb/phy/omap-usb2.c                        |  72 +-
 drivers/usb/phy/omap-usb3.c                        | 355 ++++++++
 drivers/usb/phy/samsung-usbphy.c                   | 930 +++++++++++++++++++++
 drivers/usb/renesas_usbhs/Kconfig                  |   2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |   2 +-
 drivers/usb/serial/Kconfig                         |  12 +
 drivers/usb/serial/Makefile                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |  20 +-
 drivers/usb/serial/io_ti.c                         |  89 +-
 drivers/usb/serial/keyspan.c                       |   4 +-
 drivers/usb/serial/mct_u232.c                      |  22 +-
 drivers/usb/serial/option.c                        |  16 +-
 drivers/usb/serial/quatech2.c                      |  18 +-
 drivers/usb/serial/sierra.c                        |   8 +-
 drivers/usb/serial/ssu100.c                        |  19 +-
 drivers/usb/serial/usb-serial.c                    |  28 +-
 drivers/usb/serial/usb_wwan.c                      |   8 +-
 drivers/usb/serial/xsens_mt.c                      |  86 ++
 drivers/usb/storage/initializers.c                 |   4 +-
 drivers/usb/storage/uas.c                          | 124 ++-
 drivers/usb/storage/unusual_cypress.h              |   2 +-
 drivers/usb/storage/usb.c                          |   3 +
 drivers/usb/wusbcore/wa-xfer.c                     |   6 +-
 include/linux/platform_data/samsung-usbphy.h       |  27 +
 include/linux/platform_data/usb3503.h              |  19 +
 include/linux/usb/composite.h                      |  75 +-
 include/linux/usb/dwc3-omap.h                      |  30 +
 include/linux/usb/gadget.h                         |  13 +-
 include/linux/usb/musb.h                           |   2 +
 include/linux/usb/omap_control_usb.h               |  92 ++
 include/linux/usb/omap_usb.h                       |  27 +-
 include/linux/usb/phy.h                            |  43 +
 include/linux/usb/samsung_usb_phy.h                |  16 +
 tools/usb/testusb.c                                |  31 +-
 175 files changed, 6383 insertions(+), 2515 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt
 create mode 100644 Documentation/devicetree/bindings/usb/samsung-usbphy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/usb3503.txt
 create mode 100644 drivers/usb/core/hub.h
 create mode 100644 drivers/usb/core/port.c
 create mode 100644 drivers/usb/gadget/functions.c
 create mode 100644 drivers/usb/misc/usb3503.c
 create mode 100644 drivers/usb/phy/omap-control-usb.c
 create mode 100644 drivers/usb/phy/omap-usb3.c
 create mode 100644 drivers/usb/phy/samsung-usbphy.c
 create mode 100644 drivers/usb/serial/xsens_mt.c
 create mode 100644 include/linux/platform_data/samsung-usbphy.h
 create mode 100644 include/linux/platform_data/usb3503.h
 create mode 100644 include/linux/usb/dwc3-omap.h
 create mode 100644 include/linux/usb/omap_control_usb.h
 create mode 100644 include/linux/usb/samsung_usb_phy.h
