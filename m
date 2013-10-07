Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3JGShk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3JGShi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:37:38 -0400
Date: Mon, 7 Oct 2013 20:30:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] sched/wait: wait_event*_timeout() needs
	___wait_cond_timeout() too
Message-ID: <20131007183043.GA10969@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And another patch we already discussed.

wait_event_timeout(wq, true, 0) still returns 0, this doesn't look
right, and this doesn't match __wait_event_timeout(timeout => 0).

Sure, most probably nobody uses the constant timeout == 0, but this
can break the code which does something like

	if (nonblock)
		timeout = 0;
	else
		timeout = TIMEOUT;

	success = wait_event_timeout(wq, CONDITION, timeout);

Oleg.

