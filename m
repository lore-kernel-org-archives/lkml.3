Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966128AbaFTTxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:53:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965703AbaFTTxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:53:35 -0400
Date: Fri, 20 Jun 2014 12:57:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fixes for 3.16-rc2
Message-ID: <20140620195737.GA28616@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.16-rc2

for you to fetch changes up to 60efcf0414be5876d81276e3c1fd12680ba2ce71:

  tty/serial: fix 8250 early console option passing to regular console (2014-06-19 13:07:26 -0700)

----------------------------------------------------------------
TTY/Serial bugfixes for 3.16-rc2

Here are some tty / serial driver bugfixes for 3.16-rc2 that resolve
some reported issues.  The samsung driver build error itself has been
reported by a bunch of people, sorry about that one.  The others are all
tiny and everyone seems to like them in linux-next so far.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Peter Hurley (2):
      serial: Fix IGNBRK handling
      tty: Correct INPCK handling

Rob Herring (1):
      tty/serial: fix 8250 early console option passing to regular console

Sachin Kamat (1):
      serial: samsung: Fix build error

 drivers/tty/n_tty.c                  | 19 ++++++++++---------
 drivers/tty/serial/8250/8250_core.c  |  2 +-
 drivers/tty/serial/8250/8250_early.c |  5 ++++-
 drivers/tty/serial/altera_uart.c     |  6 ++++++
 drivers/tty/serial/amba-pl010.c      |  2 +-
 drivers/tty/serial/amba-pl011.c      |  2 +-
 drivers/tty/serial/atmel_serial.c    |  2 +-
 drivers/tty/serial/bcm63xx_uart.c    |  2 +-
 drivers/tty/serial/bfin_uart.c       |  2 +-
 drivers/tty/serial/dz.c              |  2 +-
 drivers/tty/serial/earlycon.c        |  2 +-
 drivers/tty/serial/efm32-uart.c      |  2 +-
 drivers/tty/serial/fsl_lpuart.c      |  2 +-
 drivers/tty/serial/ip22zilog.c       |  2 +-
 drivers/tty/serial/m32r_sio.c        |  2 +-
 drivers/tty/serial/max310x.c         |  2 +-
 drivers/tty/serial/mcf.c             |  6 ++++++
 drivers/tty/serial/mfd.c             |  2 +-
 drivers/tty/serial/mpsc.c            |  2 +-
 drivers/tty/serial/msm_serial.c      |  2 +-
 drivers/tty/serial/mxs-auart.c       |  2 +-
 drivers/tty/serial/netx-serial.c     |  2 +-
 drivers/tty/serial/pmac_zilog.c      |  2 +-
 drivers/tty/serial/pnx8xxx_uart.c    |  2 +-
 drivers/tty/serial/pxa.c             |  2 +-
 drivers/tty/serial/samsung.c         |  2 +-
 drivers/tty/serial/sb1250-duart.c    |  2 +-
 drivers/tty/serial/sccnxp.c          |  2 +-
 drivers/tty/serial/serial_ks8695.c   |  2 +-
 drivers/tty/serial/serial_txx9.c     |  2 +-
 drivers/tty/serial/sirfsoc_uart.c    |  2 +-
 drivers/tty/serial/st-asc.c          |  2 +-
 drivers/tty/serial/sunsab.c          |  2 +-
 drivers/tty/serial/sunsu.c           |  2 +-
 drivers/tty/serial/sunzilog.c        |  2 +-
 drivers/tty/serial/ucc_uart.c        |  2 +-
 drivers/tty/serial/vr41xx_siu.c      |  2 +-
 drivers/tty/serial/zs.c              |  2 +-
 38 files changed, 60 insertions(+), 44 deletions(-)
