Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab3JQRhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:37:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab3JQRha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:37:30 -0400
Date: Thu, 17 Oct 2013 10:37:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.12-rc6
Message-ID: <20131017173729.GA8122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.12-rc6

for you to fetch changes up to 94468783cd960aa14b22503dd59afd14efb785aa:

  usb: usb_phy_gen: refine conditional declaration of usb_nop_xceiv_register (2013-10-17 09:34:30 -0700)

----------------------------------------------------------------
USB fixes for 3.12-rc6

Here are some USB fixes and new device ids for 3.12-rc6

The largest change here is a bunch of new device ids for the option USB
serial driver for new Huawei devices.  Other than that, just some small
bug fixes for issues that people have reported (run-time and
build-time), nothing major.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Diego Elio Pettenò (1):
      USB: serial: ti_usb_3410_5052: add Abbott strip port ID to combined table as well.

Enrico Mioso (1):
      usb: serial: option: blacklist Olivetti Olicard200

Fangxiaozhi (Franko) (1):
      USB: support new huawei devices in option.c

Greg Kroah-Hartman (4):
      Merge tag 'fixes-for-v3.12-rc5' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2013-10-09' of git://git.kernel.org/.../sarah/xhci into usb-linus
      USB: serial: option: add support for Inovia SEW858 device
      Revert "usb: musb: gadget: fix otg active status flag"

Guenter Roeck (1):
      usb: usb_phy_gen: refine conditional declaration of usb_nop_xceiv_register

Matthew Dawson (1):
      usb: misc: usb3503: Fix compile error due to incorrect regmap depedency

Oliver Neukum (4):
      xhci: quirk for extra long delay for S4
      USB: quirks.c: add one device that cannot deal with suspension
      USB: quirks: add touchscreen that is dazzeled by remote wakeup
      usb-storage: add quirk for mandatory READ_CAPACITY_16

Russell King - ARM Linux (1):
      usb/chipidea: fix oops on memory allocation failure

Sarah Sharp (1):
      xhci: Don't enable/disable RWE on bus suspend/resume.

Sebastian Andrzej Siewior (1):
      usb: musb: start musb on the udc side, too

Takashi Iwai (1):
      xhci: Fix spurious wakeups after S5 on Haswell

Xenia Ragiadakou (1):
      xhci: fix write to USB3_PSSEN and XUSB2PRM pci config registers

 drivers/usb/chipidea/host.c           |   6 +-
 drivers/usb/core/quirks.c             |   6 +
 drivers/usb/host/pci-quirks.c         |   4 +-
 drivers/usb/host/xhci-hub.c           |  26 ----
 drivers/usb/host/xhci-pci.c           |  25 ++++
 drivers/usb/host/xhci.c               |  14 ++-
 drivers/usb/host/xhci.h               |   2 +
 drivers/usb/misc/Kconfig              |   2 +-
 drivers/usb/musb/musb_core.c          |  46 +++++++
 drivers/usb/musb/musb_core.h          |   1 +
 drivers/usb/musb/musb_gadget.c        |   3 +
 drivers/usb/musb/musb_virthub.c       |  46 -------
 drivers/usb/serial/option.c           | 225 +++++++++++++++++++++++++++++++++-
 drivers/usb/serial/ti_usb_3410_5052.c |   1 +
 drivers/usb/storage/scsiglue.c        |   5 +-
 drivers/usb/storage/unusual_devs.h    |   7 ++
 include/linux/usb/usb_phy_gen_xceiv.h |   2 +-
 include/linux/usb_usual.h             |   4 +-
 18 files changed, 343 insertions(+), 82 deletions(-)
