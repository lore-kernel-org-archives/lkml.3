Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaD0Ago (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:36:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaD0Agl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:36:41 -0400
Date: Sat, 26 Apr 2014 17:37:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fixes for 3.15-rc3
Message-ID: <20140427003723.GA3112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.15-rc3

for you to fetch changes up to 7deb39ed8d9494ea541bcaa69b56036a94f79dc2:

  serial_core: fix uart PORT_UNKNOWN handling (2014-04-24 15:38:22 -0700)

----------------------------------------------------------------
TTY/Serial fixes for 3.15-rc3

Here are a few tty/serial fixes for 3.15-rc3 that resolve a number of
reported issues in the 8250 and samsung serial drivers, as well as a
character loss fix for the tty core that was caused by the lock removal
patches a release ago.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Doug Anderson (3):
      serial: samsung: Use the passed in "port", fixing kgdb w/ no console
      serial: samsung: don't check config for every character
      serial: samsung: Change barrier() to cpu_relax() in console output

Loic Poulain (2):
      8250_core: Fix unwanted TX chars write
      serial: 8250: Fix thread unsafe __dma_tx_complete function

Manfred Schlaegl (1):
      tty: Fix race condition between __tty_buffer_request_room and flush_to_ldisc

Thomas Pfaff (1):
      serial_core: fix uart PORT_UNKNOWN handling

 drivers/tty/serial/8250/8250_core.c |  2 +-
 drivers/tty/serial/8250/8250_dma.c  |  9 +++++++--
 drivers/tty/serial/samsung.c        | 23 +++++++++++-----------
 drivers/tty/serial/serial_core.c    | 39 ++++++++++++++++++++-----------------
 drivers/tty/tty_buffer.c            | 16 +++++++++++++--
 include/linux/tty.h                 |  1 +
 6 files changed, 56 insertions(+), 34 deletions(-)
