Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaBNVZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:25:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaBNVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:25:06 -0500
Date: Fri, 14 Feb 2014 13:26:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fixes for 3.14-rc3
Message-ID: <20140214212625.GA19466@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.14-rc3

for you to fetch changes up to 0930b0950a8996aa88b0d2ba4bb2bab27cc36bc7:

  vt: Fix secure clear screen (2014-02-13 11:12:00 -0800)

----------------------------------------------------------------
TTY/Serial driver fixes for 3.14-rc3

Here are a small number of tty/serial driver fixes to resolve reported
issues with 3.14-rc and earlier (in the case of the vt bugfix.)  Some of
these have been tested and reported by a number of people as the tty
bugfix was pretty commonly hit on some platforms.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dmitry Eremin-Solenikov (1):
      serial: 8250_pci: unbreak last serial ports on NetMos 9865 cards

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Joe Schultz (1):
      serial: 8250: Support XR17V35x fraction divisor

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control

Markus Pargmann (1):
      serial: omap-serial: Move info message to probe function

Michael Grzeschik (1):
      serial: omap: fix rs485 probe on defered pinctrl

Mika Westerberg (1):
      serial: 8250_dw: fix compilation warning when !CONFIG_PM_SLEEP

Paul Gortmaker (1):
      drivers/tty/hvc: don't use module_init in non-modular hyp. console code

Peter Hurley (2):
      n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0
      n_tty: Fix stale echo output

Petr Písař (1):
      vt: Fix secure clear screen

Qipan Li (1):
      serial: sirf: fix kernel panic caused by unpaired spinlock

 Documentation/ABI/testing/sysfs-tty |  3 ++-
 drivers/tty/hvc/hvc_opal.c          |  8 +-------
 drivers/tty/hvc/hvc_rtas.c          | 12 +-----------
 drivers/tty/hvc/hvc_udbg.c          |  9 +--------
 drivers/tty/hvc/hvc_xen.c           | 17 +----------------
 drivers/tty/n_gsm.c                 | 11 +++++++++++
 drivers/tty/n_tty.c                 | 14 ++++++++------
 drivers/tty/serial/8250/8250_core.c | 18 ++++++++++++++++++
 drivers/tty/serial/8250/8250_dw.c   |  4 ++--
 drivers/tty/serial/8250/8250_pci.c  |  3 ++-
 drivers/tty/serial/omap-serial.c    | 11 +++++++----
 drivers/tty/serial/sirfsoc_uart.c   |  4 +++-
 drivers/tty/tty_io.c                | 25 ++++++++++++++++++-------
 drivers/tty/vt/vt.c                 |  2 ++
 14 files changed, 77 insertions(+), 64 deletions(-)
