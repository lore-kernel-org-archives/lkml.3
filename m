Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaBJNfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:35:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaBJNeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:34:10 -0500
Date: Mon, 10 Feb 2014 05:33:31 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-47be1c1a0e188232b5e5962917b21750053cd3f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        gregkh@linuxfoundation.org, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        paulmck@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20140120182016.GA26512@redhat.com>
References: <20140120182016.GA26512@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Change lockdep_set_novalidate_class()
  to use _and_name
Git-Commit-ID: 47be1c1a0e188232b5e5962917b21750053cd3f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:33:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47be1c1a0e188232b5e5962917b21750053cd3f8
Gitweb:     http://git.kernel.org/tip/47be1c1a0e188232b5e5962917b21750053cd3f8
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 20 Jan 2014 19:20:16 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 21:19:01 +0100

lockdep: Change lockdep_set_novalidate_class() to use _and_name

Cosmetic. This doesn't really matter because a) device->mutex is
the only user of __lockdep_no_validate__ and b) this class should
be never reported as the source of problem, but if something goes
wrong "&dev->mutex" looks better than "&__lockdep_no_validate__"
as the name of the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140120182016.GA26512@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/lockdep.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 1626047..060e513 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -303,7 +303,7 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 				 (lock)->dep_map.key, sub)
 
 #define lockdep_set_novalidate_class(lock) \
-	lockdep_set_class(lock, &__lockdep_no_validate__)
+	lockdep_set_class_and_name(lock, &__lockdep_no_validate__, #lock)
 /*
  * Compare locking classes
  */
