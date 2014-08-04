Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaHDTLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:11:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaHDTLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:11:32 -0400
Date: Mon, 4 Aug 2014 12:11:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver patches for 3.17-rc1
Message-ID: <20140804191130.GA27534@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.17-rc1

for you to fetch changes up to d310d05f1225d1f6f2bf505255fdf593bfbb3051:

  USB: devio: fix issue with log flooding (2014-08-01 16:01:46 -0700)

----------------------------------------------------------------
USB patches for 3.17-rc1

Here is the big USB driver update for 3.17-rc1.

Loads of gadget driver changes in here, including some big file
movements to make things easier to manage over time.  There's also the
usual xhci and uas driver updates, and a handful of other changes in
here.  The changelog has the full details.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (10):
      USB: shutdown all URBs after controller death
      USB: OHCI: add SG support
      USB: OHCI: fix bugs in debug routines
      USB: OHCI: don't lose track of EDs when a controller dies
      USB: OHCI: revert the ZF Micro orphan-TD quirk
      USB: OHCI: no shortcut for unlinking URBS from a dead controller
      USB: OHCI: redesign the TD done list
      USB: OHCI: make URB completions single-threaded
      USB: OHCI: add I/O watchdog for orphan TDs
      USB: OHCI: add check for stopped frame counter

Alexey Khoroshilov (1):
      usb: host: max3421-hcd: unconditionally use GFP_ATOMIC in max3421_urb_enqueue()

Amit Virdi (1):
      usb: core: allow zero packet flag for interrupt urbs

Andrew Lunn (1):
      phy: Remove ARCH_KIRKWOOD dependency

Andrzej Pietrasiewicz (8):
      usb: gadget: f_fs: rename descriptor parsing functions
      usb: gadget: u_os_desc: helper functions for accessing ext prop buffer
      usb: gadget: f_fs: OS descriptors support
      usb: gadget: Gadget directory cleanup - group legacy gadgets
      usb: gadget: Gadget directory cleanup - group UDC drivers
      usb: gadget: Gadget directory cleanup - group usb functions
      usb: gadget: f_rndis: fix interface id for OS descriptors
      Documentation: DocBook: elieminate doc build break

Antoine Ténart (2):
      phy: add a driver for the Berlin SATA PHY
      Documentation: bindings: add the Berlin SATA PHY

Apelete Seketeli (1):
      usb: musb: register nop transceiver driver for jz4740

Arnd Bergmann (1):
      usb: gadget: pxa25x_udc: use correct header for gpio devm_ functions

Ben Dooks (8):
      usb: gadget: r8a66597-udc: use devm_ioremap_resource() for registers
      usb: gadget: r8a66597-udc: keep dev as reference to &pdev->dev
      usb: gadget: r8a66597-udc: use devm_kzalloc() to allocate driver state
      usb: gadget: r8a66597-udc: handle sudmac registers with devm_ioremap_resource()
      usb: gadget: r8a66597-udc: cleanup error path
      usb: gadget: r8a66597-udc: use devm_clk_get() to get clock
      usb: gadget: r8a66597-udc: use devm_request_irq() to get device irq
      usb: gadget: r8a66597-udc: remove now unused clean_up and clean_up3 label.

Benoit Taine (1):
      usb: gadget: Use kmemdup instead of kmalloc + memcpy

Bryan O'Donoghue (1):
      USB: ehci-pci: USB host controller support for Intel Quark X1000

Dan Williams (1):
      usb: force warm reset to break link re-connect livelock

Daniel Mack (8):
      usb: musb: remove unnecessary (void) prefix at function calls
      usb: musb: use is_host_active() to distinguish between host and gadget mode
      usb: musb: fix bit mask for CSR in musb_h_tx_flush_fifo()
      usb: musb: introduce dma_channel.rx_packet_done
      usb: musb/cppi41: call musb_ep_select() before accessing an endpoint's CSR
      usb: musb: fix wrong indentation in musb_host.c
      Revert "usb: musb: musb_cppi41: Handle ISOCH differently and not use the hrtimer."
      usb: musb: cppi41: fire hrtimer according to programmed channel length

David Mosberger-Tang (2):
      usb: host: max3421-hcd: Use atomic bitops in lieu of bit fields
      usb: host: max3421-hcd: Fix max3421_reset_port() to set USB_PORT_STAT_RESET

Fabian Frederick (3):
      USB: mos7840: remove unnecessary null test before kfree
      drivers/usb/host/fhci-dbg.c: remove unnecessary null test before debugfs_remove
      drivers/usb/serial/mos7840.c: remove unnecessary null test before kfree

Felipe Balbi (3):
      usb: gadget: udc: fsl_udc_core: fix sparse errors
      usb: gadget: udc: net2280: fix sparse error
      usb: gadget: udc: fsl_mxc_udc: fix sparse error

George Cherian (9):
      usb: musb: dsps: Call usb_phy(_shutdown/_init) during musb_platform_reset()
      usb: dwc3: omap: remove x_major calculation from revision register
      usb: dwc3: omap: add dwc3_omap_map_offset() function
      usb: dwc3: omap: add dwc3_omap_set_utmi_mode() function
      usb: dwc3: omap: add dwc3_omap_extcon_register function
      usb: musb: core: Handle Babble condition only in HOST mode
      usb: musb: core: Convert babble recover work to delayed work
      usb: musb: core: Convert the musb_platform_reset to have a return value.
      usb: musb: dsps: Add the sw_babble_control() and Enable for newer silicon

Greg Kroah-Hartman (5):
      Merge 3.16-rc4 into usb-next
      Merge 3.16-rc5 into usb-next
      Merge tag 'usb-serial-3.17-rc1' of git://git.kernel.org/.../johan/usb-serial into usb-next
      Merge tag 'usb-for-v3.17' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'for_3.17' of git://git.kernel.org/.../kishon/linux-phy into usb-next

