Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaLWQxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:53:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34252 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbaLWQxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:53:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB patches
Date: Tue, 23 Dec 2014 10:53:11 -0600
Message-ID: <1419353591-10300-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.2.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my first set of fixes for v3.19-rc cycle. An early
Winter Solstice gift for you.

All patches have gone through my 300 randconfigs (no build
breakages or new warnings found) and I boot tested with
AM437x SK, AM437x IDK, Beagle x15 and Beagle Bone Black.

cheers

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.19-rc2

for you to fetch changes up to 6785a1034461c2d2c205215f63a50a740896e55b:

  usb: gadget: udc: atmel: fix possible IN hang issue (2014-12-22 10:41:15 -0600)

----------------------------------------------------------------
usb: fixes for v3.19-rc2

First set of fixes for current -rc cycle. There are
a couple of build break fixes after Tony Lindgren's
recent MUSB patchset, some memory leak fixes also
with MUSB, a use-after-free fix with the UAC1
function. Atmel UDC got a fix for a possible hang
and another for DMA setting, while dwc2 learned to
kill requests in ->udc_stop() which fixes a few leaks
too.

One new device support here, dwc3 now supports Intel's
Sunrise Point.

Signed-off-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Bo Shen (2):
      usb: gadget: udc: atmel: change setting for DMA
      usb: gadget: udc: atmel: fix possible IN hang issue

Felipe Balbi (2):
      usb: musb: debugfs: cope with blackfin's oddities
      usb: musb: blackfin: fix build break

Heikki Krogerus (1):
      usb: dwc3: pci: add support for Intel Sunrise Point PCH

Julia Lawall (1):
      usb: gadget: fix misspelling of current function in string

Mario Schuknecht (1):
      usb: gadget: gadgetfs: Free memory allocated by memdup_user()

Peter Chen (1):
      usb: gadget: f_uac1: access freed memory at f_audio_free_inst

Rasmus Villemoes (1):
      usb: musb: Fix a few off-by-one lengths

Robert Baldyga (1):
      usb: dwc2: gadget: kill requests with 'force' in s3c_hsotg_udc_stop()

Sebastian Andrzej Siewior (1):
      usb: musb: stuff leak of struct usb_hcd

Tony Lindgren (1):
      usb: musb: Fix randconfig build issues for Kconfig options

 drivers/usb/dwc2/gadget.c               | 10 +++++++---
 drivers/usb/dwc3/dwc3-pci.c             |  4 ++++
 drivers/usb/gadget/function/f_hid.c     |  5 +++--
 drivers/usb/gadget/function/f_midi.c    |  2 +-
 drivers/usb/gadget/function/f_uac1.c    |  2 +-
 drivers/usb/gadget/legacy/inode.c       |  1 +
 drivers/usb/gadget/udc/atmel_usba_udc.c |  7 +++----
 drivers/usb/musb/Kconfig                |  4 ++++
 drivers/usb/musb/blackfin.c             |  2 +-
 drivers/usb/musb/musb_cppi41.c          |  4 ++--
 drivers/usb/musb/musb_debugfs.c         | 34 +++++++++++++++++----------------
 drivers/usb/musb/musb_host.c            |  1 -
 12 files changed, 45 insertions(+), 31 deletions(-)
