Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3C3NPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:15:39 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50657 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3C3NPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:15:38 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, Chen Gang <gang.chen@asianux.com>
Subject: [PATCH 0/3] posix_timers: A few expiry caching fixes
Date: Sat, 30 Mar 2013 14:15:28 +0100
Message-Id: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series is on top of latest -mmotm.

[1/3] fixes some omitting sample capture after a build warning suddenly became visible
[2/3] fixes a wrong timer_gettime() result on a timer whose target has been reaped.
[3/3] needs some more thinking probably

Thanks.

Frederic Weisbecker (3):
  posix-timers: Correctly get dying task time sample in
    posix_cpu_timer_schedule()
  posix_timers: Fix racy timer delta caching on task exit
  posix_timers: Remove dead task timer expiry caching

 kernel/posix-cpu-timers.c |   68 ++-------------------------------------------
 1 files changed, 3 insertions(+), 65 deletions(-)

-- 
1.7.5.4

