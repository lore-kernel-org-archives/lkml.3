Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbaKAUUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 16:20:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469AbaKAUUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 16:20:00 -0400
Date: Sat, 1 Nov 2014 13:18:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.18-rc3
Message-ID: <20141101201848.GA3916@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.18-rc3

for you to fetch changes up to 9c19db5b11487da704d29dee48345c4841831bac:

  Merge tag 'usb-serial-3.18-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/johan/usb-serial into usb-linus (2014-10-29 09:24:42 -0700)

----------------------------------------------------------------
USB fixes for 3.18-rc3

Here are a bunch of USB fixes for 3.18-rc3.

Mostly usb-serial device ids and gadget fixes for issues that have been
reported.  Full details are in the shortlog.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (1):
      usb: dwc3: pci: Add PCI ID for Intel Braswell

Charles Manning (1):
      usb: dwc2: Bits in bitfield should add up to 32

Dan Williams (1):
      USB: option: add Haier CE81B CDMA modem

Daniele Palmas (1):
      usb: option: add support for Telit LE910

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

Frans Klaver (1):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products

Geert Uytterhoeven (1):
      usb: gadget: udc: USB_GADGET_XILINX should depend on HAS_DMA

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.18-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'usb-serial-3.18-rc3' of git://git.kernel.org/.../johan/usb-serial into usb-linus

Jack Pham (1):
      usb: dwc3: gadget: Properly initialize LINK TRB

Marek Szyprowski (2):
      usb: dwc2: gadget: fix gadget unregistration in udc_stop() function
      usb: dwc2: gadget: disable phy before turning off power regulators

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID

Pavitrakumar Managutte (2):
      usb: gadget: function: Remove redundant usb_free_all_descriptors
      usb: gadget: function: Fixed the return value on error path

Perry Hung (1):
      usb: serial: ftdi_sio: add "bricked" FTDI device PID

Peter Hurley (1):
      USB: kobil_sct: Remove unused transfer buffer allocs

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

Torsten Fleischer (1):
      usb: chipidea: Fix oops when removing the ci_hdrc module

 drivers/usb/chipidea/core.c              |  1 -
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
 drivers/usb/serial/cp210x.c              |  1 +
 drivers/usb/serial/ftdi_sio.c            |  3 ++
 drivers/usb/serial/ftdi_sio_ids.h        | 12 ++++-
 drivers/usb/serial/kobil_sct.c           | 15 ------
 drivers/usb/serial/option.c              | 10 ++++
 32 files changed, 319 insertions(+), 173 deletions(-)
