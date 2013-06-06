Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3FFR5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:57:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3FFR5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:57:47 -0400
Date: Thu, 6 Jun 2013 10:57:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.10-rc5
Message-ID: <20130606175745.GA25961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.10-rc4

for you to fetch changes up to 73228a0538a70ebc4547bd09dee8971360dc1d87:

  USB: option,zte_ev: move most ZTE CDMA devices to zte_ev (2013-06-06 09:06:25 -0700)

----------------------------------------------------------------
USB fixes for 3.10-rc4

Here are a number of USB bugfixes and new device ids for the 3.10-rc5 tree.

Nothing major here, a number of new device ids (and movement from the
option to the zte_ev driver of a number of ids that we had previously
gotten wrong, some xhci bugfixes, some usb-serial driver fixes that were
recently found, some host controller fixes / reverts, and a variety of
smaller other things.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (2):
      USB: revert periodic scheduling bugfix
      USB: EHCI: fix regression related to qh_refresh()

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Dan Williams (1):
      USB: option,zte_ev: move most ZTE CDMA devices to zte_ev

Federico Manzan (1):
      usbfs: Increase arbitrary limit for USB 3 isopkt length

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.10-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2013-05-24' of git://git.kernel.org/.../sarah/xhci into usb-linus

Johan Hovold (14):
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: visor: fix initialisation of Treo/Kyocera devices
      USB: mos7720: fix DMA to stack
      USB: mos7840: fix DMA to stack
      USB: ark3116: fix control-message timeout
      USB: iuu_phoenix: fix bulk-message timeout
      USB: mos7720: fix message timeouts
      USB: zte_ev: fix control-message timeouts
      USB: zte_ev: fix broken open
      USB: keyspan: fix bogus array index
      USB: keyspan: remove unused endpoint-array access
      USB: mos7720: fix hardware flow control
      USB: serial: fix TIOCMIWAIT return value
      USB: whiteheat: fix broken port configuration

Peter Chen (2):
      usb: dwc3: pci: PHY should be deleted later than dwc3 core
      usb: dwc3: exynos: PHY should be deleted later than dwc3 core

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Sarah Sharp (1):
      xhci: Disable D3cold for buggy TI redrivers.

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate

Virupax Sadashivpetimath (1):
      usb: musb: make use_sg flag URB specific

Vladimir Murzin (1):
      xhci: fix list access before init

 drivers/usb/core/devio.c         | 10 ++++---
 drivers/usb/dwc3/dwc3-exynos.c   |  2 +-
 drivers/usb/dwc3/dwc3-pci.c      |  2 +-
 drivers/usb/dwc3/gadget.c        | 16 ++++++++---
 drivers/usb/host/ehci-sched.c    |  9 +++++--
 drivers/usb/host/xhci-mem.c      | 10 ++++---
 drivers/usb/host/xhci-pci.c      |  8 ++++++
 drivers/usb/host/xhci.c          | 16 ++++++++---
 drivers/usb/host/xhci.h          |  3 +++
 drivers/usb/musb/musb_host.c     | 18 ++++++-------
 drivers/usb/musb/musb_host.h     |  1 +
 drivers/usb/serial/ark3116.c     |  2 +-
 drivers/usb/serial/cypress_m8.c  | 18 ++++++++++++-
 drivers/usb/serial/cypress_m8.h  |  4 +++
 drivers/usb/serial/iuu_phoenix.c |  4 +--
 drivers/usb/serial/keyspan.c     | 10 -------
 drivers/usb/serial/mos7720.c     | 25 ++++++++++++-----
 drivers/usb/serial/mos7840.c     | 35 ++++++++++++++++++------
 drivers/usb/serial/option.c      | 26 +++---------------
 drivers/usb/serial/qcserial.c    |  1 +
 drivers/usb/serial/usb-serial.c  |  4 +--
 drivers/usb/serial/visor.c       |  9 +++++++
 drivers/usb/serial/whiteheat.c   |  2 +-
 drivers/usb/serial/zte_ev.c      | 58 ++++++++++++++++++++++++----------------
 24 files changed, 187 insertions(+), 106 deletions(-)
