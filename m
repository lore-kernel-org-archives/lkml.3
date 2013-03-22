Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422911Ab3CVSTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:19:06 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49079 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422814Ab3CVSTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:19:04 -0400
Date: Fri, 22 Mar 2013 11:19:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.9-rc3
Message-ID: <20130322181900.GA7188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1d9d8639c063caf6efc2447f5f26aa637f844ff6:

  perf,x86: fix kernel crash with PEBS/BTS after suspend/resume (2013-03-15 09:26:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.9-rc3

for you to fetch changes up to fc98ab873aa3dbe783ce56a2ffdbbe7c7609521a:

  USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT (2013-03-21 15:59:05 -0700)

----------------------------------------------------------------
USB fixes for 3.9-rc3

Here are a number of USB fixes that resolve issues that have been reported
against 3.9-rc3.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (4):
      USB: EHCI: fix regression during bus resume
      usb: gadget: udc-core: fix a regression during gadget driver unbinding
      USB: gadget: net2280: remove leftover driver->unbind call in error pathway
      USB: EHCI: fix regression in QH unlinking

Alexey Khoroshilov (1):
      usb: cdc-acm: fix error handling in acm_probe()

Andrzej Pietrasiewicz (1):
      usb: gadget: ffs: fix enable multiple instances

Bo Shen (1):
      usb: gadget: u_serial: fix typo which cause build warning

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register

Fabio Estevam (1):
      usb: ulpi: Define a *otg_ulpi_create no-op

Felipe Balbi (1):
      usb: gadget: net22xx: fix ->disconnect reporting

Greg Kroah-Hartman (2):
      Merge tag 'for-usb-linus-2013-03-18' of git://git.kernel.org/.../sarah/xhci into usb-linus
      Merge tag 'fixes-for-v3.9-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus

Hannes Reinecke (1):
      USB: xhci: correctly enable interrupts

Johan Hovold (21):
      USB: cdc-acm: fix device unregistration
      USB: garmin_gps: fix memory leak on disconnect
      USB: io_ti: fix get_icount for two port adapters
      USB: serial: fix interface refcounting
      USB: serial: add modem-status-change wait queue
      USB: ark3116: fix use-after-free in TIOCMIWAIT
      USB: ch341: fix use-after-free in TIOCMIWAIT
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
      USB: f81232: fix use-after-free in TIOCMIWAIT
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
      USB: io_ti: fix use-after-free in TIOCMIWAIT
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix broken TIOCMIWAIT
      USB: mos7840: fix use-after-free in TIOCMIWAIT
      USB: oti6858: fix use-after-free in TIOCMIWAIT
      USB: pl2303: fix use-after-free in TIOCMIWAIT
      USB: quatech2: fix use-after-free in TIOCMIWAIT
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
      USB: ssu100: fix use-after-free in TIOCMIWAIT
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT

Kishon Vijay Abraham I (1):
      usb: musb: gadget: do *unmap_dma_buffer* only for valid DMA addr

Mikhail Kshevetskiy (1):
      usb: musb: da8xx: Fix build breakage due to typo

Paul Bolle (1):
      usb: gadget: net2272: finally convert "CONFIG_USB_GADGET_NET2272_DMA"

Truls Bengtsson (1):
      usb: gadget: f_rndis: Avoid to use ERROR macro if cdev can be null

 drivers/usb/class/cdc-acm.c           | 22 +++++++++++++++++++---
 drivers/usb/core/hcd-pci.c            | 23 ++++++++++++++---------
 drivers/usb/gadget/f_rndis.c          |  3 +--
 drivers/usb/gadget/g_ffs.c            |  4 ++--
 drivers/usb/gadget/net2272.c          |  9 ++++++++-
 drivers/usb/gadget/net2280.c          |  8 +++++++-
 drivers/usb/gadget/u_serial.c         |  2 +-
 drivers/usb/gadget/udc-core.c         |  2 +-
 drivers/usb/host/ehci-hcd.c           |  1 +
 drivers/usb/host/ehci-hub.c           |  2 +-
 drivers/usb/host/ehci-q.c             | 13 +++++++++++++
 drivers/usb/host/ehci-timer.c         |  2 +-
 drivers/usb/host/xhci.c               |  3 ++-
 drivers/usb/host/xhci.h               |  4 ++--
 drivers/usb/musb/da8xx.c              |  2 +-
 drivers/usb/musb/musb_gadget.c        |  9 +++++++--
 drivers/usb/serial/ark3116.c          | 10 ++++++----
 drivers/usb/serial/ch341.c            | 11 ++++++-----
 drivers/usb/serial/cypress_m8.c       | 14 ++++++++------
 drivers/usb/serial/f81232.c           |  9 +++++----
 drivers/usb/serial/ftdi_sio.c         | 19 ++++++++-----------
 drivers/usb/serial/garmin_gps.c       |  7 +------
 drivers/usb/serial/io_edgeport.c      | 12 +++++++-----
 drivers/usb/serial/io_ti.c            | 13 +++++++------
 drivers/usb/serial/mct_u232.c         | 13 +++++++------
 drivers/usb/serial/mos7840.c          | 16 ++++++++++------
 drivers/usb/serial/oti6858.c          | 10 ++++++----
 drivers/usb/serial/pl2303.c           | 11 ++++++-----
 drivers/usb/serial/quatech2.c         | 12 +++++++-----
 drivers/usb/serial/spcp8x5.c          |  9 +++++----
 drivers/usb/serial/ssu100.c           | 12 +++++++-----
 drivers/usb/serial/ti_usb_3410_5052.c | 10 ++++++----
 drivers/usb/serial/usb-serial.c       |  3 ++-
 drivers/usb/storage/unusual_devs.h    |  7 +++++++
 include/linux/usb/serial.h            |  2 ++
 include/linux/usb/ulpi.h              |  8 ++++++++
 36 files changed, 202 insertions(+), 115 deletions(-)
