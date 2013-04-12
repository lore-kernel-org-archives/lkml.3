Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3DLIeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:34:36 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58672 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3DLIdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:33:52 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        "David S. Miller" <davem@davemloft.net>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/4] TTY: fix DTR being raised on hang up
Date: Fri, 12 Apr 2013 10:32:27 +0200
Message-Id: <1365755551-17824-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix four custom block_til_ready implementations which
could raise DTR after first having dropped it at hangup.

This was fixed in the tty-port implementation by commit e584a02cf ("TTY:
fix DTR being raised on hang up") in tty-next.

Note that the crisv10-driver still suffers from this behaviour but is
broken in other ways as it, for example, does not honour CBAUD or raise
DTR at non-blocking open.

Thanks,
Johan


Johan Hovold (4):
  TTY: synclink: fix DTR being raised on hang up
  TTY: synclink_gt: fix DTR being raised on hang up
  TTY: synclinkmp: fix DTR being raised on hang up
  TTY: ircomm: fix DTR being raised on hang up

 drivers/tty/synclink.c       | 2 +-
 drivers/tty/synclink_gt.c    | 2 +-
 drivers/tty/synclinkmp.c     | 2 +-
 net/irda/ircomm/ircomm_tty.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.1.5