Hans de Goede (6):
      uas: Limit qdepth to 32 when connected over usb-2
      xhci: Blacklist using streams on the Etron EJ168 controller
      xhci: Rename Asrock P67 pci product-id to EJ168
      xhci: Add missing checks for xhci_alloc_command failure
      uas: Only complain about missing sg if all other checks succeed
      uas: Log a warning when we cannot use uas because the hcd lacks streams

Himangi Saraogi (12):
      usb: gadget: pxa25x_udc: use devm_ functions
      usb: musb: ux500: use devm_ functions
      usb: gadget: fsl_qe_udc: Introduce use of managed version of kzalloc
      usb: phy: phy-gpio-vbus-usb: use devm_ functions
      usb: musb: davinci: use devm_ functions.
      usb: musb: tusb6010: Introduce the use of the managed version of kzalloc
      usb: musb: backfin: Introduce the use of the managed version of kzalloc
      usb: host: xhci-plat: use devm_functions
      USB: oxu210hp-hcd.c: use devm_ functions
      usb: host: uhci-grlib.c : use devm_ functions
      uhci-platform: use devm_ioremap resource
      fotg210: Use managed interfaces for allocation of resources

James P Michels III (1):
      usb-core bInterval quirk

Jeremiah Mahler (1):
      usb: doc: hotplug.txt code typos

Jiancheng Xue (2):
      Documentation: Document Hisilicon hix5hd2 sata PHY
      phy: add hix5hd2-sata-phy driver

Jiang Liu (1):
      USB: core: hcd-pci: free IRQ before disabling PCI device when shutting down

Jim Baxter (3):
      usb: gadget: NCM: RX function support multiple NDPs
      usb: gadget: NCM: Add transmit multi-frame.
      usb: gadget: NCM: Stop RX TCP Bursts getting dropped.

Jingoo Han (14):
      usb: phy: msm: Make of_device_id array const
      usb: phy: tegra: Make of_device_id array const
      usb: gadget: gr_udc: Make of_device_id array const
      usb: gadget: lpc32xx_udc: Make of_device_id array const
      usb: dwc2: gadget: fix checkpatch errors
      usb: dwc2: gadget: remove unnecessary OOM messages
      usb: dwc2: gadget: remove incorrect file reference
      USB: ehci-msm: Make of_device_id array const
      USB: ohci-spear: Make of_device_id array const
      USB: ehci-tegra: Make of_device_id array const
      USB: ehci-spear: Make of_device_id array const
      usb: phy: am335x: Use SIMPLE_DEV_PM_OPS macro
      usb: dwc3: gadget: remove unnecessary 'start_new' variable
      phy: exynos5-usbdrd: Make local functions static

Johan Hovold (4):
      USB: ftdi_sio: make port probe less verbose
      USB: ftdi_sio: fix max-packet-size warning
      USB: ftdi_sio: clean up ftdi_set_max_packet_size()
      USB: ftdi_sio: remove redundant mtxorb quirk

Joonyoung Shim (2):
      usb: usb3503: add PM functions
      USB: add reset resume quirk for usb3503

Julia Lawall (1):
      uwb/whci: use correct structure type name in sizeof

Julius Werner (1):
      usb: xhci: Correct last context entry calculation for Configure Endpoint

Kamil Debski (1):
      phy: phy-samsung-usb2: Change phy power on/power off sequence

Kishon Vijay Abraham I (4):
      phy: phy-omap-pipe3: Add support for PCIe PHY
      phy: pipe3: insert delay to enumerate in GEN2 mode
      phy: core: Fix of_phy_provider_lookup to return PHY provider for sub node
      phy: core: Let node ptr of PHY point to PHY and not of PHY provider

Krzysztof Opasiak (1):
      usb: gadget: FunctionFS: Return -ENOENT instead of -ENODEV when device not found.

Kumar Gala (2):
      phy: qcom: Add driver for QCOM IPQ806x SATA PHY
      phy: qcom: Add device tree bindings for IPQ806x SATA PHY

Lan Tianyu (1):
      usb: documentation for usb port power off mechanisms

Lee Jones (4):
      phy: miphy365x: Add MiPHY365x header file for DT x Driver defines
      phy: miphy365x: Add Device Tree bindings for the MiPHY365x
      phy: miphy365x: Provide support for the MiPHY356x Generic PHY
      phy: miphy365x: Represent each PHY channel as a DT subnode

Li Jun (1):
      usb: gadget: composite: dequeue cdev->req before free it in composite_dev_cleanup

Lothar Waßmann (1):
      usb: musb: dsps: coding style cleanup

Marek Szyprowski (1):
      drivers: phy: exynos-usb2: add support for Exynos 3250

Markus Pargmann (2):
      usb: ci_hdrc_imx: Return -EINVAL for missing USB PHY
      usb: ci_hdrc_imx doc: fsl,usbphy is required

Mickael Maison (1):
      USB: gadget: Fixed a few typos in comments

Nathan Sullivan (1):
      usb: gadget: fix eem_wrap cloned skb logic

Nicholas Krause (1):
      usb-core: Remove Fix mes in file hcd.c

Oliver Neukum (3):
      xhci: make error messages grepable
      usbcore: don't log on consecutive debounce failures of the same port
      USB: devio: fix issue with log flooding

Patrick Riphagen (2):
      USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
      USB: serial: ftdi_sio: Add support for new Xsens devices

Paul Bolle (1):
      Documentation: sysfs-bus-usb: update power/persist description

