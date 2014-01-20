Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaATSUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:20:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbaATSUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:20:23 -0500
Date: Mon, 20 Jan 2014 19:20:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] lockdep: change lockdep_set_novalidate_class() to use
	_and_name
Message-ID: <20140120182016.GA26512@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120181942.GA20783@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic. This doesn't really matter because a) device->mutex is
the only user of __lockdep_no_validate__ and b) this class should
be never reported as the source of problem, but if something goes
wrong "&dev->mutex" looks better than "&__lockdep_no_validate__"
as the name of the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/lockdep.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.5.5.1

