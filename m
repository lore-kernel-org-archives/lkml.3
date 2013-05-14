Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3ENIYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:24:19 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37142 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3ENIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:24:16 -0400
Message-ID: <5191F3FB.3080004@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 13:51:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
References: <87ip2opntp.fsf@nemi.mork.no> <20130512113905.GH3648@linux.vnet.ibm.com>	<87li7kp50r.fsf@nemi.mork.no> <20130512172135.GJ3648@linux.vnet.ibm.com>	<87a9o0ukll.fsf@nemi.mork.no> <87sj1rydol.fsf@nemi.mork.no>	<87wqr3j656.fsf@nemi.mork.no> <519169BF.4080208@linux.vnet.ibm.com>	<87ppwuroxb.fsf@nemi.mork.no> <5191EBEF.4060409@linux.vnet.ibm.com> <87ehdaezvh.fsf@nemi.mork.no>
In-Reply-To: <87ehdaezvh.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051408-5490-0000-0000-00000376B0B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 01:50 PM, Bjørn Mork wrote:
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>> On 05/14/2013 01:08 PM, Bjørn Mork wrote:
>>> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>>>
>>>> The problem appears to be in the cpu idle poll implementation. You can trigger
>>>> this problem by passing idle=poll in the kernel cmd-line as well, right?
>>>
>>> That sounded so obvious that it made me think "Doh, why didn't I just
>>> test that before?"  But unfortunately there must be some other factor
>>> involved. No warnings observed during normal use when running with
>>> idle=poll:
>>>
>>
>> I didn't expect warnings with normal use.
>>
>>>  bjorn@nemi:~$ dmesg|grep polling
>>>  [    0.000000] process: using polling idle threads
>>>
>>>
>>> I expected a flood of warnings here, but there is none until I start
>>> powertop (to confirm that the original issue is still there).  So it's
>>> more than just entering cpu_idle_poll().
>>>
>>
>> Yeah, of course it is :-) The warning triggers only when you enable the tracepoint
>> in the idle code. And in your case, powertop does that. That's why it only
>> triggers when you run powertop. Alternatively, if you enable the tracepoint
>> yourself manually, I bet you'll see the warnings, even without using powertop.
> 
> Ah, right.  That sounds so obvious I have to go "Doh!" again:)
> 

:-)

>>>> I think I understand what is going on here. Can you please try the fix below?
>>>> (It is only compile-tested since its very late here and I really need to get
>>>> some sleep!).
>>>
>>> Works perfect.  Thanks. 
>>
>> Thanks for your testing!
>>
>>> I assume this is the correct fix even if the
>>> problem isn't completely understood?
>>>
>>
>> Hmm? Why do you say the problem isn't completely understood? I thought I
>> explained the problem in my changelog. Did I miss something?
> 
> No, I did.  I didn't understand the tracepoint part of this.  But it is
> all perfectly clear to me too now, after your excellent explanation
> above.
> 

Great! Thanks :)
 
Regards,
Srivatsa S. Bhat

