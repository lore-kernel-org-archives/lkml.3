Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325AbaFTTxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:53:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbaFTTxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:53:09 -0400
Date: Fri, 20 Jun 2014 12:57:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.16-rc2
Message-ID: <20140620195710.GA28516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.16-rc2

for you to fetch changes up to 32b36eeae6a859670d2939a7d6136cb5e9ed64f8:

  USB: usbtest: add a timeout for scatter-gather tests (2014-06-17 17:05:50 -0700)

----------------------------------------------------------------
USB fixes for 3.16-rc2

Here are some USB fixes for 3.16-rc2 that resolve some reported issues.
All of these have been in linux-next for a while with no problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (2):
      USB: EHCI: avoid BIOS handover on the HASEE E200
      USB: usbtest: add a timeout for scatter-gather tests

Dan Williams (4):
      usb: fix ->update_hub_device() vs hdev->maxchild
      usb: improve "not suspended yet" message in hub_suspend()
      usb: quiet peer failure warning, disable poweroff
      usb: fix hub-port pm_runtime_enable() vs runtime pm transitions

Mathias Nyman (1):
      xhci: Fix sleeping with IRQs disabled in xhci_stop_device()

 drivers/usb/core/hub.c        | 33 +++++++++-------
 drivers/usb/core/hub.h        |  2 +
 drivers/usb/core/port.c       | 89 +++++++++++++++++++++++++++++++------------
 drivers/usb/host/pci-quirks.c | 19 +++++++--
 drivers/usb/host/xhci-hub.c   |  2 +-
 drivers/usb/misc/usbtest.c    | 16 +++++++-
 6 files changed, 119 insertions(+), 42 deletions(-)
