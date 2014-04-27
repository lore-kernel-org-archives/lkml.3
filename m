Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaD0Af6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:35:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaD0Afe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:35:34 -0400
Date: Sat, 26 Apr 2014 17:36:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.15-rc333
Message-ID: <20140427003616.GA2969@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.15-rc3

for you to fetch changes up to 34f972d6156fe9eea2ab7bb418c71f9d1d5c8e7b:

  usb: option: add and update a number of CMOTech devices (2014-04-25 11:35:04 -0700)

----------------------------------------------------------------
USB fixes for 3.15-rc3

Here are a number of USB fixes for 3.15-rc3.  The majority are gadget
fixes, as we didn't get any of those in for 3.15-rc2.  The others are
all over the place, and there's a number of new device id addtions as
well.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Arnd Bergmann (1):
      phy: exynos: fix building as a module

Bjørn Mork (6):
      usb: qcserial: add Sierra Wireless EM7355
      usb: qcserial: add Sierra Wireless MC73xx
      usb: qcserial: add Sierra Wireless MC7305/MC7355
      usb: option: add Olivetti Olicard 500
      usb: option: add Alcatel L800MA
      usb: option: add and update a number of CMOTech devices

Chao Bi (1):
      usb: gadget: ffs: race between ffs_epfile_io() and ffs_func_eps_disable()

Daniel Mack (2):
      usb: musb: dsps: move debugfs_remove_recursive()
      usb: phy: am335x-control: wait 1ms after power-up transitions

David Cohen (1):
      usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

Denis Turischev (1):
      xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Fabio Estevam (1):
      usb: gadget: rndis: Include "u_rndis.h"

Felipe Balbi (3):
      usb: musb: fix PHY power on/off
      usb: musb: omap2430: make sure clocks are enabled when running mailbox
      Revert "usb: gadget: u_ether: move hardware transmit to RX NAPI"

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-v3.15-rc3' of git://git.kernel.org/.../balbi/usb into usb-linus

Grygorii Strashko (1):
      phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY

Igor Gnatenko (1):
      xhci: extend quirk for Renesas cards

Jack Pham (1):
      usb: dwc3: gadget: Iterate only over valid endpoints

Jean Delvare (1):
      phy: restore OMAP_CONTROL_PHY dependencies

Johan Hovold (2):
      USB: serial: fix sysfs-attribute removal deadlock
      USB: io_ti: fix firmware download on big-endian machines

Julius Werner (1):
      usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

Lubomir Rintel (1):
      usb: gadget: gadgetfs: Initialize CHIP to NULL before UDC probe

Macpaul Lin (1):
      usb: gadget: f_rndis: reduce NETTX irq caused by free skb header

Mathias Krause (1):
      usb: phy: return an error in usb_get_phy() if try_module_get() fails

Peter Chen (1):
      usb: chipidea: coordinate usb phy initialization for different phy type

Roger Quadros (2):
      usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1
      usb: dwc3: core: Fix gadget for system suspend/resume

Sergei Shtylyov (1):
      phy: fix kernel oops in phy_lookup()

Suresh Gupta (2):
      usb : gadget : fsl: fix the fault issue on rmmod
      usb: gadget: fsl driver pullup fix

Thomas Pugliese (3):
      uwb: don't call spin_unlock_irq in a USB completion handler
      usb: wusbcore: convert nested lock to use spin_lock instead of spin_lock_irq
      usb: wusbcore: fix panic in wusbhc_chid_set

 drivers/phy/Kconfig                  |   1 +
 drivers/phy/Makefile                 |   9 ++--
 drivers/phy/phy-core.c               |   3 ++
 drivers/usb/chipidea/core.c          |  37 +++++++++++--
 drivers/usb/dwc3/core.c              |   2 +-
 drivers/usb/dwc3/gadget.c            |  12 ++---
 drivers/usb/gadget/f_fs.c            |   7 +++
 drivers/usb/gadget/f_rndis.c         |   2 +-
 drivers/usb/gadget/fsl_udc_core.c    |   6 ++-
 drivers/usb/gadget/inode.c           |   1 +
 drivers/usb/gadget/rndis.c           |   1 +
 drivers/usb/gadget/u_ether.c         | 101 ++++++++++++-----------------------
 drivers/usb/gadget/zero.c            |   2 +-
 drivers/usb/host/xhci-pci.c          |   6 +--
 drivers/usb/host/xhci-ring.c         |  67 +++++++++++------------
 drivers/usb/host/xhci.c              |   7 ++-
 drivers/usb/host/xhci.h              |   2 -
 drivers/usb/musb/musb_dsps.c         |   5 +-
 drivers/usb/musb/omap2430.c          |   8 +++
 drivers/usb/phy/phy-am335x-control.c |   9 ++++
 drivers/usb/phy/phy.c                |   3 ++
 drivers/usb/serial/io_ti.c           |  50 +++++++++++------
 drivers/usb/serial/option.c          |  81 ++++++++++++++++++++++++++--
 drivers/usb/serial/qcserial.c        |   9 ++++
 drivers/usb/serial/usb-serial.c      |   4 +-
 drivers/usb/wusbcore/mmc.c           |   2 +-
 drivers/usb/wusbcore/wa-xfer.c       |   4 +-
 drivers/uwb/drp.c                    |   9 ++--
 include/linux/phy/phy.h              |  16 ++++++
 29 files changed, 304 insertions(+), 162 deletions(-)
