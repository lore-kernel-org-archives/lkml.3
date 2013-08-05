Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3HETDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:03:39 -0400
Received: from mail-gh0-f173.google.com ([209.85.160.173]:56011 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3HETDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:03:37 -0400
Date: Mon, 5 Aug 2013 15:09:52 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: trinity@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: trinity hang -- rcu_sched detected stall in __schedule
Message-ID: <alpine.DEB.2.10.1308051451420.18647@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm running the trinity fuzzer on my ARM Pandaboard, Linux 3.11-rc4

Trinity got stuck with these messages being logged.  As far as I can
tell trinity-child1 wasn't doing anything that interesting when it got 
stuck.

Hopefully I picked the right group to cc: it looks like it is stuck
in __schedule somewhere?  So I'm not sure if this is ARM related or a 
general problem.

Vince

[ 5026.161163] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=2102 jiffies, g=250744, c=250743, q=8)
[ 5026.161163] Task dump for CPU 1:
[ 5026.161163] trinity-child1  R running      0 27485   2810 0x00000000
[ 5026.182922] [<c048cef4>] (__schedule+0x4c4/0x748) from [<00000000>] (  (null))
[ 5089.211090] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=8407 jiffies, g=250744, c=250743, q=658)
[ 5089.222900] Task dump for CPU 1:
[ 5089.222900] trinity-child1  R running      0 27485   2810 0x00000000
[ 5089.233154] [<c048cef4>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
[ 5152.270843] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=14712 jiffies, g=250744, c=250743, q=842)
[ 5152.270874] Task dump for CPU 1:
[ 5152.286193] trinity-child1  R running      0 27485   2810 0x00000000
[ 5152.286193] [<c048cef4>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
[ 5215.311096] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=21017 jiffies, g=250744, c=250743, q=857)
[ 5215.322998] Task dump for CPU 1:
[ 5215.322998] trinity-child1  R running      0 27485   2810 0x00000000
[ 5215.333251] [<c048cef4>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
[ 5278.361083] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=27322 jiffies, g=250744, c=250743, q=857)
[ 5278.372985] Task dump for CPU 1:
[ 5278.372985] trinity-child1  R running      0 27485   2810 0x00000000
[ 5278.372985] [<c048cef4>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
[ 5341.411102] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=33627 jiffies, g=250744, c=250743, q=959)
[ 5341.411102] Task dump for CPU 1:
[ 5341.411102] trinity-child1  R running      0 27485   2810 0x00000000
[ 5341.433227] [<c048cef4>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
[ 5404.461090] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=39932 jiffies, g=250744, c=250743, q=1043)
[ 5404.473083] Task dump for CPU 1:
[ 5404.473083] trinity-child1  R running      0 27485   2810 0x00000000
[ 5404.473083] [<c048cef4>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
[ 5467.530395] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=46238 jiffies, g=250744, c=250743, q=1056)
[ 5467.530395] Task dump for CPU 1:
[ 5467.530395] trinity-child1  R running      0 27485   2810 0x00000000
[ 5467.545806] [<c048cef4>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
[ 5530.571258] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=52543 jiffies, g=250744, c=250743, q=1056)
[ 5530.571258] Task dump for CPU 1:
[ 5530.571258] trinity-child1  R running      0 27485   2810 0x00000000
[ 5530.571258] [<c048cef4>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
