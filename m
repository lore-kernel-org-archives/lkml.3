Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaHVRJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:09:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44152 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaHVRJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:09:40 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
X-Google-Original-From: Frederic Weisbecker <frederic@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [GIT PULL] nohz: Fix double clock write on idle ticks
Date: Fri, 22 Aug 2014 19:09:31 +0200
Message-Id: <1408727373-8166-1-git-send-email-frederic@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Ingo,

Please pull the nohz/drop-double-write-v3 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	nohz/drop-double-write-v3

Although the 1st patch fixes a bug, it was a longstanding issue so
that branch doesn't need to be applied in 3.17. The next merge window
looks better.

--
The tick reschedules itself unconditionally. It's relevant in periodic
mode but not in dynticks mode where it results in spurious double clock
writes and even spurious periodic behaviour for low-res case.

This set fixes that:

* 1st patch removes low-res periodic tick rescheduling in nohz mode.
This fixes spurious periodic behaviour.

* 2nd patch does the same for high-res mode. Here there is no such
spurious periodic behaviour but it still spares a double clock write
in some cases.
---


Thanks,
	Frederic
---

Viresh Kumar (2):
      nohz: Fix spurious periodic tick behaviour in low-res dynticks mode
      nohz: Avoid tick's double reprogramming in highres mode


 kernel/time/tick-sched.c | 8 ++++++++
 1 file changed, 8 insertions(+)
