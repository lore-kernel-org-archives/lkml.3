Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaJPTdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:33:52 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55895 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751472AbaJPTdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:33:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 0/9] pty fixes
Date: Thu, 16 Oct 2014 15:33:21 -0400
Message-Id: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This series addresses some pecularities of the pty driver, especially
set_termios() handling, which is moved into the pty driver proper, and
packet mode/ctrl_lock behavior.

Regards,

Peter Hurley (9):
  tty: WARN for attempted set_termios() of pty master
  tty: Move pty-specific set_termios() handling to pty driver
  pty: Use spin_lock_irq() for pty_set_termios()
  tty: Use spin_lock_irq() for ctrl_lock when interrupts enabled
  pty: Don't claim slave's ctrl_lock for master's packet mode
  pty: Fix packet mode setting race
  pty: Hold ctrl_lock for packet mode updates
  tty: Fix missed wakeup from packet mode status update
  n_tty: Only process packet mode data in raw mode

 drivers/tty/n_tty.c     | 39 +++++++++++++++++++------------------
 drivers/tty/pty.c       | 51 ++++++++++++++++++++++++++++++++++++-------------
 drivers/tty/tty_ioctl.c | 34 ++++-----------------------------
 3 files changed, 62 insertions(+), 62 deletions(-)

-- 
2.1.1

