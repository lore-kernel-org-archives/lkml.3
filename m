Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3BEUnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:43:43 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:52339 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756363Ab3BEUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:43:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 18/23] tty: Remove stale comment re: tty_ldisc_flush_works()
Date: Tue,  5 Feb 2013 15:20:33 -0500
Message-Id: <1360095638-6624-19-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Waiting for a pending hangup to complete is not a necessary
post-operation of using tty_ldisc_halt() and not sufficient to
guarantee a hangup is not in-progress. As far as the ldisc layer
is concerned, waiting for a pending hangup is necessary only
prior to changing the ldisc while handling the TIOCSETD ioctl (and
only because the tty lock must be released as a precondition
of halting the ldisc).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 9599b05..f3cbfb3 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -538,10 +538,6 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
  *
  *	Callers other than tty_ldisc_release() must hold ->ldisc_mutex and
  *	cannot be holding tty_lock() (aka legacy_mutex).
- *
- *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
- *	in order to make sure any currently executing ldisc work is also
- *	flushed.
  */
 
 static int tty_ldisc_halt(struct tty_struct *tty, struct tty_struct *o_tty,
-- 
1.8.1.2

