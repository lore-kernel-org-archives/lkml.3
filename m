Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbaGUPfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:35:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47471 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322AbaGUPfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:35:43 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB changes for v3.17
Date: Mon, 21 Jul 2014 10:35:29 -0500
Message-ID: <1405956929-10169-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my big set of patches containing 97 commits. While it looks big and
all, most commits are just cleanups moving code around, using devm_*, etc.

I tested these patches on a couple TI platforms and couldn't find any regressions
on my setup.

This tree has also been on linux-next for a while.

Please consider merging on top of your usb-next branch or let me know if you
want anything to change.

cheers

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-for-v3.17

for you to fetch changes up to 8346b33fad01cfe93f0fd0e64cd32ff40bd4ba41:

  Documentation: DocBook: elieminate doc build break (2014-07-17 12:21:16 -0500)

----------------------------------------------------------------
usb: patches for v3.17 merge window

Surprisingly enough, while a big set of patches, the majority is
composed of cleanups (using devm_*, fixing sparse errors, moving
code around, adding const, etc).

The highlights are addition of new support for PLX USB338x devices,
and support for USB 2.0-only configurations of the DWC3 IP core.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Andrzej Pietrasiewicz (8):
      usb: gadget: f_fs: rename descriptor parsing functions
      usb: gadget: u_os_desc: helper functions for accessing ext prop buffer
      usb: gadget: f_fs: OS descriptors support
      usb: gadget: Gadget directory cleanup - group legacy gadgets
      usb: gadget: Gadget directory cleanup - group UDC drivers
      usb: gadget: Gadget directory cleanup - group usb functions
      usb: gadget: f_rndis: fix interface id for OS descriptors
      Documentation: DocBook: elieminate doc build break

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

Daniel Mack (8):
      usb: musb: remove unnecessary (void) prefix at function calls
      usb: musb: use is_host_active() to distinguish between host and gadget mode
      usb: musb: fix bit mask for CSR in musb_h_tx_flush_fifo()
      usb: musb: introduce dma_channel.rx_packet_done
      usb: musb/cppi41: call musb_ep_select() before accessing an endpoint's CSR
      usb: musb: fix wrong indentation in musb_host.c
      Revert "usb: musb: musb_cppi41: Handle ISOCH differently and not use the hrtimer."
      usb: musb: cppi41: fire hrtimer according to programmed channel length

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

Himangi Saraogi (7):
      usb: gadget: pxa25x_udc: use devm_ functions
      usb: musb: ux500: use devm_ functions
      usb: gadget: fsl_qe_udc: Introduce use of managed version of kzalloc
      usb: phy: phy-gpio-vbus-usb: use devm_ functions
      usb: musb: davinci: use devm_ functions.
      usb: musb: tusb6010: Introduce the use of the managed version of kzalloc
      usb: musb: backfin: Introduce the use of the managed version of kzalloc

Jim Baxter (3):
      usb: gadget: NCM: RX function support multiple NDPs
      usb: gadget: NCM: Add transmit multi-frame.
      usb: gadget: NCM: Stop RX TCP Bursts getting dropped.

Jingoo Han (6):
      usb: phy: msm: Make of_device_id array const
      usb: phy: tegra: Make of_device_id array const
      usb: gadget: gr_udc: Make of_device_id array const
      usb: gadget: lpc32xx_udc: Make of_device_id array const
      usb: phy: am335x: Use SIMPLE_DEV_PM_OPS macro
      usb: dwc3: gadget: remove unnecessary 'start_new' variable

Krzysztof Opasiak (1):
      usb: gadget: FunctionFS: Return -ENOENT instead of -ENODEV when device not found.

Li Jun (1):
      usb: gadget: composite: dequeue cdev->req before free it in composite_dev_cleanup

Lothar Waßmann (1):
      usb: musb: dsps: coding style cleanup

Nathan Sullivan (1):
      usb: gadget: fix eem_wrap cloned skb logic

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

Rickard Strandqvist (1):
      usb: musb: musb_host.c: Cleaning up uninitialized variables

Robert Baldyga (3):
      tools: ffs-aio-example: fix header values endianess
      tools: ffs-aio-example: convert to new descriptor format
      tools: ffs-aio-example: add license information

Robert Jarzmik (1):
      usb: gadget: pxa27x_udc: prepare and unprepare the clock

Sebastian Reimers (1):
      usb: gadget: f_uac2: Fix pcm sample size selection

Srinivas Kandagatla (1):
      usb: phy: msm: Make phy_reset clk and reset line optional.

Thierry Reding (1):
      usb: phy: tegra: Do not include asm/mach-types.h

Tobias Klauser (2):
      usb: gadget: Add helper macro for usb_composite_driver boilerplate
      usb: gadget: Convert drivers to use module_usb_composite_driver()

Ulrich Hecht (1):
      usb: renesas_usbhs: add R-Car Gen. 2 init and power control

Vasily Khoruzhick (1):
      usb: gadget: s3c2410: Move to clk_prepare_enable/clk_disable_unprepare

Vivek Gautam (1):
      usb: dwc3: Keeping 'resource' related code together

Yoshihiro Shimoda (2):
      usb: renesas_usbhs: fix usbhs_pipe_malloc() to re-enable a pipe.
      usb: renesas_usbhs: gadget: fix re-enabling pipe without re-connecting

 Documentation/DocBook/gadget.tmpl                  |   10 +-
 drivers/usb/dwc3/core.c                            |   51 +-
 drivers/usb/dwc3/core.h                            |   13 +
 drivers/usb/dwc3/dwc3-omap.c                       |  172 +-
 drivers/usb/dwc3/gadget.c                          |    7 +-
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
 drivers/usb/gadget/{ => udc}/mv_udc_core.c         |    0
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
 drivers/usb/musb/blackfin.c                        |   20 +-
 drivers/usb/musb/davinci.c                         |   20 +-
 drivers/usb/musb/jz4740.c                          |    3 +
 drivers/usb/musb/musb_core.c                       |   43 +-
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
 drivers/usb/phy/phy-tegra-usb.c                    |    3 +-
 drivers/usb/renesas_usbhs/Makefile                 |    2 +-
 drivers/usb/renesas_usbhs/common.c                 |   66 +-
 drivers/usb/renesas_usbhs/common.h                 |    2 +
 drivers/usb/renesas_usbhs/mod_gadget.c             |    2 +
 drivers/usb/renesas_usbhs/pipe.c                   |   11 +
 drivers/usb/renesas_usbhs/pipe.h                   |    1 +
 drivers/usb/renesas_usbhs/rcar2.c                  |   77 +
 drivers/usb/renesas_usbhs/rcar2.h                  |    4 +
 include/linux/usb/composite.h                      |   15 +
 include/linux/usb/renesas_usbhs.h                  |    6 +
 include/linux/usb/usb338x.h                        |  199 +
 include/uapi/linux/usb/functionfs.h                |   81 +-
 .../multibuff/device_app/aio_multibuff.c           |   39 +-
 .../usb/ffs-aio-example/multibuff/host_app/test.c  |   27 +
 .../ffs-aio-example/simple/device_app/aio_simple.c |   39 +-
 tools/usb/ffs-aio-example/simple/host_app/test.c   |   27 +
 159 files changed, 7024 insertions(+), 4940 deletions(-)
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
 rename drivers/usb/gadget/{ => udc}/mv_udc_core.c (100%)
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
 create mode 100644 drivers/usb/renesas_usbhs/rcar2.c
 create mode 100644 drivers/usb/renesas_usbhs/rcar2.h
 create mode 100644 include/linux/usb/usb338x.h
