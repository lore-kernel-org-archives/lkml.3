Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaLAVep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:34:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403AbaLAVeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:34:44 -0500
Date: Mon, 1 Dec 2014 22:33:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] x86, ticketlock: spin_unlock_wait() can livelock
Message-ID: <20141201213357.GA5834@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review, I'm afraid I could miss something.

OTOH, this almost looks like a bug to me. And in fact I have a bug
report which looks as if spin_unlock_wait() actually spins "forever"
until the system panics, although most probably the are other problems
in kernel/sched which lead to rq->lock contention.

Do we need a barrier() in arch_spin_unlock_wait() ? I guess no, and
the current code doesn't have it.

Perhaps it should use __ticket_lock_spinning() like arch_spin_lock() ?

And probably we should add the lockdep annotations.

Oleg.

