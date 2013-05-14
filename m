Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3ENIVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:21:16 -0400
Received: from canardo.mork.no ([148.122.252.1]:41587 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab3ENIVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:21:12 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
Organization: m
References: <87ip2opntp.fsf@nemi.mork.no>
	<20130512113905.GH3648@linux.vnet.ibm.com>
	<87li7kp50r.fsf@nemi.mork.no>
	<20130512172135.GJ3648@linux.vnet.ibm.com>
	<87a9o0ukll.fsf@nemi.mork.no> <87sj1rydol.fsf@nemi.mork.no>
	<87wqr3j656.fsf@nemi.mork.no> <519169BF.4080208@linux.vnet.ibm.com>
	<87ppwuroxb.fsf@nemi.mork.no> <5191EBEF.4060409@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 10:20:50 +0200
In-Reply-To: <5191EBEF.4060409@linux.vnet.ibm.com> (Srivatsa S. Bhat's message
	of "Tue, 14 May 2013 13:16:55 +0530")
Message-ID: <87ehdaezvh.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
> On 05/14/2013 01:08 PM, Bjørn Mork wrote:
>> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>>
>>> The problem appears to be in the cpu idle poll implementation. You can trigger
>>> this problem by passing idle=poll in the kernel cmd-line as well, right?
>> 
>> That sounded so obvious that it made me think "Doh, why didn't I just
>> test that before?"  But unfortunately there must be some other factor
>> involved. No warnings observed during normal use when running with
>> idle=poll:
>> 
>
> I didn't expect warnings with normal use.
>
>>  bjorn@nemi:~$ dmesg|grep polling
>>  [    0.000000] process: using polling idle threads
>> 
>> 
>> I expected a flood of warnings here, but there is none until I start
>> powertop (to confirm that the original issue is still there).  So it's
>> more than just entering cpu_idle_poll().
>>
>
> Yeah, of course it is :-) The warning triggers only when you enable the tracepoint
> in the idle code. And in your case, powertop does that. That's why it only
> triggers when you run powertop. Alternatively, if you enable the tracepoint
> yourself manually, I bet you'll see the warnings, even without using powertop.

Ah, right.  That sounds so obvious I have to go "Doh!" again:)

>>> I think I understand what is going on here. Can you please try the fix below?
>>> (It is only compile-tested since its very late here and I really need to get
>>> some sleep!).
>> 
>> Works perfect.  Thanks. 
>
> Thanks for your testing!
>
>> I assume this is the correct fix even if the
>> problem isn't completely understood?
>> 
>
> Hmm? Why do you say the problem isn't completely understood? I thought I
> explained the problem in my changelog. Did I miss something?

No, I did.  I didn't understand the tracepoint part of this.  But it is
all perfectly clear to me too now, after your excellent explanation
above.


Thanks,
Bjørn
