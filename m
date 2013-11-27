Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3K0WvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:51:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3K0WvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:51:14 -0500
Date: Wed, 27 Nov 2013 14:51:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.13-rc2
Message-ID: <20131127225113.GA3567@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.13-rc2

for you to fetch changes up to c42b4e6501cdaabee8cc292ae1ef0f66bf4825c1:

  Revert "n_gsm: race between ld close and gsmtty open" (2013-11-25 18:30:21 -0800)

----------------------------------------------------------------
TTY/serial fixes for 3.13-rc2

Here are some tty/serial driver fixes for reported issues in 3.13-rc2.

The n_gsm "fix" was reverted as it was found to not be correct.
Hopefully this will be resolved in a future pull request, but as there's
really only one user of this line setting, it's not a big deal...

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Chao Bi (1):
      n_gsm: race between ld close and gsmtty open

Geert Uytterhoeven (2):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()
      TTY: amiserial, add missing platform check

Greg Kroah-Hartman (1):
      Revert "n_gsm: race between ld close and gsmtty open"

Peter Hurley (5):
      n_tty: Ensure reader restarts worker for next reader
      n_tty: Fix echo overrun tail computation
      n_tty: Fix 4096-byte canonical reads
      tty: Reset hupped state on open
      n_tty: Protect minimum_to_wake reset for concurrent readers

Randy Dunlap (1):
      tty/serial/8250: fix typo in help text

 drivers/tty/amiserial.c         |  3 +++
 drivers/tty/n_tty.c             | 16 ++++++++++------
 drivers/tty/serial/8250/Kconfig |  2 +-
 drivers/tty/serial/pmac_zilog.c |  3 +++
 drivers/tty/tty_io.c            |  1 +
 5 files changed, 18 insertions(+), 7 deletions(-)
