Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab3IFBtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:49:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab3IFBtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:49:16 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=O_0LgjpTiVIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DQE5XFEDjykA:10 a=VwQbUJbxAAAA:8 a=j3F028hWnmxyGy9JVhUA:9 a=BPSfKMXmiYsA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130906014816.037690469@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 05 Sep 2013 21:48:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>
Subject: [for-next][PATCH 0/4] tracing: Updated changes for 3.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm holding off on the rcu unsafe changes with perf and function tracing.
We'll still get bug splats with unsafe rcu usage, but we need to work
out a better solution than I was going to push for 3.12. It's too late
to get things smooth, thus we need to wait till 3.13 to get something
that is decent.

For now, root needs to be careful in how they trace functions with perf.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: a0a5a0561f63905fe94c49bc567615829f42ce1e


Alexander Z Lam (1):
      tracing: Make tracing_cpumask available for all instances

H. Peter Anvin (1):
      x86-32, ftrace: Fix static ftrace when early microcode is enabled

Steven Rostedt (Red Hat) (2):
      ftrace: Fix a slight race in modifying what function callback gets traced
      ftrace/rcu: Do not trace debug_lockdep_rcu_enabled()

----
 arch/x86/kernel/entry_32.S |    3 +++
 kernel/rcupdate.c          |    2 +-
 kernel/trace/ftrace.c      |   17 ++++++++++++++++-
 kernel/trace/trace.c       |   37 ++++++++++++++++++++-----------------
 kernel/trace/trace.h       |    1 +
 5 files changed, 41 insertions(+), 19 deletions(-)
