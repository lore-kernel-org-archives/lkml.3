Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3ILM6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:58:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53339 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3ILM6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:58:08 -0400
Date: Thu, 12 Sep 2013 14:58:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20130912125804.GA25661@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: b0cff9d88ce2f3030f73138078c5b1019f17e1cc sched: Fix load balancing performance regression in should_we_balance()

Performance regression fix.

 Thanks,

	Ingo

------------------>
Joonsoo Kim (1):
      sched: Fix load balancing performance regression in should_we_balance()


 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7f0a5e6..9b3fe1c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5151,7 +5151,7 @@ static int should_we_balance(struct lb_env *env)
 	 * First idle cpu or the first cpu(busiest) in this sched group
 	 * is eligible for doing load balancing at this and above domains.
 	 */
-	return balance_cpu != env->dst_cpu;
+	return balance_cpu == env->dst_cpu;
 }
 
 /*
