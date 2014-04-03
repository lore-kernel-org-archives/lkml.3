Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbaDCAJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:09:35 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39861 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590AbaDCAJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:09:34 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
        Kevin Hilman <khilman@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] nohz: Move nohz kick out of scheduler IPI v2
Date: Thu,  3 Apr 2014 02:09:25 +0200
Message-Id: <1396483767-28607-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Here's an updated version of the patches with your review addressed.
I ripped the function parameter and let it be setup on queued IPI object
initialization time so that people don't get confused and always use the
same function for a given queued object.

Please tell me if you find other issues.

Thanks.

Frederic Weisbecker (2):
  smp: Non busy-waiting IPI queue
  nohz: Move full nohz kick to its own IPI

 include/linux/smp.h      | 11 +++++++++++
 include/linux/tick.h     |  2 ++
 kernel/sched/core.c      |  5 +----
 kernel/sched/sched.h     |  2 +-
 kernel/smp.c             | 42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c | 21 +++++++++++++++++++++
 6 files changed, 78 insertions(+), 5 deletions(-)

-- 
1.8.3.1

