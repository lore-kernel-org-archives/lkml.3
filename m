Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaGHW0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:26:15 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:44372 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaGHW0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:13 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 3/9] rcu: Fix a sparse warning about boost_mutex being non-static
Date: Tue,  8 Jul 2014 18:26:12 -0400
Message-Id: <1404858378-23806-4-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a sparse warning about boost_mutex being non-static by marking it as static

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/rcutorture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 7fa34f8..5ec0452 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -182,7 +182,7 @@ static u64 notrace rcu_trace_clock_local(void)
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
-DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
+static DEFINE_MUTEX(boost_mutex);	/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
 static atomic_t barrier_cbs_count;	/* Barrier callbacks registered. */
 static bool barrier_phase;		/* Test phase. */
-- 
1.9.1

