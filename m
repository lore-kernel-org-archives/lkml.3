Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab3C1RTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:19:21 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61927 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3C1RTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:19:19 -0400
Date: Thu, 28 Mar 2013 10:19:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.9-rc4
Message-ID: <20130328171917.GA2737@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.9-rc4

for you to fetch changes up to 482b0b5d82bd916cc0c55a2abf65bdc69023b843:

  usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD (2013-03-28 08:50:22 -0700)

----------------------------------------------------------------
USB fixes for 3.9-rc4

Here are some USB fixes to resolve issues reported recently, as well as a new
device id for the ftdi_sio driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge tag 'for-usb-linus-2013-03-26' of git://git.kernel.org/.../sarah/xhci into usb-linus

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Lan Tianyu (2):
      usb: add find_raw_port_number callback to struct hc_driver()
      usb/acpi: binding xhci root hub usb port with ACPI

Ming Lei (1):
      USB: serial: fix hang when opening port

Peter Chen (1):
      usb: xhci: fix build warning

Roland Stigge (1):
      usb: Fix compile error by selecting USB_OTG_UTILS

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.

Soeren Moch (1):
      USB: EHCI: fix bug in iTD/siTD DMA pool allocation

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.

 drivers/usb/core/hcd.c            |  8 +++++
 drivers/usb/core/usb-acpi.c       |  8 ++++-
 drivers/usb/gadget/Kconfig        |  1 +
 drivers/usb/host/ehci-sched.c     |  2 ++
 drivers/usb/host/xhci-mem.c       | 36 +++++------------------
 drivers/usb/host/xhci-pci.c       |  1 +
 drivers/usb/host/xhci-ring.c      | 61 ++++++++++++++++++++++-----------------
 drivers/usb/host/xhci.c           | 22 ++++++++++++++
 drivers/usb/host/xhci.h           |  5 ++++
 drivers/usb/phy/Kconfig           |  1 +
 drivers/usb/serial/ftdi_sio.c     |  1 +
 drivers/usb/serial/ftdi_sio_ids.h |  7 +++++
 drivers/usb/serial/usb-serial.c   |  1 +
 include/linux/usb/hcd.h           |  2 ++
 14 files changed, 101 insertions(+), 55 deletions(-)
