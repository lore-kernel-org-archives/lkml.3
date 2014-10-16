Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaJPUyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:54:41 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43585 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752578AbaJPUyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:54:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 00/10] serial core fixes
Date: Thu, 16 Oct 2014 16:54:17 -0400
Message-Id: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The first 3 patches are picked out from the closing series that was
split up; the first 2 patches lay the groundwork for the fixing
the locking for the ->set_termios() method.

The 2 UPF_*/ASYNC* patches are to bind the definitions together
since userspace only gets one set of definitions, but the code
operates as if the definitions are synch'd.

The remainder except the last patch are cleanups; the last patch
fixes port count mismatch in uart_open()/uart_close(), which
Geert and I discussed a while back. So one less thing on my todo
list.

Still on the todo list:
1. Some tty_port flags usage is non-atomic.
2. uart_remove_one_port will happily remove an in-use port since
   there's no reference counting.
3. fixing autoRTS for omap (so it clears RTS when tiocmset drops
   RTS)

Regards,

Peter Hurley (10):
  serial: Refactor uart_flush_buffer() from uart_close()
  serial: core: Flush ldisc after dropping port mutex in uart_close()
  serial: Fix locking for uart driver set_termios() method
  tty,serial: Unify UPF_* and ASYNC_* flag definitions
  tty: Document defunct ASYNC_* bits in uapi header
  serial: core: Unwrap >80 char line in uart_close()
  serial: core: Remove redundant timeout assignments
  serial: core: Colocate crucial structure linkage
  serial: core: Remove extra locking in uart_write()
  serial: core: Fix port count when uart_open() errors

 Documentation/serial/driver       |  6 +++--
 drivers/tty/serial/amba-pl011.c   |  1 +
 drivers/tty/serial/atmel_serial.c | 28 +++++++++++----------
 drivers/tty/serial/serial-tegra.c | 30 +++++++++++-----------
 drivers/tty/serial/serial_core.c  | 52 ++++++++++++++++++++++-----------------
 drivers/tty/serial/timbuart.c     |  2 ++
 include/linux/serial_core.h       | 47 ++++++++++++++++++++++++-----------
 include/uapi/linux/tty_flags.h    | 15 +++++++----
 8 files changed, 110 insertions(+), 71 deletions(-)

-- 
2.1.1

