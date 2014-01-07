Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaAGSNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:13:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaAGSN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:13:29 -0500
Date: Tue, 7 Jan 2014 19:12:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] rcu_dereference_check_fdtable fix/cleanups
Message-ID: <20140107181258.GA29288@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried to audit the users of thread_group_empty() (we need
to change it) and found rcu_my_thread_group_empty() which
looks wrong.

The patches look simple, but I am not sure it is fine to use
rcu_lock_acquire() directly. Perhaps it makes sense to add a
new helper? Note that we have more users which take rcu lock
only to shut up lockdep. Please review.

And I am a bit confused. Perhaps rcu_lock_acquire() should
depend on CONFIG_PROVE_RCU, not on CONFIG_DEBUG_LOCK_ALLOC?
We only need rcu_lock_map/etc for rcu_lockdep_assert().

Oleg.

 fs/file.c                |   24 +++++++++++-------------
 include/linux/fdtable.h  |   19 +++++++++++++------
 include/linux/rcupdate.h |    2 --
 kernel/rcu/update.c      |   11 -----------
 4 files changed, 24 insertions(+), 32 deletions(-)

