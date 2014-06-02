Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaFBWGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:06:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFBWG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:06:29 -0400
Date: Mon, 2 Jun 2014 15:10:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.15-rc8
Message-ID: <20140602221007.GA22601@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.15-rc8

for you to fetch changes up to 5dc2808c4729bf080487e61b80ee04e0fdb12a37:

  xhci: delete endpoints from bandwidth list before freeing whole device (2014-05-28 14:53:53 -0700)

----------------------------------------------------------------
USB fixes for 3.15-rc8

Here are some fixes for 3.15-rc8 that resolve a number of tiny USB
issues that have been reported, and there are some new device ids as
well.

All have been tested in linux-next.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Bjørn Mork (1):
      usb: cdc-wdm: export cdc-wdm uapi header

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Greg Kroah-Hartman (1):
      USB: cdc-wdm: properly include types.h

Johan Hovold (1):
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Mathias Nyman (2):
      usb: pci-quirks: Prevent Sony VAIO t-series from switching usb ports
      xhci: delete endpoints from bandwidth list before freeing whole device

 drivers/usb/core/driver.c         |  9 ++++++---
 drivers/usb/core/hub.c            | 15 +++++++++++++--
 drivers/usb/host/pci-quirks.c     |  7 +++++++
 drivers/usb/host/xhci-mem.c       | 20 ++++++++++----------
 drivers/usb/serial/ftdi_sio.c     |  2 ++
 drivers/usb/serial/ftdi_sio_ids.h |  5 +++++
 drivers/usb/serial/io_ti.c        |  2 +-
 drivers/usb/serial/io_usbvend.h   |  2 +-
 drivers/usb/serial/option.c       |  2 ++
 include/uapi/linux/usb/Kbuild     |  1 +
 include/uapi/linux/usb/cdc-wdm.h  |  2 ++
 11 files changed, 50 insertions(+), 17 deletions(-)
