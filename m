Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaAOST5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:19:57 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36226 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaAOSTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:19:55 -0500
Date: Wed, 15 Jan 2014 19:19:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20140115181951.GA22666@gmail.com>
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

   # HEAD: 9722c2dac708e9468cc0dc30218ef76946ffbc9d sched: Calculate effective load even if local weight is 0

Contains a fix for a bug that manifested itself as a 3D performance 
regression.

 Thanks,

	Ingo

------------------>
Rik van Riel (1):
      sched: Calculate effective load even if local weight is 0


 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7395d9..e64b079 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3923,7 +3923,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
 
-	if (!tg->parent || !wl)	/* the trivial, non-cgroup case */
+	if (!tg->parent)	/* the trivial, non-cgroup case */
 		return wl;
 
 	for_each_sched_entity(se) {
