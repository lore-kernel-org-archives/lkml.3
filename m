Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaICO1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:27:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59525 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbaICO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:27:38 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.17-rc3
Date: Wed, 3 Sep 2014 09:27:30 -0500
Message-ID: <1409754450-8172-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's a new set of fixes. Pretty minor stuff. I tested with platforms
which I have access to.

Cheers

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.17-rc3

for you to fetch changes up to 9ce9ec95fb9b82e09b55a52f1bb8a362bf8f74d8:

  usb: phy: tegra: Avoid use of sizeof(void) (2014-09-03 09:16:01 -0500)

----------------------------------------------------------------
usb: fixes for v3.17-rc3

A new set of fixes which have been pending for a while. All patches
have been randconfig build-tested and boot tested where applicable.

The most important fixes are MUSB on AM335x learned how to transfer
ZLPs, and net2280 got a fix for reset IRQ handling.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Bin Liu (1):
      usb: musb: cppi41: fix not transmitting zero length packet issue

Peter Chen (2):
      usb: phy: mxs: add imx6sx support
      doc: dt: mxs-phy: add compatible string for imx6sx-usbphy

Rasmus Villemoes (1):
      usb: gadget: fusb300_udc.h: Fix typo in include guard

Ricardo Ribalda Delgado (1):
      usb: gadget: net2280: Fix invalid handling of Reset irq

Robert Baldyga (1):
      usb: gadget: f_fs: fix the redundant ep files problem

Thierry Reding (1):
      usb: phy: tegra: Avoid use of sizeof(void)

Yoshihiro Shimoda (4):
      usb: renesas_usbhs: fix the behavior of some usbhs_pkt_handle
      usb: renesas_usbhs: protect mod->irq_{bemp,brdy}sts by spin lock
      usb: renesas_usbhs: fix the condition of is_done in usbhsf_dma_push_done
      usb: renesas_usbhs: fix the usb_pkt_pop()

 Documentation/devicetree/bindings/usb/mxs-phy.txt |  1 +
 drivers/usb/gadget/function/f_fs.c                | 66 +++++++++++++++++----
 drivers/usb/gadget/function/u_fs.h                |  2 +
 drivers/usb/gadget/udc/fusb300_udc.h              |  2 +-
 drivers/usb/gadget/udc/net2280.c                  |  2 +-
 drivers/usb/musb/musb_cppi41.c                    | 17 +++++-
 drivers/usb/phy/phy-mxs-usb.c                     |  8 ++-
 drivers/usb/phy/phy-tegra-usb.c                   |  4 +-
 drivers/usb/renesas_usbhs/fifo.c                  | 72 +++++++++++++++++++++--
 drivers/usb/renesas_usbhs/mod.c                   |  5 ++
 drivers/usb/renesas_usbhs/pipe.c                  | 13 ++++
 drivers/usb/renesas_usbhs/pipe.h                  |  4 ++
 12 files changed, 172 insertions(+), 24 deletions(-)
