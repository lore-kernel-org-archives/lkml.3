Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaHTRNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:13:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34855 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaHTRNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:13:39 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.17-rc2
Date: Wed, 20 Aug 2014 12:13:34 -0500
Message-ID: <1408554814-24715-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my first set of fixes for this merge window. All patches have soaked in
mailing list for a while, and what I could, I tested on the platforms I have.

Please consider merging on top of your usb-linus branch.

cheers

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.17-rc2

for you to fetch changes up to 5d19703822da2a8e9161302aa918c8e45a4c5eee:

  usb: gadget: remove $(PWD) in ccflags-y (2014-08-20 11:16:02 -0500)

----------------------------------------------------------------
usb: fixes for v3.17-rc2

Here's our first set of fixes for v3.17-rc cycle. Most fixes are
pretty minor changes like the signedness bug in dwc3, or the wrong
string format on MUSB.

The most interesting part is the addition of Intel Quark X1000 support
to PCH UDC.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Alexey Khoroshilov (1):
      usb: dbgp gadget: fix use after free in dbgp_unbind()

Arjun Sreedharan (1):
      usb: phy: return -ENODEV on failure of try_module_get

Bo Shen (1):
      usb: atmel_usba_udc: fix it to deal with final dma channel

Bryan O'Donoghue (1):
      usb: pch_udc: usb gadget device support for Intel Quark X1000

Dan Carpenter (1):
      usb: dwc3: omap: signedness bug in dwc3_omap_set_utmi_mode()

Hans Wennborg (1):
      usb: musb: ux500: fix decimal printf format specifiers prefixed with 0x

Himangi Saraogi (1):
      usb: phy: drop kfree of devm_kzalloc's data

Jingoo Han (1):
      usb: phy: samsung: Fix wrong bit mask for PHYPARAM1_PCS_TXDEEMPH

Julia Lawall (1):
      usb: gadget: fix error return code

Li RongQing (1):
      Revert "usb: gadget: u_ether: synchronize with transmit when stopping queue"

Michael Grzeschik (1):
      usb: gadget: uvc: fix possible lockup in uvc gadget

Philippe Reynes (1):
      usb: gadget: remove $(PWD) in ccflags-y

Wei Yongjun (3):
      usb: gadget: Fix return value check in ep_write()
      usb: gadget: Fix return value check in r8a66597_probe()
      usb: phy: msm: Fix return value check in msm_otg_probe()

 drivers/usb/dwc3/dwc3-omap.c            |  2 +-
 drivers/usb/gadget/Makefile             |  2 +-
 drivers/usb/gadget/function/Makefile    |  4 ++--
 drivers/usb/gadget/function/u_ether.c   |  3 ---
 drivers/usb/gadget/function/uvc_video.c |  3 +++
 drivers/usb/gadget/legacy/Makefile      |  6 +++---
 drivers/usb/gadget/legacy/dbgp.c        |  2 ++
 drivers/usb/gadget/legacy/inode.c       |  2 +-
 drivers/usb/gadget/udc/Kconfig          |  3 ++-
 drivers/usb/gadget/udc/atmel_usba_udc.c |  2 +-
 drivers/usb/gadget/udc/fusb300_udc.c    |  8 ++++++--
 drivers/usb/gadget/udc/pch_udc.c        | 22 +++++++++++++++++++---
 drivers/usb/gadget/udc/r8a66597-udc.c   |  4 ++--
 drivers/usb/musb/ux500_dma.c            |  2 +-
 drivers/usb/phy/phy-gpio-vbus-usb.c     |  4 +---
 drivers/usb/phy/phy-msm-usb.c           |  4 ++--
 drivers/usb/phy/phy-samsung-usb.h       |  2 +-
 drivers/usb/phy/phy.c                   |  3 +++
 18 files changed, 51 insertions(+), 27 deletions(-)
