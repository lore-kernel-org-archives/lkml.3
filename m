Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaAQSK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:10:27 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26833 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaAQSK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:10:26 -0500
Message-ID: <52D971FE.9030008@hp.com>
Date: Fri, 17 Jan 2014 13:10:06 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        waiman.long@hp.com, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@ghostprotocols.net, luto@amacapital.net,
        akpm@linux-foundation.org, tglx@linutronix.de, scott.norton@hp.com,
        aswin@hp.com
CC: tip-bot for Peter Zijlstra <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86, mm, perf: Allow recursive faults from interrupts
References: <20140110200603.GJ7572@laptop.programming.kicks-ass.net> <tip-c026b3591e4f2a4993df773183704bb31634e0bd@git.kernel.org>
In-Reply-To: <tip-c026b3591e4f2a4993df773183704bb31634e0bd@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 08:39 AM, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  c026b3591e4f2a4993df773183704bb31634e0bd
> Gitweb:     http://git.kernel.org/tip/c026b3591e4f2a4993df773183704bb31634e0bd
> Author:     Peter Zijlstra<peterz@infradead.org>
> AuthorDate: Fri, 10 Jan 2014 21:06:03 +0100
> Committer:  Ingo Molnar<mingo@kernel.org>
> CommitDate: Thu, 16 Jan 2014 09:19:48 +0100
>
> x86, mm, perf: Allow recursive faults from interrupts
>
> Waiman managed to trigger a PMI while in a emulate_vsyscall() fault,
> the PMI in turn managed to trigger a fault while obtaining a stack
> trace. This triggered the sig_on_uaccess_error recursive fault logic
> and killed the process dead.
>
> Fix this by explicitly excluding interrupts from the recursive fault
> logic.
>
> Reported-and-Tested-by: Waiman Long<waiman.long@hp.com>
> Fixes: e00b12e64be9 ("perf/x86: Further optimize copy_from_user_nmi()")
> Cc: Aswin Chandramouleeswaran<aswin@hp.com>
> Cc: Scott J Norton<scott.norton@hp.com>
> Cc: Linus Torvalds<torvalds@linux-foundation.org>
> Cc: Andy Lutomirski<luto@amacapital.net>
> Cc: Arnaldo Carvalho de Melo<acme@ghostprotocols.net>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
> Link: http://lkml.kernel.org/r/20140110200603.GJ7572@laptop.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar<mingo@kernel.org>
> ---
>   arch/x86/mm/fault.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
>

Will that be picked up by Linus as it is a 3.13 regression?

-Longman
