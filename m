Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaBFXKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:10:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46044 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaBFXKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:10:43 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: alex.shi@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH V2 0/3] sched: idle_balance() cleanup and fix
Date: Thu,  6 Feb 2014 23:10:34 +0000
Message-Id: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

this patchset replace the beginning of the previous mixed one which was not
yet commited [1] without changes except a compilation error fix for UP kernel
config. It is refreshed against tip/sched/core.

As the UP config compilation is broken on the previous patchset, git bisect is
no longer safe for it. You can apply this small serie and drop the 3 first
patches of the previous series [1], or ignore it and I will bring the fix
after you applied [1].

It cleanups the idle_balance function parameters by passing the struct rq
only, fixes a race in the idle_balance function and finally move the idle_stamp
from fair.c to core.c. I am aware it will return back to fair.c with Peter's
pending patches but at least it changes the idle_balance() function to return
true if a balance occured.

[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg577271.html

Changelog:
	V2: 
	   * fixed compilation errors when CONFIG_SMP=n

	V1: initial post


Daniel Lezcano (3):
  sched: Remove cpu parameter for idle_balance()
  sched: Fix race in idle_balance()
  sched: Move idle_stamp up to the core

 kernel/sched/core.c  |   13 +++++++++++--
 kernel/sched/fair.c  |   20 +++++++++++++-------
 kernel/sched/sched.h |    8 +-------
 3 files changed, 25 insertions(+), 16 deletions(-)

-- 
1.7.9.5

