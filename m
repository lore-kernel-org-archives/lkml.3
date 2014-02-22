Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaBVXK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:10:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaBVXK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:10:26 -0500
Date: Sat, 22 Feb 2014 15:13:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fix for 3.14-rc4
Message-ID: <20140222231310.GA29110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.14-rc4

for you to fetch changes up to 5bf5dbeda2454296f1984adfbfc8e6f5965ac389:

  usb: chipidea: need to mask when writting endptflush and endptprime (2014-02-21 12:34:45 -0800)

----------------------------------------------------------------
USB fixes for 3.14-rc4

Here are a number of USB fixes for reported issues for 3.14-rc4

The majority of these are for USB gadget, phy, and musb driver issues.
And there's a few new device ids thrown in for good measure.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ajay Kumar Gupta (1):
      usb: musb: host: Fix SuperSpeed hub enumeration

Alan Stern (1):
      USB: EHCI: add delay during suspend to prevent erroneous wakeups

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Andrzej Pietrasiewicz (1):
      usb: gadget: fix NULL pointer dereference

Daniel Mack (4):
      usb: musb: do not sleep in atomic context
      usb: musb: do not sleep in atomic context
      usb: musb: correct use of schedule_delayed_work()
      usb: musb: correct use of schedule_delayed_work()

Felipe Balbi (1):
      usb: musb: fix obex in g_nokia.ko causing kernel panic

Florian Fainelli (1):
      usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-v3.14-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus

Hans de Goede (3):
      phy-core: phy_get: Leave error logging to the caller
      phy-core: Don't propagate -ENOSUPP from phy_pm_runtime_get_sync to caller
      phy-core: Don't allow building phy-core as a module

Josh Cartwright (1):
      usb: phy: msm: fix compilation errors when !CONFIG_PM_SLEEP

Kishon Vijay Abraham I (1):
      phy: let phy_provider_register be the last step in registering PHY

Matthieu CASTET (1):
      usb: chipidea: need to mask when writting endptflush and endptprime

Peter Chen (1):
      usb: gadget: printer: using gadget_is_otg to check otg support at runtime

Richard Weinberger (1):
      phy,phy-bcm-kona-usb2.c: Add dependency on HAS_IOMEM

Roger Quadros (1):
      usb: musb: core: Fix remote-wakeup resume

Sachin Kamat (1):
      usb: gadget: s3c2410_udc: Fix build error

 drivers/phy/Kconfig                 |  3 +-
 drivers/phy/phy-core.c              | 14 ++++-----
 drivers/phy/phy-exynos-dp-video.c   |  8 ++---
 drivers/phy/phy-exynos-mipi-video.c | 10 +++----
 drivers/phy/phy-mvebu-sata.c        | 10 +++----
 drivers/phy/phy-omap-usb2.c         | 10 +++----
 drivers/phy/phy-twl4030-usb.c       | 10 +++----
 drivers/usb/chipidea/udc.c          |  4 +--
 drivers/usb/gadget/bcm63xx_udc.c    | 58 ++++++++++++++++++++-----------------
 drivers/usb/gadget/f_fs.c           |  7 ++++-
 drivers/usb/gadget/printer.c        |  2 +-
 drivers/usb/gadget/s3c2410_udc.c    |  2 +-
 drivers/usb/host/ehci-hub.c         | 26 ++++++++++++++---
 drivers/usb/musb/musb_core.c        | 15 ++++++++--
 drivers/usb/musb/musb_host.c        |  3 ++
 drivers/usb/musb/musb_virthub.c     | 26 ++++++++++++-----
 drivers/usb/musb/omap2430.c         |  2 --
 drivers/usb/phy/phy-msm-usb.c       | 57 +++++++++++++++++-------------------
 drivers/usb/serial/option.c         |  3 +-
 19 files changed, 159 insertions(+), 111 deletions(-)
