Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab3KYS6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:58:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60676 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab3KYS6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:58:32 -0500
MIME-Version: 1.0
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.13-rc2
Date: Mon, 25 Nov 2013 12:09:35 -0600
Message-ID: <1385402975-24354-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my first set of fixes for this -rc cycle. Please
consider merging them on your usb-linus branch.

Let me know if you need any changes to this pull request. I
did a test merge of this tag with your usb-linus branch and
it merges just fine.

cheers

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.13-rc2

for you to fetch changes up to 2cf93bea3d7b2dbf1e0ebfa9d381aad1b637e2aa:

  usb: gadget: f_mass_storage: call try_to_freeze only when its safe (2013-11-25 11:34:09 -0600)

----------------------------------------------------------------
usb: fixes for v3.13-rc2

First set of fixes for this -rc cycle. A few important
fixes which should be backported to stable kernels and
the usual set of sparse warning fixes. There's also a
regression fix on phy-generic.c which would prevent
am335x-based platforms from having their PHY drivers
probed.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Aaro Koskinen (1):
      usb: phy-generic: fix nop xceiv probe

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Andrzej Pietrasiewicz (1):
      usb: gadget: f_mass_storage: fix mass storage dependency

Apelete Seketeli (1):
      usb: fix musb gadget to enable OTG mode conditionally

Felipe Balbi (4):
      usb: phy: generic: fix how we find out about our resources
      usb: gadget: storage: fix sparse warning
      usb: gadget: ffs: fix sparse warning
      usb: gadget: tcm_usb_gadget: mark bot_cleanup_old_alt static

Fengguang Wu (1):
      usb: gadget: zero: module parameters can be static

George Cherian (1):
      usb: gadget: f_mass_storage: call try_to_freeze only when its safe

Heikki Krogerus (1):
      usb: phy: generic: fix a compiler warning

Jisheng Zhang (1):
      usb: phy: phy-mxs-usb: set the correct platform drvdata

Linus Walleij (1):
      usb: gadget: fix pxa25x compilation problems

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Michal Nazarewicz (1):
      usb: phy: remove dead code

Pratyush Anand (1):
      usb: gadget: mass storage: fix return of delayed status

Robert Baldyga (2):
      usb: gadget: s3c-hsotg: fix spinlock locking
      usb: gadget: s3c-hsotg: fix disconnect handling

Sebastian Andrzej Siewior (3):
      usb: musb: musb_cppi41: factor most of cppi41_dma_callback() into cppi41_trans_done()
      usb: musb: musb_cppi41: handle pre-mature TX complete interrupt
      usb: musb: only cancel work if it is initialized

Valentine Barshak (1):
      usb: phy: phy-rcar-gen2-usb: fix phy initialization

Wei Yongjun (1):
      usb: phy: phy-generic: fix return value check in usb_nop_xceiv_register()

 drivers/usb/dwc3/ep0.c              |   2 +
 drivers/usb/dwc3/gadget.c           |   5 +-
 drivers/usb/gadget/Kconfig          |   1 +
 drivers/usb/gadget/composite.c      |   1 +
 drivers/usb/gadget/f_fs.c           |   2 +-
 drivers/usb/gadget/f_mass_storage.c |  27 +++---
 drivers/usb/gadget/pxa25x_udc.c     |   1 +
 drivers/usb/gadget/s3c-hsotg.c      |   7 +-
 drivers/usb/gadget/storage_common.h |   4 -
 drivers/usb/gadget/tcm_usb_gadget.c |   2 +-
 drivers/usb/gadget/zero.c           |   6 +-
 drivers/usb/musb/musb_core.c        |   9 +-
 drivers/usb/musb/musb_cppi41.c      | 164 ++++++++++++++++++++++++++++++------
 drivers/usb/musb/musb_gadget.c      |   4 +
 drivers/usb/phy/phy-am335x.c        |   5 +-
 drivers/usb/phy/phy-generic.c       |  68 +++++++--------
 drivers/usb/phy/phy-generic.h       |   4 +-
 drivers/usb/phy/phy-mxs-usb.c       |   2 +-
 drivers/usb/phy/phy-rcar-gen2-usb.c |   4 +-
 19 files changed, 221 insertions(+), 97 deletions(-)
