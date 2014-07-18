Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbaGRRaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:30:25 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:45688 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbaGRRaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:30:24 -0400
Message-ID: <53C959CC.6030401@gmail.com>
Date: Fri, 18 Jul 2014 13:30:52 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 1/1] rcu: Fix build failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

While running the kvm rcutorture test scripts, I encountered a build failure caused by

Commit 918179699e4a ("rcu: Don't keep timekeeping CPU tick running for non-nohz_full= CPUs")

This commit fixes the failure. This is on top of paul/rcu/dev.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 5591276..eaa32e4 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2795,7 +2795,7 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 	 * CPU to keep a tick on our behalf.  We assume that the timekeeping
 	 * CPU is also a nohz_full= CPU.
 	 */
-	if (!tick_nohz_full_cpu(cpu))
+	if (!tick_nohz_full_cpu(smp_processor_id()))
 		return;
 
 	/* Update system-idle state: We are clearly no longer fully idle! */
-- 
1.9.1
