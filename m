Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaK1Wlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:41:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaK1Wlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:41:51 -0500
Date: Fri, 28 Nov 2014 14:40:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.18-rc7
Message-ID: <20141128224028.GA29538@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.18-rc7

for you to fetch changes up to 263e80b43559a6103e178a9176938ce171b23872:

  usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000 (2014-11-24 17:01:55 -0800)

----------------------------------------------------------------
USB fixes for 3.18-rc7

Here are some USB driver fixes and new device ids for 3.18-rc7.

Full details are in the shortlog, and all of these have been in the
linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Felipe Balbi (1):
      usb: dwc3: ep0: fix for dead code

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.18-rc5' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'usb-serial-3.18-rc6' of git://git.kernel.org/.../johan/usb-serial into usb-linus

Hans de Goede (2):
      USB: uas: Add no-uas quirk for Hitachi usb-3 enclosures 4971:1012
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Johan Hovold (3):
      USB: keyspan: fix tty line-status reporting
      USB: keyspan: fix overrun-error reporting
      USB: ssu100: fix overrun-error reporting

Lu Baolu (2):
      Revert "xhci: clear root port wake on bits if controller isn't wake-up capable"
      usb: xhci: rework root port wake bits if controller isn't allowed to wakeup

Mathias Nyman (2):
      USB: xhci: don't start a halted endpoint before its new dequeue is set
      USB: xhci: Reset a halted endpoint immediately when we encounter a stall.

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

 drivers/usb/core/quirks.c         |   3 ++
 drivers/usb/dwc3/ep0.c            |   8 +--
 drivers/usb/host/xhci-hub.c       |   5 +-
 drivers/usb/host/xhci-pci.c       |   2 +-
 drivers/usb/host/xhci-plat.c      |  10 +++-
 drivers/usb/host/xhci-ring.c      |  43 ++++-----------
 drivers/usb/host/xhci.c           | 107 ++++++++++++++++++++------------------
 drivers/usb/host/xhci.h           |   2 +-
 drivers/usb/serial/cp210x.c       |   1 +
 drivers/usb/serial/ftdi_sio.c     |  33 ++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |  39 ++++++++++++--
 drivers/usb/serial/keyspan.c      |  97 ++++++++++++++++++++--------------
 drivers/usb/serial/ssu100.c       |  11 ++--
 drivers/usb/storage/unusual_uas.h |   7 +++
 14 files changed, 224 insertions(+), 144 deletions(-)
