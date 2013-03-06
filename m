Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3CFMVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:21:37 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:43043 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3CFMVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:21:34 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/5] Fix session leader exit hang
Date: Wed,  6 Mar 2013 07:20:52 -0500
Message-Id: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a session leader exits, it hangs up the controlling tty and
then signals the foreground group processes with SIGHUP. This sequence
can hang as reported by Sasha Levin, and noted in the changelog of
'tty: Signal SIGHUP before hanging up ldisc'.


Peter Hurley (5):
  tty: Refactor session leader SIGHUP from __tty_hangup()
  tty: Fix spinlock flavor in non-atomic __tty_hangup()
  tty: Use spin_lock() inside existing critical region
  tty: Signal foreground group processes in hangup
  tty: Signal SIGHUP before hanging up ldisc

 drivers/tty/tty_io.c | 144 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 96 insertions(+), 48 deletions(-)

-- 
1.8.1.2

