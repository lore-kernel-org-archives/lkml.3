Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaAQTSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:18:04 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:58246 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaAQTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:17:59 -0500
MIME-Version: 1.0
In-Reply-To: <52D971FE.9030008@hp.com>
References: <20140110200603.GJ7572@laptop.programming.kicks-ass.net>
 <tip-c026b3591e4f2a4993df773183704bb31634e0bd@git.kernel.org> <52D971FE.9030008@hp.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 17 Jan 2014 11:17:38 -0800
Message-ID: <CALCETrWF4AwFrBrA1WdrEUj5=oPfiPPUF7PJCooagTi6Y07Pwg@mail.gmail.com>
Subject: Re: [tip:perf/core] x86, mm, perf: Allow recursive faults from interrupts
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Scott J Norton <scott.norton@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        tip-bot for Peter Zijlstra <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 10:10 AM, Waiman Long <waiman.long@hp.com> wrote:
> On 01/16/2014 08:39 AM, tip-bot for Peter Zijlstra wrote:
>>
>> Commit-ID:  c026b3591e4f2a4993df773183704bb31634e0bd
>> Gitweb:
>> http://git.kernel.org/tip/c026b3591e4f2a4993df773183704bb31634e0bd
>> Author:     Peter Zijlstra<peterz@infradead.org>
>> AuthorDate: Fri, 10 Jan 2014 21:06:03 +0100
>> Committer:  Ingo Molnar<mingo@kernel.org>
>> CommitDate: Thu, 16 Jan 2014 09:19:48 +0100
>>
>> x86, mm, perf: Allow recursive faults from interrupts
>>
>> Waiman managed to trigger a PMI while in a emulate_vsyscall() fault,
>> the PMI in turn managed to trigger a fault while obtaining a stack
>> trace. This triggered the sig_on_uaccess_error recursive fault logic
>> and killed the process dead.
>>
>> Fix this by explicitly excluding interrupts from the recursive fault
>> logic.
>>
>> Reported-and-Tested-by: Waiman Long<waiman.long@hp.com>
>> Fixes: e00b12e64be9 ("perf/x86: Further optimize copy_from_user_nmi()")
>> Cc: Aswin Chandramouleeswaran<aswin@hp.com>
>> Cc: Scott J Norton<scott.norton@hp.com>
>> Cc: Linus Torvalds<torvalds@linux-foundation.org>
>> Cc: Andy Lutomirski<luto@amacapital.net>
>> Cc: Arnaldo Carvalho de Melo<acme@ghostprotocols.net>
>> Cc: Andrew Morton<akpm@linux-foundation.org>
>> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
>> Link:
>> http://lkml.kernel.org/r/20140110200603.GJ7572@laptop.programming.kicks-ass.net
>> Signed-off-by: Ingo Molnar<mingo@kernel.org>
>> ---
>>   arch/x86/mm/fault.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>>
>
> Will that be picked up by Linus as it is a 3.13 regression?

Does anyone actually know why this regressed recently?  The buggy code
has been there for quite a while.

--Andy
