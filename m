Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaC2SoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:44:11 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61938 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaC2SoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:44:05 -0400
Date: Sat, 29 Mar 2014 19:44:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20140329184401.GA27245@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   # HEAD: cab5e127eef040399902caa8e1510795583fa03a time: Revert to calling clock_was_set_delayed() while in irq context

A late breaking fix from John. (The bug fixed has a hard lockup 
potential, but that was not observed, warnings were.)

 Thanks,

	Ingo

------------------>
John Stultz (1):
      time: Revert to calling clock_was_set_delayed() while in irq context


 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aa4ce8..5b40279 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1435,7 +1435,8 @@ void update_wall_time(void)
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	if (clock_set)
-		clock_was_set();
+		/* Have to call _delayed version, since in irq context*/
+		clock_was_set_delayed();
 }
 
 /**