Paul Zimmerman (1):
      usb: dwc3: add support for USB 2.0-only core configuration

Peter Chen (11):
      usb: gadget: atmel_usba_udc: delete __init marker for probe
      usb: gadget: fsl_udc_core: delete __init marker for probe
      usb: gadget: lpc32xx: delete __init marker for probe
      usb: gadget: m66592-udc: delete __init marker for probe
      usb: gadget: fusb300_udc: delete __init marker for probe
      usb: gadget: r8a66597-udc: delete __init marker for probe
      usb: gadget: fsl_udc_core: should not call gadget driver's .unbind
      usb: gadget: fusb300_udc: should not call gadget driver's .unbind
      usb: gadget: m66592-udc: should not call gadget driver's .unbind
      usb: gadget: net2272: do not need to judge gadget driver's .unbind
      usb: gadget: omap_udc: should not call gadget driver's .unbind

Peter Senna Tschudin (2):
      USB: kl5kusb105: Remove klsi_105_tiocmset function
      USB: kl5kusb105: Remove klsi_105_tiocmset function

Pratyush Anand (9):
      xhci: A default implementation for Ux timeout calculation and tier policy check
      xhci: Platform: Add (en/dis)able_usb3_lpm_timeout
      xhci: Platform: Set xhci lpm support quirk based on platform data
      dwc3: host: Enable USB3 LPM capability
      usb: allow lpm (en/dis)able only if device is atleast in default state
      USB: Add EXPORT_SYMBOL for usb_alloc_dev
      USB: Add LVS Test device driver
      USB: Fix persist resume of some SS USB devices
      usb: lvstest: Fix sparse warnings generated by kbuild test bot

Preston Fick (1):
      USB: serial: cp210x: Removing unncessary `usb_reset_device` on startup

Ricardo Ribalda Delgado (11):
      usb: gadget: net2280: Add support for PLX USB338X
      usb: gadget: net2280: Dont use magic numbers
      usb: gadget: net2280: Use BIT() macro
      usb: gadget: net2280: Use true/false instead of 1/0
      usb: gadget: net2280: Use module_pci_driver macro
      usb: gadget: net2280: Refactor queues_show
      usb: gadget: net2280: Pass checkpacth.pl test
      usb: gadget: net2280: Code Cleanup
      usb: gadget: net2280: Use pr_* function
      usb: gadget: net2280: Use quirks instead of pci id
      usb: gadget: net2280: Fix typo on #ifdef

Rickard Strandqvist (2):
      usb: musb: musb_host.c: Cleaning up uninitialized variables
      usb: class: usbtmc.c: Cleaning up uninitialized variables

Robert Baldyga (3):
      tools: ffs-aio-example: fix header values endianess
      tools: ffs-aio-example: convert to new descriptor format
      tools: ffs-aio-example: add license information

Robert Jarzmik (1):
      usb: gadget: pxa27x_udc: prepare and unprepare the clock

Roger Quadros (2):
      phy: core: Support regulator supply for PHY power
      phy: core: Add phy-supply to DT binding documentation

Sachin Kamat (7):
      usb: ohci-exynos: Use NULL instead of 0
      usb: ehci-exynos: Use NULL instead of 0
      phy: exynos-dp-video: Use PTR_ERR_OR_ZERO
      phy: exynos-mipi-video: Use PTR_ERR_OR_ZERO
      phy: sun4i-usb: Use PTR_ERR_OR_ZERO
      phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
      phy: Kconfig: Update config for Exynos USB DRD

Sebastian Reimers (1):
      usb: gadget: f_uac2: Fix pcm sample size selection

Srinivas Kandagatla (4):
      usb: phy: msm: Make phy_reset clk and reset line optional.
      phy: qcom: Add driver for QCOM APQ8064 SATA PHY
      phy: qcom: Add APQ8064 SATA PHY device tree bindings
      phy: qcom-apq8064: fix possible timeout without check

Thierry Reding (2):
      usb: phy: tegra: Do not include asm/mach-types.h
      usb: phy: tegra: Do not include asm/mach-types.h

Tobias Klauser (2):
      usb: gadget: Add helper macro for usb_composite_driver boilerplate
      usb: gadget: Convert drivers to use module_usb_composite_driver()

Tuomas Tynkkynen (5):
      USB: EHCI: tegra: Fix use-after-free in .remove()
      USB: tegra: Add resets & has-utmi-pad-registers flag to the PHY binding
      ARM: tegra: Add resets & has-utmi-pad-registers flag to all USB PHYs
      USB: EHCI: tegra: Fix probe order issue leading to broken USB
      USB: PHY: tegra: Call tegra_usb_phy_close only on device removal

Tushar Behera (1):
      usb: misc: usb3503: Update error code in print message

Ulrich Hecht (1):
      usb: renesas_usbhs: add R-Car Gen. 2 init and power control

Vasily Khoruzhick (1):
      usb: gadget: s3c2410: Move to clk_prepare_enable/clk_disable_unprepare

Vivek Gautam (1):
      usb: dwc3: Keeping 'resource' related code together

Vladimir Zapolskiy (3):
      USB: EHCI: don't allocate hardware periodic table atomically by default
      USB: UHCI: don't allocate frame list atomically
      USB: OHCI: don't allocate HCCA atomically

Wei Yongjun (1):
      usb: chipidea: debug: fix sparse non static symbol warnings

