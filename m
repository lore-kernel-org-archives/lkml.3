Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaARTQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 14:16:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46488 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaARTQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 14:16:28 -0500
Message-ID: <52DAD2B1.2050401@zytor.com>
Date: Sat, 18 Jan 2014 11:14:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>,
        Peter Zijlstra <peterz@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>	 <20140116121955.GQ31570@twins.programming.kicks-ass.net>	 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>	 <20140116222536.GX30183@twins.programming.kicks-ass.net>	 <20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>	 <52D8625C.1000902@zytor.com>	 <20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>	 <1390038366.5676.10.camel@marge.simpson.net>	 <20140118124451.GA30183@twins.programming.kicks-ass.net> <1390058494.5439.3.camel@marge.simpson.net>
In-Reply-To: <1390058494.5439.3.camel@marge.simpson.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2014 07:21 AM, Mike Galbraith wrote:
> On Sat, 2014-01-18 at 13:44 +0100, Peter Zijlstra wrote: 
>> On Sat, Jan 18, 2014 at 10:46:06AM +0100, Mike Galbraith wrote:
>>>
>>> I hope it doesn't look quite like that, next-20140117 is -ENOBOOT on
>>> Q6600 box.  See below for an alternative.
>>
>> Urgh, I see, we call the idle arch_cpu_idle() callback with irqs
>> disabled.
>>
>> Could something like this work?
>>
>> 	local_irq_enable();
>> 	mwait_idle_with_hints(0,0);
>>
>> The interrupt enable window is slightly larger, but I'm not immediately
>> seeing a problem with that.
> 
> Yup, works just fine.  Less is more.
> 
> Nice to see a _progression_ in the pipe too btw.
> 

This means an interrupt window is open and we can take an interrupt
between checking need_resched and the MWAIT, which couldn't happen with
__sti_mwait().

Are we sure that is actually safe?

	-hpa


