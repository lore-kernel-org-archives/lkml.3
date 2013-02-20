Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab3BTRuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:50:22 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36833 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3BTRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:50:21 -0500
Date: Wed, 20 Feb 2013 18:50:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Clark Williams <clark.williams@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: move RR_TIMESLICE from sysctl.h to rt.h
Message-ID: <20130220175015.GA14541@gmail.com>
References: <1361373550-4011-1-git-send-email-clark.williams@gmail.com>
 <1361373550-4011-2-git-send-email-clark.williams@gmail.com>
 <CA+8MBb+-Btdiga9omw0g_jU2eH5DwHDmNC5n1qqh9tgFjtXN7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+-Btdiga9omw0g_jU2eH5DwHDmNC5n1qqh9tgFjtXN7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@gmail.com> wrote:

> On Wed, Feb 20, 2013 at 7:19 AM, Clark Williams
> <clark.williams@gmail.com> wrote:
> > Signed-off-by: Clark Williams <clark.williams@gmail.com>
> > ---
> 
> This happens to unbreak the ia64 build which is currently grumbling about:
> 
> arch/ia64/kernel/init_task.c:38: error: 'RR_TIMESLICE' undeclared here
> (not in a function)
> 
> So I'd be happy if it got applied directly to Linus tree before I get too big of
> a bisection gap.

Hm, didn't it get fixed via the commit below?

Thanks,

	Ingo

--------------------->
commit 77852fea6e2442a0e654a9292060489895de18c7
Author: Ingo Molnar <mingo@kernel.org>
Date:   Sat Feb 16 09:46:48 2013 +0100

    sched/rt: Add <linux/sched/rt.h> header to <linux/init_task.h>
    
    IA64 relied on it through sched.h inclusion:
    
      arch/ia64/kernel/init_task.c:38:11: error: 'MAX_PRIO' undeclared here (not in a function)
      arch/ia64/kernel/init_task.c:38:11: error: 'RR_TIMESLICE' undeclared here (not in a function)
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Cc: Clark Williams <williams@redhat.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Link: http://lkml.kernel.org/n/tip-xaan1twswggedMR0airtpjui@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

