Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaANOPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:15:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33616 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaANOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:14:20 -0500
Date: Tue, 14 Jan 2014 15:14:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140114141406.GD7572@laptop.programming.kicks-ass.net>
References: <20140114142627.537a702607e703c6eff63640@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114142627.537a702607e703c6eff63640@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 02:26:27PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/cpufreq/speedstep-lib.c: In function 'speedstep_get_freqs':
> drivers/cpufreq/speedstep-lib.c:467:2: error: implicit declaration of function 'preempt_check_resched' [-Werror=implicit-function-declaration]
>   preempt_check_resched();
>   ^
> 
> Caused by commit 62b94a08da1b ("sched/preempt: Take away
> preempt_enable_no_resched() from modules") interacting with commit
> 24e1937b2386 ("speedstep-smi: enable interrupts when waiting") from the
> pm tree.

I think that pm commit is a very good example of why the sched/preempt
patch is a very good idea.

Also that Changelog fails to explain why enabling interrupts helps. What
interrupt is required for progress, and how does it make the progress
happen.
