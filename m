Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3DOKBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:01:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:55172 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3DOKBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:01:40 -0400
Date: Mon, 15 Apr 2013 12:01:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 3.9
Message-ID: <alpine.LFD.2.02.1304151159590.21884@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

* Single bug fix for a cpu hotplug race.

Thanks,

	tglx

------------------>
Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP


 kernel/hrtimer.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cc47812..14be27f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -63,6 +63,7 @@
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
 
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(hrtimer_bases.lock),
 	.clock_base =
 	{
 		{
@@ -1642,8 +1643,6 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	raw_spin_lock_init(&cpu_base->lock);
-
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		cpu_base->clock_base[i].cpu_base = cpu_base;
 		timerqueue_init_head(&cpu_base->clock_base[i].active);
