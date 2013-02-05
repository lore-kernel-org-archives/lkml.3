Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3BERuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:50:20 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:43507 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3BERuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:50:16 -0500
Date: Tue, 5 Feb 2013 09:52:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.8-rc6
Message-ID: <20130205175226.GA17784@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.8-rc6

for you to fetch changes up to 200e0d994d9d1919b28c87f1a5fb99a8e13b8a0f:

  USB: storage: optimize to match the Huawei USB storage devices and support new switch command (2013-02-04 10:41:40 -0800)

----------------------------------------------------------------
USB fixes for 3.8-rc6

Here are a few tiny USB fixes for 3.8-rc6.

Nothing major here, some host controller bug fixes to resolve a number
of bugs that people have reported, and a bunch of additional device ids
are added to a number of drivers (which caused code to be deleted from
the usb-storage driver, always nice.)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (9):
      USB: XHCI: fix memory leak of URB-private data
      USB: EHCI: remove ASS/PSS polling timeout
      USB: EHCI: unlink one async QH at a time
      USB: add usb_hcd_{start,end}_port_resume
      USB: EHCI: notify usbcore about port resumes
      USB: UHCI: notify usbcore about port resumes
      USB: EHCI: fix timer bug affecting port resume
      USB: EHCI: fix for leaking isochronous data
      USB: EHCI: fix bug in scheduling periodic split transfers

Bjørn Mork (1):
      USB: option: add Changhong CH690

Daniele Palmas (2):
      USB: qcserial: add Telit Gobi QDL device
      USB: option: add support for Telit LE920

David Moore (1):
      usb: Prevent dead ports when xhci is not enabled

Greg Kroah-Hartman (1):
      Merge tag 'for-usb-linus-2012-01-24' of git://git.kernel.org/.../sarah/xhci into usb-linus

Lan Tianyu (1):
      usb: Using correct way to clear usb3.0 device's remote wakeup feature.

Luis Llorente Campo (1):
      USB: add OWL CM-160 support to cp210x driver

Nickolai Zeldovich (1):
      drivers: xhci: fix incorrect bit test

Petr Kubánek (1):
      USB: ftdi_sio: add Zolix FTDI PID

Sarah Sharp (2):
      xhci: Fix isoc TD encoding.
      xhci: Fix TD size for isochronous URBs.

Sven Killig (1):
      USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II

fangxiaozhi (2):
      USB: storage: Define a new macro for USB storage match rules
      USB: storage: optimize to match the Huawei USB storage devices and support new switch command

 drivers/usb/core/hcd.c             |  44 +++++
 drivers/usb/core/hub.c             |  70 ++++++--
 drivers/usb/host/ehci-hcd.c        |   1 +
 drivers/usb/host/ehci-hub.c        |   9 +-
 drivers/usb/host/ehci-q.c          |  50 +++---
 drivers/usb/host/ehci-sched.c      |   9 +-
 drivers/usb/host/ehci-timer.c      |  29 ++--
 drivers/usb/host/pci-quirks.c      |   1 +
 drivers/usb/host/uhci-hub.c        |   3 +
 drivers/usb/host/xhci-ring.c       |  13 +-
 drivers/usb/serial/cp210x.c        |   1 +
 drivers/usb/serial/ftdi_sio.c      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h  |   9 +-
 drivers/usb/serial/option.c        |  13 ++
 drivers/usb/serial/qcserial.c      |   1 +
 drivers/usb/storage/initializers.c |  76 ++++++++-
 drivers/usb/storage/initializers.h |   4 +-
 drivers/usb/storage/unusual_devs.h | 329 +------------------------------------
 drivers/usb/storage/usb.c          |  12 ++
 drivers/usb/storage/usual-tables.c |  15 ++
 include/linux/usb.h                |   2 +
 include/linux/usb/hcd.h            |   3 +
 include/uapi/linux/usb/ch9.h       |   6 +
 23 files changed, 310 insertions(+), 392 deletions(-)
