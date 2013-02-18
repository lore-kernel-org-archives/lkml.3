Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3BRI0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:26:44 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57600 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3BRI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:26:43 -0500
Date: Mon, 18 Feb 2013 09:26:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched: circular dependency between sched_domains_mutex and
 oom_notify_list
Message-ID: <20130218082639.GA15989@gmail.com>
References: <51206DAB.7030701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51206DAB.7030701@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> I suspect it's the result of adding the new rcu_oom_notify, but that happened
> about half a year ago so I'm not sure why this showed up only now.
> 
> [ 1039.634183] ======================================================
> [ 1039.635717] [ INFO: possible circular locking dependency detected ]
> [ 1039.637255] 3.8.0-rc7-next-20130215-sasha-00003-gea816fa #286 Tainted: G        W
> [ 1039.639104] -------------------------------------------------------
> [ 1039.640579] init/1 is trying to acquire lock:
> [ 1039.641224]  ((oom_notify_list).rwsem){.+.+..}, at: [<ffffffff81141c8f>] __blocking_notifier_call_chain+0x7f/0xc0

We changed (optimized) rwsems via:

 3a15e0e0cdda rwsem: Implement writer lock-stealing for better scalability

so maybe it can hit different codepaths and races now?

Thanks,

	Ingo
