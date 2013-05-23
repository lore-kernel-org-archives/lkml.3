Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772Ab3EWQRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:17:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668Ab3EWQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:17:04 -0400
Date: Thu, 23 May 2013 09:17:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.10-rc3
Message-ID: <20130523161703.GA14601@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.10-rc2

for you to fetch changes up to e037f95ffb5355ffe295e1d106d02fefd284d882:

  tty: mxser: Fix build warning introduced by dfc7b837c7f9 (Re: linux-next: build warning after merge of the tty.current tree) (2013-05-22 10:26:02 -0700)

----------------------------------------------------------------
tty/serial fixes for 3.10-rc2

Here are some tty / serial driver fixes for 3.10-rc2.

Nothing huge, although the rocket driver fix looks large, it's just
moving the code around to fix the reported build issues in it.  Other
than that, this has the fix for the of-reported lockdep warning from the
vt layer, as well as some other needed bugfixes.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ezequiel Garcia (1):
      serial: 8250_dw: Add valid clk pointer check

Heikki Krogerus (1):
      serial: 8250_dw: add ACPI ID for Intel BayTrail

Jiri Slaby (1):
      TTY: rocket, fix more no-PCI warnings

Lars-Peter Clausen (1):
      tty: nwpserial: Pass correct pointer to free_irq()

Lee Jones (1):
      serial: pl011: protect attribute read from NULL platform data struct

Matwey V. Kornilov (2):
      tty: mxser: fix usage of opmode_ioaddr
      tty: mxser: Fix build warning introduced by dfc7b837c7f9 (Re: linux-next: build warning after merge of the tty.current tree)

Peter Hurley (1):
      tty/vt: Fix vc_deallocate() lock order

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control

Wei Yongjun (4):
      serial: samsung: add missing platform_driver_unregister() when module exit
      tty: serial: mpc5xxx: fix error handing in mpc52xx_uart_init()
      serial: mcf: missing uart_unregister_driver() on error in mcf_init()
      TTY: ehv_bytechan: add missing platform_driver_unregister() when module exit

 drivers/tty/ehv_bytechan.c        |   1 +
 drivers/tty/mxser.c               |  11 +-
 drivers/tty/n_tty.c               |   8 ++
 drivers/tty/rocket.c              | 288 +++++++++++++++++++-------------------
 drivers/tty/serial/8250/8250_dw.c |   7 +-
 drivers/tty/serial/amba-pl011.c   |   2 +-
 drivers/tty/serial/mcf.c          |   4 +-
 drivers/tty/serial/mpc52xx_uart.c |  11 +-
 drivers/tty/serial/nwpserial.c    |   2 +-
 drivers/tty/serial/samsung.c      |   1 +
 drivers/tty/vt/vt.c               |  14 +-
 drivers/tty/vt/vt_ioctl.c         |  67 ++++++---
 include/linux/vt_kern.h           |   2 +-
 13 files changed, 234 insertions(+), 184 deletions(-)
