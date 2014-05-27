Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaE0M5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:57:45 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:39460 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaE0M5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:57:44 -0400
Message-ID: <53848B81.4090709@huawei.com>
Date: Tue, 27 May 2014 20:56:33 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com>	 <1401090987.5339.79.camel@marge.simpson.net> <53832A36.5020205@huawei.com>	 <20140527094802.GN30445@twins.programming.kicks-ass.net>	 <1401185133.5134.119.camel@marge.simpson.net>	 <20140527104349.GP30445@twins.programming.kicks-ass.net> <1401188155.5134.125.camel@marge.simpson.net>
In-Reply-To: <1401188155.5134.125.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/27 18:55, Mike Galbraith wrote:
> On Tue, 2014-05-27 at 12:43 +0200, Peter Zijlstra wrote: 
>> On Tue, May 27, 2014 at 12:05:33PM +0200, Mike Galbraith wrote:
>>> On Tue, 2014-05-27 at 11:48 +0200, Peter Zijlstra wrote:
>>>
>>>> So I suppose this is due to the select_idle_sibling() nonsense again,
>>>> where we assumes L3 is a fair compromise between cheap enough and
>>>> effective enough.
>>>
>>> Nodz.
>>>
>>>> Of course, Intel keeps growing the cpu count covered by L3 to ridiculous
>>>> sizes, 8 cores isn't nowhere near their top silly, which shifts the
>>>> balance, and there's always going to be pathological cases (like the
>>>> proposed workload) where its just always going to suck eggs.
>>>
>>> Test is as pathological as it gets.  15 core + SMT wouldn't be pretty.
>>
>> So one thing we could maybe do is measure the cost of
>> select_idle_sibling(), just like we do for idle_balance() and compare
>> this against the tasks avg runtime.
>>
>> We can go all crazy and do reduced searches; like test every n-th cpu in
>> the mask, or make it statistical and do a full search ever n wakeups.
>>
>> Not sure what's a good approach. But L3 spanning more and more CPUs is
>> not something that's going to get cured anytime soon I'm afraid.
>>
>> Not to mention bloody SMT which makes the whole mess worse.
> 
> I think we should keep it dirt simple and above all dirt cheap.  The per
> task migration cap per unit time should meet that bill, limit the damage
> potential, while also limiting the good, but that's tough.  I don't see

agree

> any way to make it perfect, so I'll settle for good enough.
> 
> -Mike
> 
> 
> 
> 


