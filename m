Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3I2UDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:03:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3I2UC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:02:56 -0400
Date: Sun, 29 Sep 2013 13:02:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.12-rc3
Message-ID: <20130929200258.GA31250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.12-rc3

for you to fetch changes up to 85601f8cf67c56a561a6dd5e130e65fdc179047d:

  usb: dwc3: add support for Merrifield (2013-09-26 16:22:29 -0700)

----------------------------------------------------------------
USB fixes for 3.12-rc3

Here are a number of USB driver fixes for 3.12-rc3.

These are all for host controller issues that have been reported, and there's a
fix for an annoying error message that gets printed every time you remove a USB
3 device from the system that's been bugging me for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Al Viro (1):
      USB: Fix breakage in ffs_fs_mount()

Alan Stern (4):
      USB: iMX21: accept very late isochronous URBs
      USB: UHCI: accept very late isochronous URBs
      USB: OHCI: accept very late isochronous URBs
      USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd

David Cohen (1):
      usb: dwc3: add support for Merrifield

Florian Wolter (1):
      xhci: Fix race between ep halt and URB cancellation

Geert Uytterhoeven (1):
      usb: chipidea: USB_CHIPIDEA should depend on HAS_DMA

Greg Kroah-Hartman (1):
      Merge tag 'for-usb-linus-2013-09-23' of git://git.kernel.org/.../sarah/xhci into usb-linus

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit

Mathias Nyman (2):
      xhci: Fix oops happening after address device timeout
      xhci: Ensure a command structure points to the correct trb on the command ring

Peter Chen (4):
      usb: chipidea: udc: fix the oops after rmmod gadget
      usb: chipidea: Fix memleak for ci->hw_bank.regmap when removal
      usb: chipidea: imx: Add usb_phy_shutdown at probe's error path
      usb: chipidea: udc: free pending TD at removal procedure

Ramneek Mehresh (1):
      fsl/usb: Resolve PHY_CLK_VLD instability issue for ULPI phy

Sarah Sharp (1):
      usb: Fix xHCI host issues on remote wakeup.

Shengzhou Liu (1):
      USB: fsl/ehci: fix failure of checking PHY_CLK_VALID during reinitialization

Xenia Ragiadakou (1):
      usbcore: check usb device's state before sending a Set SEL control transfer

 drivers/usb/chipidea/Kconfig       |  2 +-
 drivers/usb/chipidea/ci_hdrc_imx.c |  7 +++--
 drivers/usb/chipidea/core.c        |  1 +
 drivers/usb/chipidea/udc.c         |  4 ++-
 drivers/usb/core/devio.c           | 16 ++++++++++
 drivers/usb/core/hub.c             |  3 ++
 drivers/usb/dwc3/dwc3-pci.c        |  2 ++
 drivers/usb/gadget/f_fs.c          | 60 +++++++++++++++++---------------------
 drivers/usb/host/ehci-fsl.c        | 17 ++++-------
 drivers/usb/host/ehci-pci.c        |  2 +-
 drivers/usb/host/imx21-hcd.c       |  8 ++---
 drivers/usb/host/ohci-hcd.c        | 22 +++++++-------
 drivers/usb/host/ohci-q.c          | 26 ++++++++++++++---
 drivers/usb/host/uhci-pci.c        |  2 +-
 drivers/usb/host/uhci-q.c          | 12 +++++---
 drivers/usb/host/xhci-hub.c        | 47 ++++++++++++++++++++++-------
 drivers/usb/host/xhci-mem.c        |  2 ++
 drivers/usb/host/xhci-pci.c        |  2 +-
 drivers/usb/host/xhci-ring.c       | 37 +++++++++++++++++++++--
 drivers/usb/host/xhci.c            | 25 ++++------------
 drivers/usb/host/xhci.h            | 11 +++++++
 21 files changed, 201 insertions(+), 107 deletions(-)
