Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaCIBPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 20:15:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCIBPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 20:15:50 -0500
Date: Sat, 8 Mar 2014 17:16:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.14-rc6
Message-ID: <20140309011626.GA12821@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.14-rc6

for you to fetch changes up to 469d417b68958a064c09e7875646c97c6e783dfc:

  Revert "USBNET: ax88179_178a: enable tso if usb host supports sg dma" (2014-03-07 11:48:13 -0800)

----------------------------------------------------------------
USB fixes for 3.14-rc6

Here are 4 USB fixes for your current tree.

Two of them are reverts to hopefully resolve the nasty XHCI regressions
we have been having on some types of devices.  The other two are quirks
for some Logitech video devices.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests

Mathias Nyman (2):
      Revert "xhci 1.0: Limit arbitrarily-aligned scatter gather."
      Revert "USBNET: ax88179_178a: enable tso if usb host supports sg dma"

 drivers/net/usb/ax88179_178a.c |  8 --------
 drivers/usb/core/config.c      |  4 ++++
 drivers/usb/core/quirks.c      |  4 ++++
 drivers/usb/host/xhci.c        | 14 +++-----------
 4 files changed, 11 insertions(+), 19 deletions(-)
