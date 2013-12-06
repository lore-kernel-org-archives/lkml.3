Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab3LFSYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:24:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439Ab3LFSYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:24:44 -0500
Date: Fri, 6 Dec 2013 10:24:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.13-rc3
Message-ID: <20131206182443.GA30186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.13-rc3

for you to fetch changes up to 2d51f3cd11f414c56a87dc018196b85fd50b04a4:

  usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED (2013-12-04 17:00:43 -0800)

----------------------------------------------------------------
USB fixes for 3.13-rc3

Here are a bunch of USB fixes for 3.13-rc3.

Nothing major, but we seem to have an argument about a XHCI fix, so I'm not
including a revert that Sarah requested, because that breaks a USB network
driver, and I can't revert the USB network driver fix without reintroducing
other bugs that it fixed.  So as it is, everything should now be
working.  Worse case, I can revert the XHCI fix before 3.13-final is
out, but it seems to work well here with my testing, so all should be
good.

Other than that, some driver updates based on reports.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (1):
      usb: phy-generic: fix nop xceiv probe

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Andrzej Pietrasiewicz (1):
      usb: gadget: f_mass_storage: fix mass storage dependency

Apelete Seketeli (1):
      usb: fix musb gadget to enable OTG mode conditionally

Colin Leitner (4):
      USB: spcp8x5: correct handling of CS5 setting
      USB: mos7840: correct handling of CS5 setting
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting
      USB: pl2303: fixed handling of CS5 setting

Daniel Mack (1):
      usb: ohci-pxa27x: include linux/dma-mapping.h

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

David Laight (1):
      usb: xhci: Link TRB must not occur within a USB payload burst

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Felipe Balbi (4):
      usb: phy: generic: fix how we find out about our resources
      usb: gadget: storage: fix sparse warning
      usb: gadget: ffs: fix sparse warning
      usb: gadget: tcm_usb_gadget: mark bot_cleanup_old_alt static

Fengguang Wu (1):
      usb: gadget: zero: module parameters can be static

George Cherian (1):
      usb: gadget: f_mass_storage: call try_to_freeze only when its safe

Greg Kroah-Hartman (3):
      Merge tag 'fixes-for-v3.13-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2013-12-02' of git://git.kernel.org/.../sarah/xhci into usb-linus
      USB: switch maintainership of chipidea to Peter

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

Heikki Krogerus (1):
      usb: phy: generic: fix a compiler warning

Huang Rui (1):
      usb: tools: fix a regression issue that gcc can't link to pthread

Jisheng Zhang (1):
      usb: phy: phy-mxs-usb: set the correct platform drvdata

Johan Hovold (2):
      USB: serial: fix race in generic write
      USB: serial: fix write memory-allocation flag

Julius Werner (1):
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED

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

Thomas Pugliese (3):
      usb: wusbcore: send keepalives to unauthenticated devices
      usb: wusbcore: do device lookup while holding the hc mutex
      usb: wusbcore: fix deadlock in wusbhc_gtk_rekey

Valentine Barshak (1):
      usb: phy: phy-rcar-gen2-usb: fix phy initialization

Wei Yongjun (1):
      usb: phy: phy-generic: fix return value check in usb_nop_xceiv_register()

 MAINTAINERS                         |   3 +-
 drivers/usb/class/cdc-acm.c         |   2 +
 drivers/usb/core/hub.c              |   5 +-
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
 drivers/usb/host/ohci-pxa27x.c      |   1 +
 drivers/usb/host/xhci-ring.c        |  54 +++++++++++-
 drivers/usb/musb/musb_core.c        |   9 +-
 drivers/usb/musb/musb_cppi41.c      | 164 ++++++++++++++++++++++++++++++------
 drivers/usb/musb/musb_gadget.c      |   4 +
 drivers/usb/phy/phy-am335x.c        |   5 +-
 drivers/usb/phy/phy-generic.c       |  68 +++++++--------
 drivers/usb/phy/phy-generic.h       |   4 +-
 drivers/usb/phy/phy-mxs-usb.c       |   2 +-
 drivers/usb/phy/phy-rcar-gen2-usb.c |   4 +-
 drivers/usb/serial/ftdi_sio.c       |  37 +++++---
 drivers/usb/serial/generic.c        |  12 +--
 drivers/usb/serial/mos7840.c        |  32 +++----
 drivers/usb/serial/option.c         |  27 ++++++
 drivers/usb/serial/pl2303.c         |  30 +++----
 drivers/usb/serial/spcp8x5.c        |  30 +++----
 drivers/usb/wusbcore/devconnect.c   |  72 ++++++----------
 drivers/usb/wusbcore/security.c     |  98 ++++++++++++---------
 drivers/usb/wusbcore/wusbhc.h       |   6 +-
 include/linux/usb.h                 |   2 +
 include/linux/usb/wusb.h            |   2 +
 tools/usb/Makefile                  |   5 +-
 36 files changed, 471 insertions(+), 265 deletions(-)
