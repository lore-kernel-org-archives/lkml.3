Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428Ab3LIT1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:27:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33034 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab3LIT1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:27:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.13-rc4
Date: Mon, 9 Dec 2013 13:26:50 -0600
Message-ID: <1386617210-29054-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's another set of really obvious fixes for this rc cycle. All patches have
been pending for a while.

Please consider merging on top of your usb-linus branch.

cheers

The following changes since commit 2cf93bea3d7b2dbf1e0ebfa9d381aad1b637e2aa:

  usb: gadget: f_mass_storage: call try_to_freeze only when its safe (2013-11-25 11:34:09 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.13-rc4

for you to fetch changes up to 851dd02b4f1fdb437586190f87217e3382a736bd:

  usb: phy-tegra-usb.c: wrong pointer check for remap UTMI (2013-12-06 14:32:15 -0600)

----------------------------------------------------------------
usb: fixes for v3.13-rc4

DWC3 learned that it can't resume a PHY which wasn't
initialized and it also learned to not leave PHY powered
up in case of an error.

twl6030-usb PHY driver got a fix for a signedness bug in
twl6030_readb().

Tegra PHY driver got a bug fix where it could return success
even though there was an error.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Chris Ruehl (1):
      usb: phy-tegra-usb.c: wrong pointer check for remap UTMI

Dan Carpenter (1):
      usb: phy: twl6030-usb: signedness bug in twl6030_readb()

Kishon Vijay Abraham I (2):
      usb: dwc3: invoke phy_resume after phy_init
      usb: dwc3: power off usb phy in error path

 drivers/usb/dwc3/core.c           | 8 +++++---
 drivers/usb/phy/phy-tegra-usb.c   | 2 +-
 drivers/usb/phy/phy-twl6030-usb.c | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)
