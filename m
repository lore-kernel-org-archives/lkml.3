Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300Ab3CMU6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:58:19 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45795 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:58:16 -0400
Date: Wed, 13 Mar 2013 13:58:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.9-rc2
Message-ID: <20130313205814.GA17563@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.9-rc2

for you to fetch changes up to c51d41a1dd8f23a06a4ed651ebb9617de7f59368:

  tty: serial: fix typo "SERIAL_S3C2412" (2013-03-12 08:53:23 -0700)

----------------------------------------------------------------
TTY/Serial fixes for 3.9-rc2

Here are some tty/serial driver fixes for 3.9

We finally mute the annoying WARN_ON that lots of people are hitting and
it turns out isn't needed anymore.  Also add a few new device ids and a
some other minor fixes.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Anatolij Gustschin (1):
      tty: serial: mpc5xxx: fix PSC clock name bug

Jiri Slaby (1):
      TTY: disable debugging warning

Jonas Gorski (1):
      serial: bcm63xx_uart: fix compilation after "TTY: switch tty_insert_flip_char"

Josh Boyer (1):
      serial: 8250: Keep 8250.<xxxx> module options functional after driver rename

Ley Foon Tan (1):
      tty/serial: Add support for Altera serial port

Paul Bolle (2):
      tty: serial: fix typo "ARCH_S5P6450"
      tty: serial: fix typo "SERIAL_S3C2412"

Scott Ashcroft (1):
      Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards

Sean Young (1):
      tty/8250_pnp: serial port detection regression since v3.7

Tony Prisk (1):
      tty: serial: vt8500: Unneccessary duplicated clock code removed

Wang YanQing (1):
      serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller

 Documentation/devicetree/bindings/tty/serial/of-serial.txt |  3 +++
 drivers/tty/serial/8250/8250.c                             | 52 ++++++++++++++++++++++++++++++++++++++++-
 drivers/tty/serial/8250/8250_pci.c                         | 21 +++++++++--------
 drivers/tty/serial/8250/8250_pnp.c                         | 12 ++++++----
 drivers/tty/serial/Kconfig                                 |  4 ++--
 drivers/tty/serial/bcm63xx_uart.c                          |  8 +++----
 drivers/tty/serial/mpc52xx_uart.c                          |  2 +-
 drivers/tty/serial/of_serial.c                             |  6 +++++
 drivers/tty/serial/vt8500_serial.c                         |  9 +------
 drivers/tty/tty_buffer.c                                   |  2 +-
 include/uapi/linux/serial_core.h                           |  5 +++-
 11 files changed, 91 insertions(+), 33 deletions(-)
