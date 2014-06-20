Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaFTOoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:44:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49072 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbaFTOol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:44:41 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.16-rc2
Date: Fri, 20 Jun 2014 09:44:37 -0500
Message-ID: <1403275477-18107-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my first set of fixes for this -rc cycle. Please consider merging
to your usb-linus branch.

cheers

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.16-rc2

for you to fetch changes up to 5d881802c407d83c169c875dad88fe2bba066c33:

  usb: musb: core: Handle Babble condition only in HOST mode (2014-06-19 15:43:07 -0500)

----------------------------------------------------------------
usb: fixes for v3.16-rc2

dwc3-omap won't crash anymore on module removal and suspend/resume won't kill
xHCI interrupts.

MUSB got a fix to handle Babble condition only in host mode, how it should be.

The f_fs function driver got a fix for a NULL pointer dereference.

Renesas gadget got a fix for Status stage handling.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Andrzej Pietrasiewicz (2):
      usb: gadget: OS descriptors configfs cleanup
      usb: gadget: OS descriptors: provide interface directory names

Dan Carpenter (1):
      usb: gadget: f_rndis: fix an error code on allocation failure

George Cherian (3):
      usb: dwc3: dwc3-omap: Fix the crash on module removal
      usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in prepare/complete
      usb: musb: core: Handle Babble condition only in HOST mode

Jeff Westfahl (1):
      usb: gadget: u_ether: synchronize with transmit when stopping queue

Kuninori Morimoto (1):
      usb: renesas: gadget: fixup: complete STATUS stage after receiving

Linus Walleij (1):
      usb: musb: ux500: don't propagate the OF node

Marcus Nutzinger (1):
      usb: gadget: gadgetfs: correct dev state

Michal Nazarewicz (2):
      tools: ffs-test: convert to new descriptor format fixing compilation error
      usb: gadget: f_fs: fix NULL pointer dereference when there are no strings

Zhuang Jin Can (1):
      usb: dwc3: gadget: check link trb after free_slot is increased

 drivers/usb/dwc3/Kconfig            |  1 +
 drivers/usb/dwc3/dwc3-omap.c        | 17 ++++++++++++++---
 drivers/usb/dwc3/gadget.c           |  8 ++++----
 drivers/usb/gadget/configfs.c       | 37 +++++++++++++++++++------------------
 drivers/usb/gadget/configfs.h       |  1 +
 drivers/usb/gadget/f_fs.c           | 12 +++++++-----
 drivers/usb/gadget/f_rndis.c        |  6 ++++--
 drivers/usb/gadget/inode.c          |  7 ++++++-
 drivers/usb/gadget/u_ether.c        |  3 +++
 drivers/usb/musb/musb_core.c        |  2 +-
 drivers/usb/musb/ux500.c            |  1 -
 drivers/usb/renesas_usbhs/fifo.c    |  8 ++++++++
 include/uapi/linux/usb/functionfs.h |  2 +-
 tools/usb/Makefile                  |  6 +++++-
 tools/usb/ffs-test.c                | 20 ++++++++++++++++++--
 15 files changed, 92 insertions(+), 39 deletions(-)
