Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3GXTI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:08:26 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:41894 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3GXTIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:08:25 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Mike Galbraith <efault@gmx.de>, Kevin Hilman <khilman@linaro.org>
Subject: [GIT PULL] nohz fixes
Date: Wed, 24 Jul 2013 21:08:12 +0200
Message-Id: <1374692894-27202-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/urgent

Just one thing you need to know: you reported me that the warning was
"too much" to tell the user that he can't use full dynticks due to unstable tsc.

I discussed that with Steve and we concluded that we could keep the warning but
only trigger it if the user explicitly wants to use the full dynticks which we
deduce by checking if he filled the nohz_full= boot parameter or he selected
CONFIG_NO_HZ_FULL_ALL. This way we make sure that the user knows what's going
on but only if he really expected to use it.

If you still consider the tainting warning to be too much a hammer, even if only
real users are warned, then tell me and I'll change that to some way you
prefer.


Thanks,
	Frederic
---

Li Zhong (1):
      nohz: fix compile warning in tick_nohz_init()

Steven Rostedt (1):
      nohz: Do not warn about unstable tsc unless user uses nohz_full


 kernel/time/tick-sched.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)
