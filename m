Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab3C1RSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:18:36 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:55107 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab3C1RSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:18:34 -0400
Date: Thu, 28 Mar 2013 10:18:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.9-rc4
Message-ID: <20130328171832.GA2704@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c51d41a1dd8f23a06a4ed651ebb9617de7f59368:

  tty: serial: fix typo "SERIAL_S3C2412" (2013-03-12 08:53:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.9-rc4

for you to fetch changes up to 855f6fd941019ecc9525ca038b78f50c6c1e80a8:

  Xilinx: ARM: UART: clear pending irqs before enabling irqs (2013-03-25 16:26:23 -0700)

----------------------------------------------------------------
TTY/serial fixes for 3.9-rc4

Here are some tty/serial driver fixes for 3.9.

The big thing here is the fix for the huge mess we caused renaming the 8250
driver accidentally in the 3.7 kernel release, without realizing that there
were users of the module options that suddenly broke.  This is now resolved,
and, to top the injury off, we have a backwards-compatible option for those
users who got used to the new name since 3.7.  Ugh, sorry about that.

Other than that, some other minor fixes for issues that have been reported by
users.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Jiri Slaby (2):
      TTY: 8250, revert module name change
      TTY: 8250, deprecated 8250_core.* options

John Linn (1):
      Xilinx: ARM: UART: clear pending irqs before enabling irqs

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix

Wang YanQing (1):
      serial: 8250_pci: Add WCH CH352 quirk to avoid Xscale detection

 drivers/tty/serial/8250/{8250.c => 8250_core.c} |  6 ++++--
 drivers/tty/serial/8250/8250_pci.c              | 13 +++++++++++++
 drivers/tty/serial/8250/Kconfig                 | 17 +++++++++++++++++
 drivers/tty/serial/8250/Makefile                |  8 ++++----
 drivers/tty/serial/atmel_serial.c               | 11 +++++------
 drivers/tty/serial/xilinx_uartps.c              |  2 ++
 6 files changed, 45 insertions(+), 12 deletions(-)
 rename drivers/tty/serial/8250/{8250.c => 8250_core.c} (99%)
