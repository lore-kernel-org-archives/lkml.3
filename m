Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaDRVhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:37:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaDRVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:37:16 -0400
Date: Fri, 18 Apr 2014 14:37:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.15-rc2
Message-ID: <20140418213725.GA3557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.15-rc2

for you to fetch changes up to 94d72f008909610710bb1841d665eeeb010a0be1:

  uas: fix deadlocky memory allocations (2014-04-16 14:04:59 -0700)

----------------------------------------------------------------
USB fixes for 3.15-rc2

Here are a number of tiny USB fixes and new device ids for 3.15-rc2.
Nothing major, just issues some people have reported.

All of these have been in linux-next.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Alan Stern (1):
      USB: fix crash during hotplug of PCI USB controller card

Alexey Khoroshilov (1):
      USB: cdc-acm: fix double usb_autopm_put_interface() in acm_port_activate()

Daeseok Youn (1):
      uwb: adds missing error handling

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2

Johan Hovold (2):
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
      USB: usb_wwan: fix handling of missing bulk endpoints

Laurent Pinchart (2):
      USB: ohci-jz4740: Fix uninitialized variable warning
      USB: ohci-jz4740: FEAT_POWER is a port feature, not a hub feature

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards

Oliver Neukum (3):
      uas: fix GFP_NOIO under spinlock
      uas: fix error handling during scsi_scan()
      uas: fix deadlocky memory allocations

Peter Chen (1):
      usb: usb-common: fix typo for usb_state_string

Stephen Warren (1):
      USB: EHCI: tegra: set txfill_tuning

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Vivek Gautam (2):
      usb: ehci-exynos: Return immediately from suspend if ehci_suspend fails
      usb: ehci-platform: Return immediately from suspend if ehci_suspend fails

 drivers/usb/class/cdc-acm.c       | 34 +++++++++++++++++++++++++---------
 drivers/usb/core/hcd-pci.c        |  2 +-
 drivers/usb/host/ehci-exynos.c    |  2 ++
 drivers/usb/host/ehci-platform.c  |  2 ++
 drivers/usb/host/ehci-tegra.c     | 23 +++++++++++++++++++++++
 drivers/usb/host/ohci-jz4740.c    |  6 +++---
 drivers/usb/serial/cp210x.c       |  1 +
 drivers/usb/serial/ftdi_sio.c     | 33 +++++++++++++++++++++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h | 37 +++++++++++++++++++++++++++++++++++++
 drivers/usb/serial/option.c       |  2 ++
 drivers/usb/serial/pl2303.c       |  3 +++
 drivers/usb/serial/pl2303.h       |  5 ++++-
 drivers/usb/serial/sierra.c       |  1 -
 drivers/usb/serial/usb_wwan.c     |  9 +++------
 drivers/usb/storage/uas.c         | 13 +++++++------
 drivers/usb/usb-common.c          |  2 +-
 drivers/uwb/drp.c                 |  5 ++++-
 17 files changed, 151 insertions(+), 29 deletions(-)
