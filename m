Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab3ANFDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:03:41 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47759 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3ANFDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:03:39 -0500
Date: Sun, 13 Jan 2013 21:04:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.8-rc3
Message-ID: <20130114050428.GA8614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.8-rc3

for you to fetch changes up to 8cf65dc386f3634a43312f436cc7a935476a40c4:

  usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added (2013-01-13 13:44:23 -0800)

----------------------------------------------------------------
USB fixes for 3.8-rc3

Here are a bunch of USB fixes for your 3.8-rc3 tree.  They all either fix
problems that have been reported (like the xhci/hub changes) or add new device
ids to existing drivers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Afzal Mohammed (1):
      usb: musb: dsps: header movement build error fix

Alan Stern (1):
      USB: usbtest: fix test number in log message

Anatolij Gustschin (3):
      USB: fix fsl_otg config dependency
      USB: fsl-mph-dr-of: fix regression on mpc5121e
      USB: ehci-fsl: fix regression on mpc5121e

Andreas Fleig (1):
      USB: Add device quirk for Microsoft VX700 webcam

Bjørn Mork (2):
      USB: option: blacklist network interface on ZTE MF880
      USB: option: add Telekom Speedstick LTE II

Chao Xie (3):
      usb: gadget: mv_udc: fix the clk APIs
      usb: host: ehci-mv: fix clk APIs
      usb: otg: mv_otg: fix the clk APIs

Denis N Ladin (1):
      USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Dzianis Kahanovich (1):
      USB: option: add Nexpring NP10T terminal id

Fabio Estevam (2):
      usb: imx21-hcd: Include missing linux/module.h
      usb: chipidea: Allow disabling streaming not only in udc mode

Felipe Balbi (1):
      usb: host: ohci-tmio: fix compile warning

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.8-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2013-01-03' of git://git.kernel.org/.../sarah/xhci into usb-linus

Haipeng YU (1):
      usb: gadget: u_serial: fix switch off blocked

Jack Pham (1):
      usb: dwc3: debugfs: fix regdump offset

Jan Beulich (1):
      USB: ehci: make debug port in-use detection functional again

Kuninori Morimoto (3):
      usb: renesas_usbhs: gadget: remove usbhsg_uep_init()
      usb: renesas_usbhs: gadget: usbhsg_ep_disable() care pipe settings
      usb: renesas_usbhs: mod_host: fixup usbhsh_ureq_free() timing

Maxime Ripard (1):
      USB: select USB_ARCH_HAS_EHCI for MXS

Oliver Neukum (1):
      USB: hub: handle claim of enabled remote wakeup after reset

Quentin.Li (1):
      USB: option: Add new MEDIATEK PID support

Sarah Sharp (8):
      xhci: Handle HS bulk/ctrl endpoints that don't NAK.
      USB: Handle auto-transition from hot to warm reset.
      USB: Ignore xHCI Reset Device status.
      USB: Allow USB 3.0 ports to be disabled.
      USB: Increase reset timeout.
      USB: Ignore port state until reset completes.
      USB: Handle warm reset failure on empty port.
      xhci: Avoid "dead ports", add roothub port polling.

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy: fix enumeration with g_multi

Sergei Shtylyov (1):
      usb: musb: core: print new line in the driver banner again

Tomasz Mloduchowski (1):
      usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Tushar Behera (1):
      usb: gadget: s3c-hsotg: Fix invalid free of devm_ allocated data

Wei Yongjun (1):
      usb: gadget: tcm_usb_gadge: fix to return error or 0 in tcm_usbg_drop_nexus()

Xi Wang (1):
      usb: gadget: amd5536udc: avoid NULL pointer dereference in udc_pci_probe()

 drivers/usb/Kconfig                    |   1 +
 drivers/usb/chipidea/host.c            |   3 +
 drivers/usb/class/cdc-acm.c            |   3 +
 drivers/usb/core/hub.c                 | 120 ++++++++++++++++++++++++++-------
 drivers/usb/core/quirks.c              |   3 +
 drivers/usb/dwc3/debugfs.c             |   2 +-
 drivers/usb/gadget/amd5536udc.c        |   4 +-
 drivers/usb/gadget/dummy_hcd.c         |   9 +--
 drivers/usb/gadget/mv_udc_core.c       |   4 +-
 drivers/usb/gadget/s3c-hsotg.c         |   5 +-
 drivers/usb/gadget/tcm_usb_gadget.c    |   3 +-
 drivers/usb/gadget/u_serial.c          |   2 +-
 drivers/usb/host/ehci-fsl.c            |   9 +--
 drivers/usb/host/ehci-mv.c             |   4 +-
 drivers/usb/host/ehci-pci.c            |  39 +++++------
 drivers/usb/host/fsl-mph-dr-of.c       |   3 +
 drivers/usb/host/imx21-hcd.c           |   1 +
 drivers/usb/host/ohci-tmio.c           |   3 +-
 drivers/usb/host/xhci-hub.c            |  38 ++++++++++-
 drivers/usb/host/xhci-mem.c            |   2 +
 drivers/usb/host/xhci-ring.c           |   9 +++
 drivers/usb/host/xhci.c                |  10 +++
 drivers/usb/misc/usbtest.c             |   2 +-
 drivers/usb/musb/musb_core.c           |   5 +-
 drivers/usb/musb/musb_dsps.c           |   5 ++
 drivers/usb/otg/Kconfig                |   2 +-
 drivers/usb/otg/mv_otg.c               |   4 +-
 drivers/usb/renesas_usbhs/mod_gadget.c |  22 +++---
 drivers/usb/renesas_usbhs/mod_host.c   |   3 +-
 drivers/usb/serial/ftdi_sio.c          |   2 +
 drivers/usb/serial/ftdi_sio_ids.h      |   6 ++
 drivers/usb/serial/option.c            |  18 ++++-
 32 files changed, 257 insertions(+), 89 deletions(-)
