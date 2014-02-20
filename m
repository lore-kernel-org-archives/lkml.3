Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaBTP2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:28:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50297 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaBTP2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:28:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB patches
Date: Thu, 20 Feb 2014 09:26:50 -0600
Message-ID: <1392910010-25612-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's a pull request for final round of fixes. All patches have
been soaking for a long time in linux-usb, passed my 300 randconfig
builds and work on real HW (where applicable).

This pull request is based off of greg/usb-linus in order for me
to avoid merging patches you had already merged during my time
off.

Please consider merging this tag on your greg/usb-linus.

cheers

The following changes since commit 3635c7e2d59f7861afa6fa5e87e2a58860ff514d:

  usb: option: blacklist ZTE MF667 net interface (2014-02-11 15:33:54 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.14-rc4

for you to fetch changes up to 9ccfaf74e766d49a64f86943f98d0a82996d4dec:

  usb: musb: correct use of schedule_delayed_work() (2014-02-20 09:17:24 -0600)

----------------------------------------------------------------
usb: fixes for v3.14-rc4

Here are 10 fixes for our current -rc cycle. It's likely
the last round of fixes for this merge window. All patches
have soaked for a long time and have all been tested in real
HW.

The most interesting fixes are a fix for enumeration of superspeed
hubs when MUSB is acting as host, and a remote-wakeup fix also on
MUSB.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Ajay Kumar Gupta (1):
      usb: musb: host: Fix SuperSpeed hub enumeration

Andrzej Pietrasiewicz (1):
      usb: gadget: fix NULL pointer dereference

Daniel Mack (2):
      usb: musb: do not sleep in atomic context
      usb: musb: correct use of schedule_delayed_work()

Felipe Balbi (1):
      usb: musb: fix obex in g_nokia.ko causing kernel panic

Florian Fainelli (1):
      usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Josh Cartwright (1):
      usb: phy: msm: fix compilation errors when !CONFIG_PM_SLEEP

Peter Chen (1):
      usb: gadget: printer: using gadget_is_otg to check otg support at runtime

Roger Quadros (1):
      usb: musb: core: Fix remote-wakeup resume

Sachin Kamat (1):
      usb: gadget: s3c2410_udc: Fix build error

 drivers/usb/gadget/bcm63xx_udc.c | 58 ++++++++++++++++++++++------------------
 drivers/usb/gadget/f_fs.c        |  7 ++++-
 drivers/usb/gadget/printer.c     |  2 +-
 drivers/usb/gadget/s3c2410_udc.c |  2 +-
 drivers/usb/musb/musb_core.c     | 15 +++++++++--
 drivers/usb/musb/musb_host.c     |  3 +++
 drivers/usb/musb/musb_virthub.c  | 26 +++++++++++++-----
 drivers/usb/musb/omap2430.c      |  2 --
 drivers/usb/phy/phy-msm-usb.c    | 57 ++++++++++++++++++---------------------
 9 files changed, 101 insertions(+), 71 deletions(-)
