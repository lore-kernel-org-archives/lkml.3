Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbaGDA5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 20:57:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbaGDA5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 20:57:12 -0400
Date: Thu, 3 Jul 2014 18:01:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.16-rc4
Message-ID: <20140704010128.GA21150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.16-rc4

for you to fetch changes up to e4adcff09ca39ecbcc4851d40d0f0a5458e7b77a:

  usb: chipidea: udc: delete td from req's td list at ep_dequeue (2014-07-01 23:06:02 -0700)

----------------------------------------------------------------
USB bugfixes for 3.16-rc4

Here's a round of USB bugfixes, quirk additions, and new device ids for
3.16-rc4.  Nothing major in here at all, just a bunch of tiny changes.
All have been in linux-next with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      usb-storage/SCSI: Add broken_fua blacklist flag

Andreas Larsson (1):
      usb: gadget: gr_udc: Fix check for invalid number of microframes

Andrzej Pietrasiewicz (2):
      usb: gadget: OS descriptors configfs cleanup
      usb: gadget: OS descriptors: provide interface directory names

Bjørn Mork (1):
      usb: option: add/modify Olivetti Olicard modems

Dan Carpenter (1):
      usb: gadget: f_rndis: fix an error code on allocation failure

Ezequiel Garcia (1):
      usb: musb: Fix panic upon musb_am335x module removal

Felipe Balbi (1):
      Revert "tools: ffs-test: convert to new descriptor format fixing compilation error"

George Cherian (3):
      usb: dwc3: dwc3-omap: Fix the crash on module removal
      usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in prepare/complete
      usb: musb: core: Handle Babble condition only in HOST mode

Greg Kroah-Hartman (3):
      Merge tag 'fixes-for-v3.16-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'usb-serial-3.16-rc3' of git://git.kernel.org/.../johan/usb-serial into usb-linus
      Merge tag 'fixes-for-v3.16-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus

Jeff Westfahl (1):
      usb: gadget: u_ether: synchronize with transmit when stopping queue

Johan Hovold (3):
      MAINTAINERS: drop two usb-serial subdriver entries
      USB: ftdi_sio: fix null deref at port probe
      MAINTAINERS: update e-mail address

Kuninori Morimoto (1):
      usb: renesas: gadget: fixup: complete STATUS stage after receiving

Linus Walleij (1):
      usb: musb: ux500: don't propagate the OF node

Lothar Waßmann (1):
      usb: musb: dsps: fix the base address for accessing the mode register

Lu Baolu (1):
      xhci: clear root port wake on bits if controller isn't wake-up capable

Marcus Nutzinger (1):
      usb: gadget: gadgetfs: correct dev state

Mathias Nyman (2):
      xhci: Use correct SLOT ID when handling a reset device command
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Michal Nazarewicz (4):
      tools: ffs-test: convert to new descriptor format fixing compilation error
      usb: gadget: f_fs: fix NULL pointer dereference when there are no strings
      usb: gadget: f_fs: resurect usb_functionfs_descs_head structure
      tools: ffs-test: fix header values endianess

Oliver Neukum (1):
      USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Peter Chen (1):
      usb: chipidea: udc: delete td from req's td list at ep_dequeue

Srinivas Kandagatla (2):
      usb: phy: msm: Do not do runtime pm if the phy is not idle
      usb: Kconfig: make EHCI_MSM selectable for QCOM SOCs

Thomas Gleixner (1):
      usb: musb: Ensure that cppi41 timer gets armed on premature DMA TX irq

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Zhuang Jin Can (1):
      usb: dwc3: gadget: check link trb after free_slot is increased

 MAINTAINERS                         | 14 +-------------
 drivers/scsi/sd.c                   |  5 ++++-
 drivers/usb/chipidea/udc.c          |  7 +++++++
 drivers/usb/dwc3/Kconfig            |  1 +
 drivers/usb/dwc3/dwc3-omap.c        | 17 ++++++++++++++---
 drivers/usb/dwc3/gadget.c           |  8 ++++----
 drivers/usb/gadget/configfs.c       | 37 +++++++++++++++++++------------------
 drivers/usb/gadget/configfs.h       |  1 +
 drivers/usb/gadget/f_fs.c           | 12 +++++++-----
 drivers/usb/gadget/f_rndis.c        |  6 ++++--
 drivers/usb/gadget/gr_udc.c         |  5 +++--
 drivers/usb/gadget/inode.c          |  7 ++++++-
 drivers/usb/gadget/u_ether.c        |  3 +++
 drivers/usb/host/Kconfig            |  2 +-
 drivers/usb/host/xhci-hub.c         |  5 ++++-
 drivers/usb/host/xhci-ring.c        |  9 ++++++---
 drivers/usb/host/xhci.c             | 10 +++++++---
 drivers/usb/musb/musb_am335x.c      | 23 ++++++-----------------
 drivers/usb/musb/musb_core.c        |  2 +-
 drivers/usb/musb/musb_cppi41.c      |  2 +-
 drivers/usb/musb/musb_dsps.c        |  9 ++++-----
 drivers/usb/musb/ux500.c            |  1 -
 drivers/usb/phy/phy-msm-usb.c       |  4 +++-
 drivers/usb/renesas_usbhs/fifo.c    |  8 ++++++++
 drivers/usb/serial/ftdi_sio.c       |  7 +++++--
 drivers/usb/serial/option.c         | 26 ++++++++++++++++++++------
 drivers/usb/storage/scsiglue.c      |  4 ++++
 drivers/usb/storage/unusual_devs.h  |  7 +++++++
 include/linux/usb_usual.h           |  4 +++-
 include/scsi/scsi_device.h          |  1 +
 include/uapi/linux/usb/functionfs.h |  7 +++++++
 tools/usb/ffs-test.c                |  4 ++--
 32 files changed, 164 insertions(+), 94 deletions(-)
