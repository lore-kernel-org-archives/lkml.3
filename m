Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3CSOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:16:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:45469 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab3CSOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:16:56 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/3] cpufreq: use static initializer for the SRCU notifier
Date: Tue, 19 Mar 2013 15:16:46 +0100
Message-Id: <1363702606-31586-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
References: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/cpufreq/cpufreq.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1f93dbd..cd5acda 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -117,12 +117,11 @@ static void handle_update(struct work_struct *work);
  * The mutex locks both lists.
  */
 static BLOCKING_NOTIFIER_HEAD(cpufreq_policy_notifier_list);
-static struct srcu_notifier_head cpufreq_transition_notifier_list;
+SRCU_NOTIFIER_HEAD_STATIC(cpufreq_transition_notifier_list);
 
 static bool init_cpufreq_transition_notifier_list_called;
 static int __init init_cpufreq_transition_notifier_list(void)
 {
-	srcu_init_notifier_head(&cpufreq_transition_notifier_list);
 	init_cpufreq_transition_notifier_list_called = true;
 	return 0;
 }
-- 
1.7.10.4

