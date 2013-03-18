Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3CRQn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:43:58 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51388 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3CRQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:43:57 -0400
Date: Mon, 18 Mar 2013 09:43:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: workqueue code needing preemption disabled
Message-ID: <20130318164351.GA21516@mtj.dyndns.org>
References: <1363617383.25967.152.camel@gandalf.local.home>
 <20130318160652.GA20133@mtj.dyndns.org>
 <1363623799.25967.172.camel@gandalf.local.home>
 <1363624020.25967.175.camel@gandalf.local.home>
 <1363624243.25967.178.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363624243.25967.178.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

On Mon, Mar 18, 2013 at 12:30:43PM -0400, Steven Rostedt wrote:
> If you happen to know the critical areas that require preemption to be
> disabled for real, we can encapsulate them with:
> 
> 	preempt_disable_rt();
> 
> 	preempt_enable_rt();
> 
> These are currently only in the -rt patch, but it annotates locations
> that require preemption to be disabled even when -rt converts spin_locks
> into mutexes. These obviously can not contain spin_locks() as
> spin_locks() can block and schedule out.

Making gcwq locks disable preemption would be much safer / easier, but
if that's not desirable, anything touching gcwq->idle_list would be a
good place to start - worker_enter_idle() and worker_leave_idle().
Hmmm... ignoring CPU hotplug, I think those two might just do it.
Give it a try?  How reproducible is the problem?

Thanks.

-- 
tejun
