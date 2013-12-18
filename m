Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3LRRnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:43:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3LRRnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:43:13 -0500
Date: Wed, 18 Dec 2013 09:43:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.13-rc5
Message-ID: <20131218174315.GA32681@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2d51f3cd11f414c56a87dc018196b85fd50b04a4:

  usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED (2013-12-04 17:00:43 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.13-rc5

for you to fetch changes up to fb5f1834c3221e459324c6885eaad75429f722a5:

  usb: ohci-at91: fix irq and iomem resource retrieval (2013-12-17 13:22:36 -0800)

----------------------------------------------------------------
USB: fixes for 3.13-rc5

Here are a few USB fixes for things that have people have reported
issues with recently.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Bjørn Mork (1):
      usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Boris BREZILLON (1):
      usb: ohci-at91: fix irq and iomem resource retrieval

Chris Ruehl (1):
      usb: phy-tegra-usb.c: wrong pointer check for remap UTMI

Dan Carpenter (2):
      usb: phy: twl6030-usb: signedness bug in twl6030_readb()
      drivers: phy: tweaks to phy_create()

Dmitry Kunilov (1):
      usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev back to option

Fabio Estevam (1):
      usb: chipidea: host: Only disable the vbus regulator if it is not NULL

Felipe Balbi (1):
      usb: phy: fix driver dependencies

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.13-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2013-12-10' of git://git.kernel.org/.../sarah/xhci into usb-linus

Kishon Vijay Abraham I (3):
      usb: dwc3: invoke phy_resume after phy_init
      usb: dwc3: power off usb phy in error path
      phy: kconfig: add depends on "USB_PHY" to OMAP_USB2 and TWL4030_USB

Peter Chen (1):
      usb: chipidea: fix nobody cared IRQ when booting with host role

Sachin Kamat (1):
      drivers: phy: Fix memory leak

Takashi Iwai (1):
      xhci: Limit the spurious wakeup fix only to HP machines

 drivers/phy/Kconfig               |  4 ++--
 drivers/phy/phy-core.c            | 26 ++++++++++----------------
 drivers/usb/chipidea/core.c       |  4 ++++
 drivers/usb/chipidea/host.c       |  3 ++-
 drivers/usb/chipidea/udc.c        |  3 ---
 drivers/usb/class/cdc-wdm.c       |  8 +++-----
 drivers/usb/dwc3/core.c           |  8 +++++---
 drivers/usb/host/ohci-at91.c      | 26 +++++++++++++++-----------
 drivers/usb/host/xhci-pci.c       |  7 ++++++-
 drivers/usb/phy/Kconfig           |  4 +++-
 drivers/usb/phy/phy-tegra-usb.c   |  2 +-
 drivers/usb/phy/phy-twl6030-usb.c |  3 ++-
 drivers/usb/serial/option.c       |  2 ++
 drivers/usb/serial/zte_ev.c       |  3 +--
 14 files changed, 56 insertions(+), 47 deletions(-)
