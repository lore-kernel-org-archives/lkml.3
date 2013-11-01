Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3KAQ7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:59:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3KAQ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:59:33 -0400
Date: Fri, 1 Nov 2013 09:59:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [GIT PATCH] USB fixes for 3.12-final
Message-ID: <20131101165931.GA18020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:

  Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.12-rc8

for you to fetch changes up to e1466ad5b1aeda303f9282463d55798d2eda218c:

  USB: serial: ftdi_sio: add id for Z3X Box device (2013-11-01 09:33:56 -0700)

----------------------------------------------------------------
USB fixes for 3.12-final

Here is a set of patches that revert all of the changes done to the
pl2303 USB serial driver in the 3.12-rc timeframe, as it turns out they
break some devices that work just fine on 3.11.  As it's not a good idea
to break working systems, drop them all and they will be reworked for
future kernel versions such that there is no breakage.

I've also included a MAINTAINERS update for the USB serial subsystem and
a new device id for the ftdi_sio driver as well.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg KH (1):
      USB: Maintainers change for usb serial drivers

Greg Kroah-Hartman (12):
      Revert "USB: pl2303: distinguish between original and cloned HX chips"
      Revert "pl2303: improve the chip type detection/distinction"
      Revert "pl2303: improve the chip type information output on startup"
      Revert "pl2303: simplify the else-if contruct for type_1 chips in pl2303_startup()"
      Revert "usb: pl2303: add two comments concerning the supported baud rates with HX chips"
      Revert "usb: pl2303: also use the divisor based baud rate encoding method for baud rates < 115200 with HX chips"
      Revert "usb: pl2303: increase the allowed baud rate range for the divisor based encoding method"
      Revert "usb: pl2303: move the two baud rate encoding methods to separate functions"
      Revert "usb: pl2303: remove 500000 baud from the list of standard baud rates"
      Revert "usb: pl2303: do not round to the next nearest standard baud rate for the divisor based baud rate encoding method"
      Revert "usb: pl2303: fix+improve the divsor based baud rate encoding method"
      Revert "USB: pl2303: restrict the divisor based baud rate encoding method to the "HX" chip type"

Алексей Крамаренко (1):
      USB: serial: ftdi_sio: add id for Z3X Box device

 MAINTAINERS                       |  53 +-------
 drivers/usb/serial/ftdi_sio.c     |   1 +
 drivers/usb/serial/ftdi_sio_ids.h |   6 +
 drivers/usb/serial/pl2303.c       | 274 ++++++++------------------------------
 4 files changed, 66 insertions(+), 268 deletions(-)