Yoshihiro Shimoda (3):
      usb: host: xhci-plat: add support for the R-Car H2 and M2 xHCI controllers
      usb: renesas_usbhs: fix usbhs_pipe_malloc() to re-enable a pipe.
      usb: renesas_usbhs: gadget: fix re-enabling pipe without re-connecting

 Documentation/ABI/stable/sysfs-bus-usb             |   14 +-
 Documentation/ABI/testing/sysfs-bus-usb-lvstest    |   47 +
 Documentation/DocBook/gadget.tmpl                  |   10 +-
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |   34 +
 .../devicetree/bindings/phy/hix5hd2-phy.txt        |   22 +
 .../devicetree/bindings/phy/phy-bindings.txt       |    4 +
 .../devicetree/bindings/phy/phy-miphy365x.txt      |   76 +
 .../bindings/phy/qcom-apq8064-sata-phy.txt         |   24 +
 .../bindings/phy/qcom-ipq806x-sata-phy.txt         |   23 +
 .../devicetree/bindings/phy/samsung-phy.txt        |    2 +
 Documentation/devicetree/bindings/phy/ti-phy.txt   |   23 +-
 .../devicetree/bindings/usb/ci-hdrc-imx.txt        |    2 +-
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |    8 +
 Documentation/devicetree/bindings/usb/usb-xhci.txt |    3 +-
 Documentation/phy.txt                              |   10 +-
 Documentation/usb/hotplug.txt                      |    8 +-
 Documentation/usb/power-management.txt             |  245 +-
 arch/arm/boot/dts/tegra114.dtsi                    |    5 +
 arch/arm/boot/dts/tegra124.dtsi                    |    7 +
 arch/arm/boot/dts/tegra20.dtsi                     |    7 +
 arch/arm/boot/dts/tegra30.dtsi                     |    7 +
 drivers/phy/Kconfig                                |   78 +-
 drivers/phy/Makefile                               |    5 +
 drivers/phy/phy-bcm-kona-usb2.c                    |    2 +-
 drivers/phy/phy-berlin-sata.c                      |  284 ++
 drivers/phy/phy-core.c                             |   56 +-
 drivers/phy/phy-exynos-dp-video.c                  |    7 +-
 drivers/phy/phy-exynos-mipi-video.c                |    7 +-
 drivers/phy/phy-exynos4x12-usb2.c                  |  125 +-
 drivers/phy/phy-exynos5-usbdrd.c                   |    9 +-
 drivers/phy/phy-exynos5250-sata.c                  |    2 +-
 drivers/phy/phy-exynos5250-usb2.c                  |    2 -
 drivers/phy/phy-hix5hd2-sata.c                     |  192 +
 drivers/phy/phy-miphy365x.c                        |  636 ++++
 drivers/phy/phy-mvebu-sata.c                       |    2 +-
 drivers/phy/phy-omap-control.c                     |   52 +-
 drivers/phy/phy-omap-usb2.c                        |    2 +-
 drivers/phy/phy-qcom-apq8064-sata.c                |  289 ++
 drivers/phy/phy-qcom-ipq806x-sata.c                |  211 ++
 drivers/phy/phy-samsung-usb2.c                     |    9 +-
 drivers/phy/phy-samsung-usb2.h                     |    5 +-
 drivers/phy/phy-sun4i-usb.c                        |    7 +-
 drivers/phy/phy-ti-pipe3.c                         |  107 +-
 drivers/phy/phy-twl4030-usb.c                      |    2 +-
 drivers/phy/phy-xgene.c                            |    2 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |    3 +
 drivers/usb/chipidea/debug.c                       |    4 +-
 drivers/usb/class/usbtmc.c                         |    2 +-
 drivers/usb/core/config.c                          |   11 +
 drivers/usb/core/devio.c                           |    2 +-
 drivers/usb/core/driver.c                          |    7 +-
 drivers/usb/core/hcd-pci.c                         |    2 +
 drivers/usb/core/hcd.c                             |    4 -
 drivers/usb/core/hub.c                             |   94 +-
 drivers/usb/core/hub.h                             |    2 +
 drivers/usb/core/port.c                            |   21 +-
 drivers/usb/core/quirks.c                          |    7 +
 drivers/usb/core/urb.c                             |    1 +
 drivers/usb/core/usb.c                             |    1 +
 drivers/usb/dwc2/gadget.c                          |   12 +-
 drivers/usb/dwc3/Kconfig                           |    7 +
 drivers/usb/dwc3/core.c                            |   51 +-
 drivers/usb/dwc3/core.h                            |   13 +
 drivers/usb/dwc3/dwc3-omap.c                       |  172 +-
 drivers/usb/dwc3/gadget.c                          |    7 +-
 drivers/usb/dwc3/host.c                            |   14 +
 drivers/usb/gadget/Kconfig                         |  824 +----
 drivers/usb/gadget/Makefile                        |  101 +-
 drivers/usb/gadget/composite.c                     |    1 +
 drivers/usb/gadget/configfs.c                      |    4 +-
 drivers/usb/gadget/function/Makefile               |   34 +
 drivers/usb/gadget/{ => function}/f_acm.c          |    0
 drivers/usb/gadget/{ => function}/f_ecm.c          |    0
 drivers/usb/gadget/{ => function}/f_eem.c          |   22 +-
 drivers/usb/gadget/{ => function}/f_fs.c           |  352 +-
 drivers/usb/gadget/{ => function}/f_hid.c          |    0
 drivers/usb/gadget/{ => function}/f_loopback.c     |    0
 drivers/usb/gadget/{ => function}/f_mass_storage.c |    0
 drivers/usb/gadget/{ => function}/f_mass_storage.h |    0
 drivers/usb/gadget/{ => function}/f_midi.c         |    0
 drivers/usb/gadget/{ => function}/f_ncm.c          |  480 ++-
 drivers/usb/gadget/{ => function}/f_obex.c         |    0
 drivers/usb/gadget/{ => function}/f_phonet.c       |    0
 drivers/usb/gadget/{ => function}/f_rndis.c        |    4 +
 drivers/usb/gadget/{ => function}/f_serial.c       |    0
 drivers/usb/gadget/{ => function}/f_sourcesink.c   |    0
 drivers/usb/gadget/{ => function}/f_subset.c       |    0
 drivers/usb/gadget/{ => function}/f_uac1.c         |    0
 drivers/usb/gadget/{ => function}/f_uac2.c         |   24 +-
 drivers/usb/gadget/{ => function}/f_uvc.c          |    0
 drivers/usb/gadget/{ => function}/f_uvc.h          |    0
 drivers/usb/gadget/{ => function}/g_zero.h         |    0
 drivers/usb/gadget/{ => function}/ndis.h           |    0
 drivers/usb/gadget/{ => function}/rndis.c          |    0
 drivers/usb/gadget/{ => function}/rndis.h          |    0
 drivers/usb/gadget/{ => function}/storage_common.c |    0
 drivers/usb/gadget/{ => function}/storage_common.h |    0
 drivers/usb/gadget/{ => function}/u_ecm.h          |    0
 drivers/usb/gadget/{ => function}/u_eem.h          |    0
 drivers/usb/gadget/{ => function}/u_ether.c        |   19 +-
 drivers/usb/gadget/{ => function}/u_ether.h        |    2 +
 .../usb/gadget/{ => function}/u_ether_configfs.h   |    0
 drivers/usb/gadget/{ => function}/u_fs.h           |    7 +
 drivers/usb/gadget/{ => function}/u_gether.h       |    0
 drivers/usb/gadget/{ => function}/u_ncm.h          |    0
 drivers/usb/gadget/{ => function}/u_phonet.h       |    0
 drivers/usb/gadget/{ => function}/u_rndis.h        |    0
 drivers/usb/gadget/{ => function}/u_serial.c       |    0
 drivers/usb/gadget/{ => function}/u_serial.h       |    0
 drivers/usb/gadget/{ => function}/u_uac1.c         |    0
 drivers/usb/gadget/{ => function}/u_uac1.h         |    0
 drivers/usb/gadget/{ => function}/uvc.h            |    0
 drivers/usb/gadget/{ => function}/uvc_queue.c      |    0
 drivers/usb/gadget/{ => function}/uvc_queue.h      |    0
 drivers/usb/gadget/{ => function}/uvc_v4l2.c       |    0
 drivers/usb/gadget/{ => function}/uvc_video.c      |    0
 drivers/usb/gadget/legacy/Kconfig                  |  475 +++
 drivers/usb/gadget/legacy/Makefile                 |   44 +
 drivers/usb/gadget/{ => legacy}/acm_ms.c           |   14 +-
 drivers/usb/gadget/{ => legacy}/audio.c            |   12 +-
 drivers/usb/gadget/{ => legacy}/cdc2.c             |   14 +-
 drivers/usb/gadget/{ => legacy}/dbgp.c             |    0
 drivers/usb/gadget/{ => legacy}/ether.c            |   14 +-
 drivers/usb/gadget/{ => legacy}/g_ffs.c            |    2 +-
 drivers/usb/gadget/{ => legacy}/gmidi.c            |   13 +-
 drivers/usb/gadget/{ => legacy}/hid.c              |    0
 drivers/usb/gadget/{ => legacy}/inode.c            |    0
 drivers/usb/gadget/{ => legacy}/mass_storage.c     |    0
 drivers/usb/gadget/{ => legacy}/multi.c            |   13 +-
 drivers/usb/gadget/{ => legacy}/ncm.c              |   14 +-
 drivers/usb/gadget/{ => legacy}/nokia.c            |   12 +-
 drivers/usb/gadget/{ => legacy}/printer.c          |    0
 drivers/usb/gadget/{ => legacy}/serial.c           |    0
 drivers/usb/gadget/{ => legacy}/tcm_usb_gadget.c   |    0
 drivers/usb/gadget/{ => legacy}/tcm_usb_gadget.h   |    0
 drivers/usb/gadget/{ => legacy}/webcam.c           |   15 +-
 drivers/usb/gadget/{ => legacy}/zero.c             |   14 +-
 drivers/usb/gadget/net2280.c                       | 2905 ---------------
 drivers/usb/gadget/net2280.h                       |  308 --
 drivers/usb/gadget/u_os_desc.h                     |   59 +-
 drivers/usb/gadget/udc/Kconfig                     |  385 ++
 drivers/usb/gadget/udc/Makefile                    |   31 +
 drivers/usb/gadget/{ => udc}/amd5536udc.c          |    0
 drivers/usb/gadget/{ => udc}/amd5536udc.h          |    0
 drivers/usb/gadget/{ => udc}/at91_udc.c            |    0
 drivers/usb/gadget/{ => udc}/at91_udc.h            |    0
 drivers/usb/gadget/{ => udc}/atmel_usba_udc.c      |    2 +-
 drivers/usb/gadget/{ => udc}/atmel_usba_udc.h      |    0
 drivers/usb/gadget/{ => udc}/bcm63xx_udc.c         |    0
 drivers/usb/gadget/{ => udc}/dummy_hcd.c           |    0
 drivers/usb/gadget/{ => udc}/fotg210-udc.c         |    0
 drivers/usb/gadget/{ => udc}/fotg210.h             |    0
 drivers/usb/gadget/{ => udc}/fsl_mxc_udc.c         |    2 +
 drivers/usb/gadget/{ => udc}/fsl_qe_udc.c          |   19 +-
 drivers/usb/gadget/{ => udc}/fsl_qe_udc.h          |    0
 drivers/usb/gadget/{ => udc}/fsl_udc_core.c        |   19 +-
 drivers/usb/gadget/{ => udc}/fsl_usb2_udc.h        |    3 +
 drivers/usb/gadget/{ => udc}/fusb300_udc.c         |    4 +-
 drivers/usb/gadget/{ => udc}/fusb300_udc.h         |    0
 drivers/usb/gadget/{ => udc}/gadget_chips.h        |    0
 drivers/usb/gadget/{ => udc}/goku_udc.c            |    0
 drivers/usb/gadget/{ => udc}/goku_udc.h            |    0
 drivers/usb/gadget/{ => udc}/gr_udc.c              |    2 +-
 drivers/usb/gadget/{ => udc}/gr_udc.h              |    0
 drivers/usb/gadget/{ => udc}/lpc32xx_udc.c         |    7 +-
 drivers/usb/gadget/{ => udc}/m66592-udc.c          |    4 +-
 drivers/usb/gadget/{ => udc}/m66592-udc.h          |    0
 drivers/usb/gadget/{ => udc}/mv_u3d.h              |    0
 drivers/usb/gadget/{ => udc}/mv_u3d_core.c         |    0
 drivers/usb/gadget/{ => udc}/mv_udc.h              |    0
 drivers/usb/gadget/{ => udc}/mv_udc_core.c         |    4 +-
 drivers/usb/gadget/{ => udc}/net2272.c             |    2 +-
 drivers/usb/gadget/{ => udc}/net2272.h             |    0
 drivers/usb/gadget/udc/net2280.c                   | 3827 ++++++++++++++++++++
 drivers/usb/gadget/udc/net2280.h                   |  403 +++
 drivers/usb/gadget/{ => udc}/omap_udc.c            |    5 +-
 drivers/usb/gadget/{ => udc}/omap_udc.h            |    0
 drivers/usb/gadget/{ => udc}/pch_udc.c             |    0
 drivers/usb/gadget/{ => udc}/pxa25x_udc.c          |   75 +-
 drivers/usb/gadget/{ => udc}/pxa25x_udc.h          |    0
 drivers/usb/gadget/{ => udc}/pxa27x_udc.c          |    6 +
 drivers/usb/gadget/{ => udc}/pxa27x_udc.h          |    0
 drivers/usb/gadget/{ => udc}/r8a66597-udc.c        |   92 +-
 drivers/usb/gadget/{ => udc}/r8a66597-udc.h        |    0
 drivers/usb/gadget/{ => udc}/s3c-hsudc.c           |    0
 drivers/usb/gadget/{ => udc}/s3c2410_udc.c         |    8 +-
 drivers/usb/gadget/{ => udc}/s3c2410_udc.h         |    0
 drivers/usb/gadget/{ => udc}/udc-core.c            |    0
 drivers/usb/host/Kconfig                           |    8 +
 drivers/usb/host/Makefile                          |    3 +
 drivers/usb/host/ehci-exynos.c                     |    2 +-
 drivers/usb/host/ehci-mem.c                        |    2 +-
 drivers/usb/host/ehci-msm.c                        |    2 +-
 drivers/usb/host/ehci-pci.c                        |   25 +
 drivers/usb/host/ehci-spear.c                      |    2 +-
 drivers/usb/host/ehci-tegra.c                      |   67 +-
 drivers/usb/host/fhci-dbg.c                        |    8 +-
 drivers/usb/host/fotg210-hcd.c                     |   48 +-
 drivers/usb/host/max3421-hcd.c                     |   48 +-
 drivers/usb/host/ohci-dbg.c                        |    9 +-
 drivers/usb/host/ohci-exynos.c                     |    2 +-
 drivers/usb/host/ohci-hcd.c                        |  381 +-
 drivers/usb/host/ohci-hub.c                        |   11 +-
 drivers/usb/host/ohci-mem.c                        |    1 +
 drivers/usb/host/ohci-q.c                          |  262 +-
 drivers/usb/host/ohci-spear.c                      |    2 +-
 drivers/usb/host/ohci.h                            |   23 +-
 drivers/usb/host/oxu210hp-hcd.c                    |   48 +-
 drivers/usb/host/uhci-grlib.c                      |   31 +-
 drivers/usb/host/uhci-hcd.c                        |    2 +-
 drivers/usb/host/uhci-platform.c                   |   22 +-
 drivers/usb/host/xhci-pci.c                        |    8 +-
 drivers/usb/host/xhci-plat.c                       |   52 +-
 drivers/usb/host/xhci-rcar.c                       |  148 +
 drivers/usb/host/xhci-rcar.h                       |   27 +
 drivers/usb/host/xhci-ring.c                       |    4 +
 drivers/usb/host/xhci.c                            |  160 +-
 drivers/usb/host/xhci.h                            |    2 +
 drivers/usb/misc/Kconfig                           |    7 +
 drivers/usb/misc/Makefile                          |    1 +
 drivers/usb/misc/lvstest.c                         |  460 +++
 drivers/usb/misc/usb3503.c                         |   37 +-
 drivers/usb/musb/blackfin.c                        |   20 +-
 drivers/usb/musb/davinci.c                         |   20 +-
 drivers/usb/musb/jz4740.c                          |    3 +
 drivers/usb/musb/musb_core.c                       |   41 +-
 drivers/usb/musb/musb_core.h                       |   12 +-
 drivers/usb/musb/musb_cppi41.c                     |   70 +-
 drivers/usb/musb/musb_dma.h                        |    1 +
 drivers/usb/musb/musb_dsps.c                       |  104 +-
 drivers/usb/musb/musb_host.c                       |   19 +-
 drivers/usb/musb/musb_regs.h                       |    7 +
 drivers/usb/musb/tusb6010.c                        |   16 +-
 drivers/usb/musb/ux500.c                           |   28 +-
 drivers/usb/phy/phy-am335x.c                       |   12 +-
 drivers/usb/phy/phy-gpio-vbus-usb.c                |   45 +-
 drivers/usb/phy/phy-msm-usb.c                      |   12 +-
 drivers/usb/phy/phy-tegra-usb.c                    |   11 +-
 drivers/usb/renesas_usbhs/Makefile                 |    2 +-
 drivers/usb/renesas_usbhs/common.c                 |   66 +-
 drivers/usb/renesas_usbhs/common.h                 |    2 +
 drivers/usb/renesas_usbhs/mod_gadget.c             |    2 +
 drivers/usb/renesas_usbhs/pipe.c                   |   11 +
 drivers/usb/renesas_usbhs/pipe.h                   |    1 +
 drivers/usb/renesas_usbhs/rcar2.c                  |   77 +
 drivers/usb/renesas_usbhs/rcar2.h                  |    4 +
 drivers/usb/serial/cp210x.c                        |    3 -
 drivers/usb/serial/ftdi_sio.c                      |   84 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |   13 +-
 drivers/usb/serial/kl5kusb105.c                    |   30 -
 drivers/usb/serial/mos7840.c                       |    5 +-
 drivers/usb/storage/uas-detect.h                   |   40 +-
 drivers/usb/storage/uas.c                          |    2 +-
 drivers/uwb/whci.c                                 |    2 +-
 include/dt-bindings/phy/phy-miphy365x.h            |   14 +
 include/linux/phy/omap_control_phy.h               |   10 +
 include/linux/phy/phy.h                            |   17 +-
 include/linux/usb/composite.h                      |   15 +
 include/linux/usb/quirks.h                         |   11 +
 include/linux/usb/renesas_usbhs.h                  |    6 +
 include/linux/usb/usb338x.h                        |  199 +
 include/linux/usb/xhci_pdriver.h                   |   27 +
 include/uapi/linux/usb/functionfs.h                |   82 +-
 .../multibuff/device_app/aio_multibuff.c           |   39 +-
 .../usb/ffs-aio-example/multibuff/host_app/test.c  |   27 +
 .../ffs-aio-example/simple/device_app/aio_simple.c |   39 +-
 tools/usb/ffs-aio-example/simple/host_app/test.c   |   27 +
 267 files changed, 11203 insertions(+), 5803 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-usb-lvstest
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-apq8064-sata-phy.txt
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-ipq806x-sata-phy.txt
 create mode 100644 drivers/phy/phy-berlin-sata.c
 create mode 100644 drivers/phy/phy-hix5hd2-sata.c
 create mode 100644 drivers/phy/phy-miphy365x.c
 create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c
 create mode 100644 drivers/phy/phy-qcom-ipq806x-sata.c
 create mode 100644 drivers/usb/gadget/function/Makefile
 rename drivers/usb/gadget/{ => function}/f_acm.c (100%)
 rename drivers/usb/gadget/{ => function}/f_ecm.c (100%)
 rename drivers/usb/gadget/{ => function}/f_eem.c (97%)
 rename drivers/usb/gadget/{ => function}/f_fs.c (87%)
 rename drivers/usb/gadget/{ => function}/f_hid.c (100%)
 rename drivers/usb/gadget/{ => function}/f_loopback.c (100%)
 rename drivers/usb/gadget/{ => function}/f_mass_storage.c (100%)
 rename drivers/usb/gadget/{ => function}/f_mass_storage.h (100%)
 rename drivers/usb/gadget/{ => function}/f_midi.c (100%)
 rename drivers/usb/gadget/{ => function}/f_ncm.c (78%)
 rename drivers/usb/gadget/{ => function}/f_obex.c (100%)
 rename drivers/usb/gadget/{ => function}/f_phonet.c (100%)
 rename drivers/usb/gadget/{ => function}/f_rndis.c (99%)
 rename drivers/usb/gadget/{ => function}/f_serial.c (100%)
 rename drivers/usb/gadget/{ => function}/f_sourcesink.c (100%)
 rename drivers/usb/gadget/{ => function}/f_subset.c (100%)
 rename drivers/usb/gadget/{ => function}/f_uac1.c (100%)
 rename drivers/usb/gadget/{ => function}/f_uac2.c (98%)
 rename drivers/usb/gadget/{ => function}/f_uvc.c (100%)
 rename drivers/usb/gadget/{ => function}/f_uvc.h (100%)
 rename drivers/usb/gadget/{ => function}/g_zero.h (100%)
 rename drivers/usb/gadget/{ => function}/ndis.h (100%)
 rename drivers/usb/gadget/{ => function}/rndis.c (100%)
 rename drivers/usb/gadget/{ => function}/rndis.h (100%)
 rename drivers/usb/gadget/{ => function}/storage_common.c (100%)
 rename drivers/usb/gadget/{ => function}/storage_common.h (100%)
 rename drivers/usb/gadget/{ => function}/u_ecm.h (100%)
 rename drivers/usb/gadget/{ => function}/u_eem.h (100%)
 rename drivers/usb/gadget/{ => function}/u_ether.c (98%)
 rename drivers/usb/gadget/{ => function}/u_ether.h (99%)
 rename drivers/usb/gadget/{ => function}/u_ether_configfs.h (100%)
 rename drivers/usb/gadget/{ => function}/u_fs.h (96%)
 rename drivers/usb/gadget/{ => function}/u_gether.h (100%)
 rename drivers/usb/gadget/{ => function}/u_ncm.h (100%)
 rename drivers/usb/gadget/{ => function}/u_phonet.h (100%)
 rename drivers/usb/gadget/{ => function}/u_rndis.h (100%)
 rename drivers/usb/gadget/{ => function}/u_serial.c (100%)
 rename drivers/usb/gadget/{ => function}/u_serial.h (100%)
 rename drivers/usb/gadget/{ => function}/u_uac1.c (100%)
 rename drivers/usb/gadget/{ => function}/u_uac1.h (100%)
 rename drivers/usb/gadget/{ => function}/uvc.h (100%)
 rename drivers/usb/gadget/{ => function}/uvc_queue.c (100%)
 rename drivers/usb/gadget/{ => function}/uvc_queue.h (100%)
 rename drivers/usb/gadget/{ => function}/uvc_v4l2.c (100%)
 rename drivers/usb/gadget/{ => function}/uvc_video.c (100%)
 create mode 100644 drivers/usb/gadget/legacy/Kconfig
 create mode 100644 drivers/usb/gadget/legacy/Makefile
 rename drivers/usb/gadget/{ => legacy}/acm_ms.c (97%)
 rename drivers/usb/gadget/{ => legacy}/audio.c (95%)
 rename drivers/usb/gadget/{ => legacy}/cdc2.c (96%)
 rename drivers/usb/gadget/{ => legacy}/dbgp.c (100%)
 rename drivers/usb/gadget/{ => legacy}/ether.c (98%)
 rename drivers/usb/gadget/{ => legacy}/g_ffs.c (99%)
 rename drivers/usb/gadget/{ => legacy}/gmidi.c (95%)
 rename drivers/usb/gadget/{ => legacy}/hid.c (100%)
 rename drivers/usb/gadget/{ => legacy}/inode.c (100%)
 rename drivers/usb/gadget/{ => legacy}/mass_storage.c (100%)
 rename drivers/usb/gadget/{ => legacy}/multi.c (98%)
 rename drivers/usb/gadget/{ => legacy}/ncm.c (96%)
 rename drivers/usb/gadget/{ => legacy}/nokia.c (97%)
 rename drivers/usb/gadget/{ => legacy}/printer.c (100%)
 rename drivers/usb/gadget/{ => legacy}/serial.c (100%)
 rename drivers/usb/gadget/{ => legacy}/tcm_usb_gadget.c (100%)
 rename drivers/usb/gadget/{ => legacy}/tcm_usb_gadget.h (100%)
 rename drivers/usb/gadget/{ => legacy}/webcam.c (98%)
 rename drivers/usb/gadget/{ => legacy}/zero.c (98%)
 delete mode 100644 drivers/usb/gadget/net2280.c
 delete mode 100644 drivers/usb/gadget/net2280.h
 create mode 100644 drivers/usb/gadget/udc/Kconfig
 create mode 100644 drivers/usb/gadget/udc/Makefile
 rename drivers/usb/gadget/{ => udc}/amd5536udc.c (100%)
 rename drivers/usb/gadget/{ => udc}/amd5536udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/at91_udc.c (100%)
 rename drivers/usb/gadget/{ => udc}/at91_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/atmel_usba_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/atmel_usba_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/bcm63xx_udc.c (100%)
 rename drivers/usb/gadget/{ => udc}/dummy_hcd.c (100%)
 rename drivers/usb/gadget/{ => udc}/fotg210-udc.c (100%)
 rename drivers/usb/gadget/{ => udc}/fotg210.h (100%)
 rename drivers/usb/gadget/{ => udc}/fsl_mxc_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/fsl_qe_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/fsl_qe_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/fsl_udc_core.c (99%)
 rename drivers/usb/gadget/{ => udc}/fsl_usb2_udc.h (99%)
 rename drivers/usb/gadget/{ => udc}/fusb300_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/fusb300_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/gadget_chips.h (100%)
 rename drivers/usb/gadget/{ => udc}/goku_udc.c (100%)
 rename drivers/usb/gadget/{ => udc}/goku_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/gr_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/gr_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/lpc32xx_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/m66592-udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/m66592-udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/mv_u3d.h (100%)
 rename drivers/usb/gadget/{ => udc}/mv_u3d_core.c (100%)
 rename drivers/usb/gadget/{ => udc}/mv_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/mv_udc_core.c (99%)
 rename drivers/usb/gadget/{ => udc}/net2272.c (99%)
 rename drivers/usb/gadget/{ => udc}/net2272.h (100%)
 create mode 100644 drivers/usb/gadget/udc/net2280.c
 create mode 100644 drivers/usb/gadget/udc/net2280.h
 rename drivers/usb/gadget/{ => udc}/omap_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/omap_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/pch_udc.c (100%)
 rename drivers/usb/gadget/{ => udc}/pxa25x_udc.c (97%)
 rename drivers/usb/gadget/{ => udc}/pxa25x_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/pxa27x_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/pxa27x_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/r8a66597-udc.c (96%)
 rename drivers/usb/gadget/{ => udc}/r8a66597-udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/s3c-hsudc.c (100%)
 rename drivers/usb/gadget/{ => udc}/s3c2410_udc.c (99%)
 rename drivers/usb/gadget/{ => udc}/s3c2410_udc.h (100%)
 rename drivers/usb/gadget/{ => udc}/udc-core.c (100%)
 create mode 100644 drivers/usb/host/xhci-rcar.c
 create mode 100644 drivers/usb/host/xhci-rcar.h
 create mode 100644 drivers/usb/misc/lvstest.c
 create mode 100644 drivers/usb/renesas_usbhs/rcar2.c
 create mode 100644 drivers/usb/renesas_usbhs/rcar2.h
 create mode 100644 include/dt-bindings/phy/phy-miphy365x.h
 create mode 100644 include/linux/usb/usb338x.h
 create mode 100644 include/linux/usb/xhci_pdriver.h
