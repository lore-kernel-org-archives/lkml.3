Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3HPCP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:15:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3HPCP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:15:56 -0400
Date: Thu, 15 Aug 2013 19:17:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.11-rc6
Message-ID: <20130816021731.GA8424@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.11-rc6

for you to fetch changes up to ff8a43c10f1440f07a5faca0c1556921259f7f76:

  USB: keyspan: fix null-deref at disconnect and release (2013-08-14 12:49:27 -0700)

----------------------------------------------------------------
USB fixes for 3.11-rc6

Here are some small USB fixes for 3.11-rc6 that have accumulated.

Nothing huge, a EHCI fix that solves a much-reported audio USB problem,
some usb-serial driver endian fixes and other minor fixes, a wireless
USB oops fix, and two new quirks.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: EHCI: accept very late isochronous URBs

Johan Hovold (6):
      USB: mos7840: fix big-endian probe
      USB: usbtmc: fix big-endian probe of Rigol devices
      USB: adutux: fix big-endian device-type reporting
      USB: ti_usb_3410_5052: fix big-endian firmware handling
      USB: mos7720: fix broken control requests
      USB: keyspan: fix null-deref at disconnect and release

Matt Burtch (1):
      USB-Serial: Fix error handling of usb_wwan

Oliver Neukum (1):
      usb: add two quirky touchscreen

Thomas Pugliese (1):
      wusbcore: fix kernel panic when disconnecting a wireless USB->serial device

 drivers/usb/class/usbtmc.c            |  8 ++++----
 drivers/usb/core/quirks.c             |  6 ++++++
 drivers/usb/host/ehci-sched.c         | 13 ++++++-------
 drivers/usb/misc/adutux.c             |  2 +-
 drivers/usb/serial/keyspan.c          |  2 +-
 drivers/usb/serial/mos7720.c          | 21 ++++++++++++++-------
 drivers/usb/serial/mos7840.c          |  2 +-
 drivers/usb/serial/ti_usb_3410_5052.c |  9 +++++----
 drivers/usb/serial/usb_wwan.c         | 20 ++++++++++----------
 drivers/usb/wusbcore/wa-xfer.c        |  9 +++++++--
 10 files changed, 55 insertions(+), 37 deletions(-)
