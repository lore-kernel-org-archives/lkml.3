Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3ARTxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:53:39 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:53029 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3ARTxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:53:35 -0500
Date: Fri, 18 Jan 2013 11:53:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.8-rc4
Message-ID: <20130118195330.GA19006@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.8-rc4

for you to fetch changes up to ebebd49a8eab5e9aa1b1f8f1614ccc3c2120f886:

  8250/16?50: Add support for Broadcom TruManage redirected serial port (2013-01-17 14:02:55 -0800)

----------------------------------------------------------------
TTY/serial fixes for 3.8-rc4

Here are a few tty/serial driver fixes for 3.8-rc4 that resolve a number
of problems that people have been having, including the ptys ioctl issue
that is a regression fix.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Jiri Slaby (1):
      pty: return EINVAL for TIOCGPTN for BSD ptys

Matt Schulte (2):
      tty/8250: pbn_b0_8_1152000_200 is supposed to be an 8 port definition
      tty/8250: The correct device id for this card is 0x0022

Maxime Ripard (1):
      tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler

Steffen Trumtrar (1):
      mxs: uart: fix setting RTS from software

Stephen Hurd (1):
      8250/16?50: Add support for Broadcom TruManage redirected serial port

Thomas Abraham (1):
      serial: samsung: remove redundant setting of line config during port reset

Wei Yongjun (1):
      tty: serial: vt8500: fix return value check in vt8500_serial_probe()

channing (1):
      serial:ifx6x60:Keep word size accordance with SPI controller

chao bi (1):
      serial:ifx6x60:Delete SPI timer when shut down port

fabio.estevam@freescale.com (1):
      serial: mxs-auart: Index is unsigned

 drivers/tty/pty.c                  |  2 ++
 drivers/tty/serial/8250/8250.c     | 11 +++++++++++
 drivers/tty/serial/8250/8250.h     |  1 +
 drivers/tty/serial/8250/8250_dw.c  |  2 +-
 drivers/tty/serial/8250/8250_pci.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 drivers/tty/serial/ifx6x60.c       |  4 +++-
 drivers/tty/serial/mxs-auart.c     |  6 ++++--
 drivers/tty/serial/samsung.c       |  1 -
 drivers/tty/serial/vt8500_serial.c |  2 +-
 include/uapi/linux/serial_core.h   |  3 ++-
 10 files changed, 65 insertions(+), 9 deletions(-)
