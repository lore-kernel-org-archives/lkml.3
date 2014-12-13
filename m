Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaLMOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 09:16:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945AbaLMOQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 09:16:27 -0500
Message-ID: <548C4A06.5020301@oracle.com>
Date: Sat, 13 Dec 2014 09:15:34 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?windows-1252?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com> <20141205171501.GA1320@redhat.com> <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com> <1417806247.4845.1@mail.thefacebook.com> <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com> <20141211145408.GB16800@redhat.com> <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com> <20141212185454.GB4716@redhat.com> <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com> <20141213081953.GG32572@gmail.com> <20141213082751.GA1526@gmail.com>
In-Reply-To: <20141213082751.GA1526@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 03:27 AM, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
>>
>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>> On Fri, Dec 12, 2014 at 10:54 AM, Dave Jones <davej@redhat.com> wrote:
>>>
>>>>
>>>> Something that's still making me wonder if it's some kind of 
>>>> hardware problem is the non-deterministic nature of this bug.
>>>
>>> I'd expect it to be a race condition, though. Which can easily 
>>> cause these kinds of issues, and the timing will be pretty 
>>> random even if the load is very regular.
>>>
>>> And we know that the scheduler has an integer overflow under 
>>> Sasha's loads, although I didn't hear anything from Ingo and 
>>> friends about it. Ingo/Peter, you were cc'd on that report, 
>>> where at least one of the multiplcations in wake_affine() ended 
>>> up overflowing..
>>
>> Just to make sure, is there any other wake_affine report other 
>> than the one in this thread? (I tried a wake_affine full text 
>> search on my inbox and didn't find anything that appeared 
>> relevant.)
> 
> Found the report from Sasha:
> 
>     sched: odd values for effective load calculations
> 
> right?

Yup, that's the one.


Thanks,
Sasha

