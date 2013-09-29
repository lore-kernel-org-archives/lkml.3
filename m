Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3I2UCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:02:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab3I2UC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:02:29 -0400
Date: Sun, 29 Sep 2013 13:02:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixess for 3.12-rc3
Message-ID: <20130929200230.GA31185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.12-rc3

for you to fetch changes up to 2332575ef10a1bcf5ca485a6bf043831be11c7a0:

  tty: ar933x_uart: move devicetree binding documentation (2013-09-26 12:33:49 -0700)

----------------------------------------------------------------
TTY/Serial fixes for 3.12-rc3

Here are some serial at tty driver fixes for 3.12-rc3

The serial driver fixes some kref leaks, documentation is moved to the proper
places, and the tty and n_tty fixes resolve some reported regressions.  There
is still one outstanding tty regression fix that isn't in here yet, as I want
to test it out some more, it will be sent for 3.12-rc4 if it checks out.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Gabor Juhos (1):
      tty: ar933x_uart: move devicetree binding documentation

Johan Hovold (4):
      serial: tegra: fix tty-kref leak
      serial: pch_uart: fix tty-kref leak in rx-error path
      serial: pch_uart: fix tty-kref leak in dma-rx path
      serial: pch_uart: remove unnecessary tty_port_tty_get

Peter Hurley (2):
      n_tty: Fix EOF push index when termios changes
      tty: Fix SIGTTOU not sent with tcflush()

 .../bindings/{tty => }/serial/qca,ar9330-uart.txt           |  0
 drivers/tty/n_tty.c                                         |  3 +--
 drivers/tty/serial/pch_uart.c                               | 13 +++----------
 drivers/tty/serial/serial-tegra.c                           |  4 +++-
 drivers/tty/tty_ioctl.c                                     |  3 +++
 5 files changed, 10 insertions(+), 13 deletions(-)
 rename Documentation/devicetree/bindings/{tty => }/serial/qca,ar9330-uart.txt (100%)
