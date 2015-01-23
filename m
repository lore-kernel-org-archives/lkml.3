Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbbAWUtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:49:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38539 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbbAWUtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:49:33 -0500
Message-ID: <54C2B396.9090106@oracle.com>
Date: Fri, 23 Jan 2015 15:48:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST
 context
References: <cover.1416604491.git.luto@amacapital.net> <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net> <54C17139.1040706@oracle.com> <CALCETrWEUXHOaG-WzDkteoMP=6=tAvyNLfrbg=Xf8ybvMumAow@mail.gmail.com> <20150123180455.GA3192@pd.tnic> <CALCETrXA+OKGfxV9M=1AxvBSBPAt_+VmjDH0A+Rq4Ss+tKmTBw@mail.gmail.com>
In-Reply-To: <CALCETrXA+OKGfxV9M=1AxvBSBPAt_+VmjDH0A+Rq4Ss+tKmTBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 01:34 PM, Andy Lutomirski wrote:
> On Fri, Jan 23, 2015 at 10:04 AM, Borislav Petkov <bp@alien8.de> wrote:
>> On Fri, Jan 23, 2015 at 09:58:01AM -0800, Andy Lutomirski wrote:
>>>> [  543.999079] Call Trace:
>>>> [  543.999079] dump_stack (lib/dump_stack.c:52)
>>>> [  543.999079] lockdep_rcu_suspicious (kernel/locking/lockdep.c:4259)
>>>> [  543.999079] atomic_notifier_call_chain (include/linux/rcupdate.h:892 kernel/notifier.c:182 kernel/notifier.c:193)
>>>> [  543.999079] ? atomic_notifier_call_chain (kernel/notifier.c:192)
>>>> [  543.999079] notify_die (kernel/notifier.c:538)
>>>> [  543.999079] ? atomic_notifier_call_chain (kernel/notifier.c:538)
>>>> [  543.999079] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
>>>> [  543.999079] do_debug (arch/x86/kernel/traps.c:652)
>>>> [  543.999079] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
>>>> [  543.999079] ? do_int3 (arch/x86/kernel/traps.c:610)
>>>> [  543.999079] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2554 kernel/locking/lockdep.c:2601)
>>>> [  543.999079] debug (arch/x86/kernel/entry_64.S:1310)
>>>
>>> I don't know how to read this stack trace.  Are we in do_int3,
>>> do_debug, or both?  I didn't change do_debug at all.
>>
>> It looks like we're in do_debug. do_int3 is only on the stack but not
>> part of the current frame if I can trust the '?' ...
>>
> 
> It's possible that an int3 happened and I did something wrong on
> return that caused a subsequent do_debug to screw up, but I don't see
> how my patch would have caused that.
> 
> Were there any earlier log messages?

Nope, nothing odd before or after.


Thanks,
Sasha

