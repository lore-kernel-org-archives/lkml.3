Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3JGScD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:32:03 -0400
Received: from a194-81.smtp-out.amazonses.com ([199.255.194.81]:28397 "EHLO
	a194-81.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756348Ab3JGSb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:31:59 -0400
Message-Id: <0000014194309205-d0af4d2d-a046-4189-b4f0-ffea37374988-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 7 Oct 2013 18:31:58 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [raw v1 2/4] [NET] Use raw_cpu ops for SNMP stats
References: <20131007183226.334180014@linux.com>
X-SES-Outgoing: 199.255.194.81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNMP stats are not protected by preemption but by bh handling.
Since protection is provided outside of preemption raw_cpu_ops
need to be used to avoid false positives.

Cc: Eric Dumazet <edumazet@google.com>
CC: netdev@vger.kernel.org
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/net/snmp.h
===================================================================
--- linux.orig/include/net/snmp.h	2013-10-07 09:16:07.595206864 -0500
+++ linux/include/net/snmp.h	2013-10-07 09:16:07.591206909 -0500
@@ -126,7 +126,7 @@ struct linux_xfrm_mib {
 	extern __typeof__(type) __percpu *name[SNMP_ARRAY_SZ]
 
 #define SNMP_INC_STATS_BH(mib, field)	\
-			__this_cpu_inc(mib[0]->mibs[field])
+			raw_cpu_inc(mib[0]->mibs[field])
 
 #define SNMP_INC_STATS_USER(mib, field)	\
 			this_cpu_inc(mib[0]->mibs[field])
@@ -141,7 +141,7 @@ struct linux_xfrm_mib {
 			this_cpu_dec(mib[0]->mibs[field])
 
 #define SNMP_ADD_STATS_BH(mib, field, addend)	\
-			__this_cpu_add(mib[0]->mibs[field], addend)
+			raw_cpu_add(mib[0]->mibs[field], addend)
 
 #define SNMP_ADD_STATS_USER(mib, field, addend)	\
 			this_cpu_add(mib[0]->mibs[field], addend)

