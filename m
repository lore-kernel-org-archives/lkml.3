Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaFKUj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:39:58 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:65053 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaFKUj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:39:56 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: [RFC PATCH 5/5] kernel/rcu/rcutorture.c:185 fix a sparse warning 
Date: Wed, 11 Jun 2014 16:39:43 -0400
Message-Id: <1402519183-12752-6-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the following sparse warning

kernel/rcu/rcutorture.c:185:1: warning: symbol 'boost_mutex' was not declared. Should it be static?

by marking boost_mutex as a static mutex

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/rcutorture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 7fa34f8..1cd4b2d 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -182,7 +182,7 @@ static u64 notrace rcu_trace_clock_local(void)
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
-DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
+static DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
 static atomic_t barrier_cbs_count;	/* Barrier callbacks registered. */
 static bool barrier_phase;		/* Test phase. */
-- 
1.9.1

