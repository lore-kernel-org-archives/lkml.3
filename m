Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaFWRR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:17:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:23934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504AbaFWRRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,531,1400050800"; 
   d="scan'208";a="561989818"
Message-ID: <53A8611F.1000804@intel.com>
Date: Mon, 23 Jun 2014 10:17:19 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
CC: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        ak@linux.intel.com, cl@gentwo.org, umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
References: <20140621025958.GA7185@linux.vnet.ibm.com> <53A85BF9.7030006@intel.com>
In-Reply-To: <53A85BF9.7030006@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 09:55 AM, Dave Hansen wrote:
> This still has a regression.  Commit 1ed70de (from Paul's git tree),
> gets a result of 52231880.  If I back up two commits to v3.16-rc1 and
> revert ac1bea85 (the original culprit) the result goes back up to 57308512.
> 
> So something is still going on here.
> 
> I'll go back and compare the grace period ages to see if I can tell what
> is going on.

RCU_TRACE interferes with the benchmark a little bit, and it lowers the
delta that the regression causes.  So, evaluate this cautiously.

According to rcu_sched/rcugp, the average "age" is:

v3.16-rc1, with ac1bea85 reverted:	10.7
v3.16-rc1, plus e552592e:		 6.1

Paul, have you been keeping an eye on rcugp?  Even if I run my system
with only 10 threads, I still see this basic pattern where the average
"age" is lower when I see lower performance.  It seems to be a
reasonable proxy that could be used instead of waiting on me to re-run
tests.


