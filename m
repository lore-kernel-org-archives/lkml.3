Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaB0LrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:47:13 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53012 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaB0LrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:47:07 -0500
Date: Thu, 27 Feb 2014 17:16:57 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@freedesktop.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, josh@joshtriplett.org
Subject: [PATCH 16/46] kernel: Mark function as static in kernel/rcu/torture.c
Message-ID: <49b484c2399a29c2b28d0ccec218b26ed36bf9fd.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in kernel/rcu/torture.c because they are not
used outside this file.

This eliminates the following warning in kernel/rcu/torture.c:
kernel/rcu/torture.c:902:6: warning: no previous prototype for ‘rcutorture_trace_dump’ [-Wmissing-prototypes]
kernel/rcu/torture.c:1572:6: warning: no previous prototype for ‘rcu_torture_barrier_cbf’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcu/torture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
index 732f8ae..dd3a431 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/torture.c
@@ -899,7 +899,7 @@ rcu_torture_fakewriter(void *arg)
 	return 0;
 }
 
-void rcutorture_trace_dump(void)
+static void rcutorture_trace_dump(void)
 {
 	static atomic_t beenhere = ATOMIC_INIT(0);
 
@@ -1569,7 +1569,7 @@ static void rcu_torture_stall_cleanup(void)
 }
 
 /* Callback function for RCU barrier testing. */
-void rcu_torture_barrier_cbf(struct rcu_head *rcu)
+static void rcu_torture_barrier_cbf(struct rcu_head *rcu)
 {
 	atomic_inc(&barrier_cbs_invoked);
 }
-- 
1.7.9.5

