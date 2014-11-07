Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaKGObh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:31:37 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40714 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaKGObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:31:34 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, lenb@kernel.org
Subject: [PATCH V3 0/6] sched: idle: cpuidle: cleanups and fixes
Date: Fri,  7 Nov 2014 15:31:21 +0100
Message-Id: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset provides some cleanups to prepare the removal of the
CPUIDLE_DRIVER_STATE_START macro in the cpuidle code. As the code has built
on top of this macro adding more complexity and ugly hacks/tricks, it is hard
to simply remove it. Some code has to be cleanup before, this is the purpose
of this first patchset.

Changelog:

V3:
  - fixed comment for the latency_req introduction back to the right patch
  - added back the last_idx_state in the reflect function
  - change the get_typical_interval to return the value

V2:
  - fixed typo
  - removed redundant comment
  - fixed readability


Daniel Lezcano (6):
  sched: idle: Add a weak arch_cpu_idle_poll function
  sched: idle: cpuidle: Check the latency req before idle
  sched: idle: Get the next timer event and pass it the cpuidle
    framework
  cpuidle: idle: menu: Don't reflect when a state selection failed
  cpuidle: menu: Fix the get_typical_interval
  cpuidle: menu: Move the update function before its declaration

 drivers/cpuidle/cpuidle.c          |  12 +--
 drivers/cpuidle/governors/ladder.c |  13 +--
 drivers/cpuidle/governors/menu.c   | 183 ++++++++++++++++++-------------------
 include/linux/cpuidle.h            |   9 +-
 kernel/sched/idle.c                |  55 +++++++----
 5 files changed, 140 insertions(+), 132 deletions(-)

-- 
1.9.1

