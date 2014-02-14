Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaBNVZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:25:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaBNVZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:25:34 -0500
Date: Fri, 14 Feb 2014 13:26:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.14-rc3
Message-ID: <20140214212653.GA19515@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.14-rc3

for you to fetch changes up to 3635c7e2d59f7861afa6fa5e87e2a58860ff514d:

  usb: option: blacklist ZTE MF667 net interface (2014-02-11 15:33:54 -0800)

----------------------------------------------------------------
USB fixes for 3.14-rc3

Here is a bunch of USB fixes for 3.14-rc3.  Most of these are xhci
reverts, fixing a bunch of reported issues with USB 3 host controller
issues that loads of people have been hitting (with the exception of
kernel developers, all of our machines seem to be working fine, which is
why these took so long to get resolved...)

There are some other minor fixes and new device ids, as ususal.  All
have been in linux-next successfully.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (3):
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: enable multi-LUN scanning when needed

Andre Heider (1):
      usb: dwc2: bail out early when booting with "nousb"

Bjørn Mork (2):
      usb: ftdi_sio: add Mindstorms EV3 console adapter
      usb: qcserial: add Netgear Aircard 340U

Christian Engelmayer (1):
      usb: core: Fix potential memory leak adding dyn USBdevice IDs

Greg Kroah-Hartman (2):
      Merge tag 'for-usb-linus-2014-02-04' of git://git.kernel.org/.../sarah/xhci into usb-linus
      Merge tag 'for-usb-linus-2014-02-11' of git://git.kernel.org/.../sarah/xhci into usb-linus

Jan Moskyto Matejka (1):
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Josh Boyer (1):
      usb: phy: move some error messages to debug

Kristóf Ralovich (1):
      USB: simple: add Dynastream ANT USB-m Stick device support

Paul Zimmerman (2):
      usb: dwc2: fix role switch breakage
      usb: dwc2: fix memory corruption in dwc2 driver

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface

Sarah Sharp (8):
      xhci: Fix resume issues on Renesas chips in Samsung laptops
      Revert "usbcore: set lpm_capable field for LPM capable root hubs"
      Revert "xhci: replace xhci_write_64() with writeq()"
      Revert "xhci: replace xhci_read_64() with readq()"
      xhci 1.0: Limit arbitrarily-aligned scatter gather.
      Revert "xhci: Set scatter-gather limit to avoid failed block writes."
      Revert "xhci: Avoid infinite loop when sg urb requires too many trbs"
      Revert "usb: xhci: Link TRB must not occur within a USB payload burst"

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs

 drivers/usb/core/driver.c              | 24 ++++++++----
 drivers/usb/core/hcd.c                 |  1 -
 drivers/usb/core/hub.c                 |  7 +---
 drivers/usb/core/usb.h                 |  1 -
 drivers/usb/dwc2/core.c                |  2 +-
 drivers/usb/dwc2/hcd.c                 | 11 ------
 drivers/usb/dwc2/platform.c            |  3 ++
 drivers/usb/host/xhci-dbg.c            |  6 +--
 drivers/usb/host/xhci-mem.c            | 14 +++----
 drivers/usb/host/xhci-pci.c            |  5 +++
 drivers/usb/host/xhci-ring.c           | 68 +++++-----------------------------
 drivers/usb/host/xhci.c                | 38 +++++++++++--------
 drivers/usb/host/xhci.h                | 41 ++++++++++++++------
 drivers/usb/phy/phy.c                  |  8 ++--
 drivers/usb/serial/ftdi_sio.c          |  3 ++
 drivers/usb/serial/ftdi_sio_ids.h      |  7 ++++
 drivers/usb/serial/option.c            |  3 +-
 drivers/usb/serial/qcserial.c          |  3 ++
 drivers/usb/serial/usb-serial-simple.c |  3 +-
 drivers/usb/storage/Kconfig            |  4 +-
 drivers/usb/storage/scsiglue.c         |  6 +++
 drivers/usb/storage/unusual_cypress.h  |  2 +-
 drivers/usb/storage/unusual_devs.h     |  7 ++++
 include/linux/usb.h                    |  2 -
 scripts/mod/file2alias.c               |  4 +-
 25 files changed, 138 insertions(+), 135 deletions(-)
