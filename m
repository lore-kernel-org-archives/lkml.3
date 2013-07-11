Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3GKWLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:11:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab3GKWL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:11:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Charles Wang <muming.wq@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 11/11] Revert "sched: Add missing call to calc_load_exit_idle()"
Date: Thu, 11 Jul 2013 15:11:11 -0700
Message-Id: <20130711220546.846264014@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711220545.542911892@linuxfoundation.org>
References: <20130711220545.542911892@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 48f0f14ffb6ff4852922994d11fbda418d40100e which was
commit 749c8814f08f12baa4a9c2812a7c6ede7d69507d upstream.

It seems to be misapplied, and not needed for 3.4-stable

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Charles Wang <muming.wq@taobao.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -145,7 +145,6 @@ static void tick_nohz_update_jiffies(kti
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
 
-	calc_load_exit_idle();
 	touch_softlockup_watchdog();
 }
 


