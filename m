Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbaEEVUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:20:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbaEEVUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:20:09 -0400
Date: Mon, 5 May 2014 14:23:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fixes for 3.15-rc5
Message-ID: <20140505212315.GA3885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.15-rc4

for you to fetch changes up to 62a0d8d7c2b29f92850e4ee3c38e5dfd936e92b2:

  tty: Fix lockless tty buffer race (2014-05-03 18:14:28 -0400)

----------------------------------------------------------------
TTY/Serial fixes for 3.15-rc4

Here are some tty and serial driver fixes for things reported recently.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Michael Welling (1):
      tty: serial: 8250_core.c Bug fix for Exar chips.

Peter Hurley (3):
      n_tty: Fix n_tty_write crash when echoing in raw mode
      Revert "tty: Fix race condition between __tty_buffer_request_room and flush_to_ldisc"
      tty: Fix lockless tty buffer race

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

 drivers/tty/hvc/hvc_console.c       |  2 +-
 drivers/tty/n_tty.c                 |  4 ++++
 drivers/tty/serial/8250/8250_core.c |  2 +-
 drivers/tty/tty_buffer.c            | 29 ++++++++++++++---------------
 include/linux/tty.h                 |  1 -
 5 files changed, 20 insertions(+), 18 deletions(-)
