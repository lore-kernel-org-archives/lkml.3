Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab3CMU6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:58:54 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:35823 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:58:52 -0400
Date: Wed, 13 Mar 2013 13:58:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.9-rc2
Message-ID: <20130313205850.GA17634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.9-rc2

for you to fetch changes up to 27b351c5546008c640b3e65152f60ca74b3706f1:

  USB: quatech2: only write to the tty if the port is open. (2013-03-13 12:32:47 -0700)

----------------------------------------------------------------
USB fixes for 3.9-rc2

Here are a number of tiny USB fixes and new USB device ids for your 3.9
tree.

The "largest" one here is a revert of a usb-storage patch that turned
out to be incorrect, breaking existing users, which is never a good
thing.  Everything else is pretty simple and small

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (2):
      usb: musb: omap2430: fix omap_musb_mailbox glue check again
      usb: musb: omap2430: fix sparse warning

Alan Stern (2):
      USB: EHCI: work around silicon bug in Intel's EHCI controllers
      USB: EHCI: don't check DMA values in QH overlays

Andrew Morton (1):
      usb: dwc3: ep0: fix sparc64 build

Arnd Bergmann (1):
      usb: gadget: fix omap_udc build errors

Bill Pemberton (1):
      USB: quatech2: only write to the tty if the port is open.

Bjørn Mork (3):
      USB: option: add Huawei E5331
      USB: storage: in-kernel modeswitching is deprecated
      USB: storage: fix Huawei mode switching regression

Christian Schmiedl (1):
      USB: added support for Cinterion's products AH6 and PLS8

Dan Carpenter (2):
      usb: gadget: f_uac1: silence an info leak warning
      usb: gadget: u_uac1: NULL dereference on error path

Dan Williams (2):
      qcaux: add Franklin U600
      qcserial: bind to DM/DIAG port on Gobi 1K devices

Dave Tubbs (2):
      usb: Correction to c67x00 TD data length mask
      usb: c67x00 RetryCnt value in c67x00 TD should be 3

Felipe Balbi (15):
      usb: dwc3: core: don't forget to free coherent memory
      usb: dwc3: omap: fix a typo on of_device_id
      usb: dwc3: glue layers shouldn't know about the core IP
      usb: dwc3: gadget: remove unnecessary code
      usb: chipidea: register debugging sysfs on our device
      usb: gadget: pxa27x: fix gadget->dev registration
      usb: gadget: s3c2410: fix gadget->dev registration
      usb: gadget: pxa25x: fix gadget->dev registration
      usb: gadget: imx_udc: fix gadget->dev registration
      usb: gadget: s3c2410: fix build breakage
      usb: musb: remove all 'select' from Kconfig
      usb: musb: fix compile warning
      usb: Makefile: fix drivers/usb/phy/ Makefile entry
      usb: gadget: pxa25x: fix disconnect reporting
      usb: musb: core: fix possible build error with randconfig

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.9-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'fixes-for-v3.9-rc3' of git://git.kernel.org/.../balbi/usb into usb-linus

Kishon Vijay Abraham I (1):
      usb: gadget: make usb functions to load before gadget driver

Marc Kleine-Budde (1):
      usb: otg: use try_module_get in all usb_get_phy functions and add missing module_put

Matwey V. Kornilov (1):
      usb: cp210x new Vendor/Device IDs

Maxin B. John (1):
      tools: usb: ffs-test: Fix build failure

Nishanth Menon (1):
      usb: gadget: composite: fix kernel-doc warnings

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow

Peter Ujfalusi (1):
      usb: musb: correct Kconfig in order to avoid non compilable selection

Sachin Kamat (3):
      usb: phy: samsung: Convert to devm_ioremap_resource()
      usb: phy: omap-usb3: Convert to devm_ioremap_resource()
      usb: phy: omap-control-usb: Convert to devm_ioremap_resource()

Steve Conklin (1):
      usb: serial: Add Rigblaster Advantage to device table

 drivers/usb/Makefile               |   2 +-
 drivers/usb/c67x00/c67x00-sched.c  |   4 +-
 drivers/usb/chipidea/udc.c         |   6 +-
 drivers/usb/class/cdc-wdm.c        |  23 ++++-
 drivers/usb/dwc3/core.c            |   1 +
 drivers/usb/dwc3/dwc3-exynos.c     |   2 -
 drivers/usb/dwc3/dwc3-omap.c       |   8 +-
 drivers/usb/dwc3/dwc3-pci.c        |   2 -
 drivers/usb/dwc3/ep0.c             |   7 +-
 drivers/usb/dwc3/gadget.c          |   3 -
 drivers/usb/gadget/Makefile        |  12 +--
 drivers/usb/gadget/composite.c     |   5 +-
 drivers/usb/gadget/f_uac1.c        |   1 +
 drivers/usb/gadget/imx_udc.c       |  20 ++--
 drivers/usb/gadget/omap_udc.c      |   3 +-
 drivers/usb/gadget/pxa25x_udc.c    |  24 +++--
 drivers/usb/gadget/pxa27x_udc.c    |  18 ++--
 drivers/usb/gadget/s3c2410_udc.c   |  28 +++---
 drivers/usb/gadget/u_uac1.c        |   3 +
 drivers/usb/host/ehci-hcd.c        |   6 +-
 drivers/usb/host/ehci-q.c          |  36 +++++--
 drivers/usb/musb/Kconfig           |   5 -
 drivers/usb/musb/musb_core.c       |   6 --
 drivers/usb/musb/omap2430.c        |  12 ++-
 drivers/usb/otg/otg.c              |  10 +-
 drivers/usb/phy/omap-control-usb.c |  24 ++---
 drivers/usb/phy/omap-usb3.c        |   8 +-
 drivers/usb/phy/samsung-usbphy.c   |   8 +-
 drivers/usb/serial/cp210x.c        |  20 ++++
 drivers/usb/serial/option.c        |   5 +
 drivers/usb/serial/qcaux.c         |   1 +
 drivers/usb/serial/qcserial.c      |   7 +-
 drivers/usb/serial/quatech2.c      |   7 +-
 drivers/usb/storage/initializers.c |  76 +--------------
 drivers/usb/storage/initializers.h |   4 +-
 drivers/usb/storage/unusual_devs.h | 337 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/usb/composite.h      |   3 +-
 tools/usb/ffs-test.c               |   2 +-
 38 files changed, 531 insertions(+), 218 deletions(-)
