Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaKHS67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:58:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaKHS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:58:57 -0500
Date: Sat, 8 Nov 2014 10:57:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.18-rc4
Message-ID: <20141108185742.GA2138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.18-rc4

for you to fetch changes up to 1910195423e7bea4c01c42bfe3f81792a6e969bb:

  USB: Update default usb-storage delay_use value in kernel-parameters.txt (2014-11-07 08:54:53 -0800)

----------------------------------------------------------------
USB fixes for 3.18-rc4

Here are some USB fixes for 3.18-rc4.

Just a bunch of little fixes resolving reported issues and new device ids for
existing drivers.  Full details are in the shortlog.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Adel Gadllah (2):
      USB: quirks: enable device-qualifier quirk for another Elan touchscreen
      USB: quirks: enable device-qualifier quirk for yet another Elan touchscreen

Alan Stern (1):
      usb-storage: handle a skipped data phase

Dan Carpenter (1):
      USB: HWA: fix a warning message

Greg Kroah-Hartman (3):
      Revert "storage: Replace magic number with define in usb_stor_euscsi_init()"
      Merge tag 'usb-serial-3.18-rc4' of git://git.kernel.org/.../johan/usb-serial into usb-linus
      Merge tag 'fixes-for-v3.18-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus

Hans de Goede (5):
      usb: Do not allow usb_alloc_streams on unconfigured devices
      uas: Add US_FL_NO_ATA_1X quirk for 1 more Seagate model
      xhci: Disable streams on Asmedia 1042 xhci controllers
      uas: Add NO_ATA_1X for VIA VL711 devices
      uas: Add US_FL_NO_ATA_1X quirk for 2 more Seagate models

Jim Paris (1):
      cdc-acm: ensure that termios get set when the port is activated

Johan Hovold (5):
      USB: kobil_sct: fix non-atomic allocation in write path
      USB: opticon: fix non-atomic allocation in write path
      USB: cdc-acm: add device id for GW Instek AFG-2225
      USB: cdc-acm: only raise DTR on transitions from B0
      USB: cdc-acm: add quirk for control-line state requests

Luis Henriques (1):
      usb: storage: fix build warnings !CONFIG_PM

Marek Szyprowski (1):
      usb: dwc2: gadget: fix enumeration issues

Mark Einon (1):
      MAINTAINERS: Remove duplicate entry for usbip driver

Mark Knibbs (2):
      USB: storage: Fix timeout in usb_stor_euscsi_init() and usb_stor_huawei_e220_init()
      USB: Update default usb-storage delay_use value in kernel-parameters.txt

Oliver Neukum (1):
      xhci: no switching back on non-ULT Haswell

Oussama Ghorbel (1):
      phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly

Peter Chen (1):
      usb: core: notify disconnection when core detects disconnect

Sylwester Nawrocki (1):
      usb: Remove references to non-existent PLAT_S5P symbol

Tony Zheng (1):
      usb: core: need to call usb_phy_notify_connect after device setup

 Documentation/kernel-parameters.txt |  2 +-
 MAINTAINERS                         |  5 -----
 drivers/phy/phy-omap-usb2.c         |  6 ++++--
 drivers/usb/class/cdc-acm.c         | 25 +++++++++++++++++++++----
 drivers/usb/class/cdc-acm.h         |  2 ++
 drivers/usb/core/hcd.c              |  2 ++
 drivers/usb/core/hub.c              | 10 +++++-----
 drivers/usb/core/quirks.c           |  6 ++++++
 drivers/usb/dwc2/gadget.c           |  2 +-
 drivers/usb/host/Kconfig            |  4 ++--
 drivers/usb/host/hwa-hc.c           |  2 +-
 drivers/usb/host/xhci-pci.c         | 18 ++++--------------
 drivers/usb/serial/kobil_sct.c      |  5 +++--
 drivers/usb/serial/opticon.c        |  2 +-
 drivers/usb/storage/initializers.c  |  4 ++--
 drivers/usb/storage/realtek_cr.c    |  2 ++
 drivers/usb/storage/transport.c     | 26 ++++++++++++++++++++++++++
 drivers/usb/storage/unusual_uas.h   | 28 ++++++++++++++++++++++++++++
 18 files changed, 111 insertions(+), 40 deletions(-)
