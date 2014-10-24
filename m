Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbaJXPOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:14:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60610 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbaJXPOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:14:31 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.18-rc2
Date: Fri, 24 Oct 2014 10:14:12 -0500
Message-ID: <1414163652-27364-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's our first set of fixes for v3.18-rc cycle.

Quite a few goodies here but the most important is that most gadget drivers
(except for g_hid, g_midi and g_webcam) pass USB[23]0CV with MUSB and DWC3.

All patches have been tested for weeks (since v3.18 merge window opened) and
they have also been tested for a few days on top of v3.18-rc1.

Let me know if you want anything to be changed.

cheers


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.18-rc2

for you to fetch changes up to 9b1763553a89b2a84881119eeabfccdb803bb468:

  usb: gadget: function: Fixed the return value on error path (2014-10-23 14:49:35 -0500)

----------------------------------------------------------------
usb: fixes for v3.18-rc2

Here's the first set of fixes for v3.18-rc cycle. It includes
a whole bunch of bug fixes related to USB20CV and USB30CV when
running on DWC3 and MUSB. After this series, we have clean chapter 9
and MSC tests for all gadget drivers.

We also have a new PCI ID for Intel Braswell platform so they can use
DWC3 out-of-the-box.

A regression on functionfs wrt quirk_ep_out_aligned_size flag has also
been fixed.

DWC2 got a couple of fixes for the gadget role. The first of which fixes
rmmod followed by modprobe while the second makes sure to disable PHYs
before killing the regulators powering them.

These are the most important fixes worth mentioning, there are a few
other minor fixes as well.

Signed-off-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Alan Cox (1):
      usb: dwc3: pci: Add PCI ID for Intel Braswell

Charles Manning (1):
      usb: dwc2: Bits in bitfield should add up to 32

David Cohen (1):
      usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set

Felipe Balbi (20):
      usb: dwc3: trace: don't dereference pointers
      usb: dwc3: ep0: hold our lock in dwc3_gadget_ep0_set_halt
      usb: dwc3: gadget: move isoc endpoint check to unlocked set_halt
      usb: dwc3: gadget: hold the lock through set_wedge()'s life
      usb: dwc3: gadget: fix set_halt() bug with pending transfers
      usb: gadget: function: uvc: conditionally dequeue
      usb: gadget: function: uvc: make sure to balance ep enable/disable
      usb: gadget: function: uvc: return correct alt-setting
      usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
      usb: gadget: function: uvc: manage our video control endpoint
      usb: gadget: function: uvc: disable endpoints on ->disable()
      usb: gadget: function: uac2: add wMaxPacketSize to ep desc
      usb: gadget: function: uac2: prevent double ep disable
      usb: gadget: function: uac2: add a release method
      usb: gadget: function: f_obex: fix Interface Descriptor Test
      usb: dwc3: ep0: return early on NULL requests
      usb: dwc3: ep0: fix Data Phase for transfer sizes aligned to wMaxPacketSize
      usb: gadget: composite: enable BESL support
      usb: gadget: loopback: don't queue requests to bogus endpoints
      usb: gadget: udc: core: fix kernel oops with soft-connect

Geert Uytterhoeven (1):
      usb: gadget: udc: USB_GADGET_XILINX should depend on HAS_DMA

Jack Pham (1):
      usb: dwc3: gadget: Properly initialize LINK TRB

Marek Szyprowski (2):
      usb: dwc2: gadget: fix gadget unregistration in udc_stop() function
      usb: dwc2: gadget: disable phy before turning off power regulators

Pavitrakumar Managutte (2):
      usb: gadget: function: Remove redundant usb_free_all_descriptors
      usb: gadget: function: Fixed the return value on error path

Robert Baldyga (1):
      usb: gadget: f_fs: remove redundant ffs_data_get()

Roger Quadros (1):
      Revert "usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in prepare/complete"

Sebastian Andrzej Siewior (2):
      usb: musb: dsps: start OTG timer on resume again
      usb: musb: musb_dsps: fix NULL pointer in suspend

Sudip Mukherjee (1):
      usb: dwc2: gadget: sparse warning of context imbalance

Thomas Gleixner (1):
      usb: musb: cppi41: restart hrtimer only if not yet done

 drivers/usb/dwc2/core.h                  |  2 +-
 drivers/usb/dwc2/gadget.c                | 14 ++---
 drivers/usb/dwc3/dwc3-omap.c             | 15 +-----
 drivers/usb/dwc3/dwc3-pci.c              |  2 +
 drivers/usb/dwc3/ep0.c                   | 48 +++++++++++++-----
 drivers/usb/dwc3/gadget.c                | 39 ++++++++------
 drivers/usb/dwc3/gadget.h                |  3 +-
 drivers/usb/dwc3/trace.h                 | 53 +++++++++++++------
 drivers/usb/gadget/composite.c           |  2 +-
 drivers/usb/gadget/function/f_acm.c      |  8 +--
 drivers/usb/gadget/function/f_eem.c      |  1 -
 drivers/usb/gadget/function/f_fs.c       | 42 ++++++++++++---
 drivers/usb/gadget/function/f_hid.c      |  5 +-
 drivers/usb/gadget/function/f_loopback.c | 87 +++++++++++++++-----------------
 drivers/usb/gadget/function/f_ncm.c      |  1 -
 drivers/usb/gadget/function/f_obex.c     |  9 ++--
 drivers/usb/gadget/function/f_phonet.c   |  2 +-
 drivers/usb/gadget/function/f_rndis.c    |  9 ++--
 drivers/usb/gadget/function/f_subset.c   |  1 -
 drivers/usb/gadget/function/f_uac2.c     | 23 +++++++--
 drivers/usb/gadget/function/f_uvc.c      | 54 ++++++++++++++++----
 drivers/usb/gadget/function/uvc_video.c  |  3 +-
 drivers/usb/gadget/udc/Kconfig           |  1 +
 drivers/usb/gadget/udc/udc-core.c        |  5 ++
 drivers/usb/musb/musb_cppi41.c           |  3 +-
 drivers/usb/musb/musb_dsps.c             | 18 +++++--
 26 files changed, 294 insertions(+), 156 deletions(-)
