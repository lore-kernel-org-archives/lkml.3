Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaANPtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:49:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaANPtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:49:12 -0500
Message-ID: <52D55C46.6010701@zytor.com>
Date: Tue, 14 Jan 2014 07:48:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
References: <20140114155331.88d170d3c991b9465c23a537@canb.auug.org.au> <20140114125153.GY7572@laptop.programming.kicks-ass.net> <52D55479.9010802@zytor.com> <CAMuHMdUt2jCVLHr9mbV8JVnY4+vv5vEKNfk1=FoSnZ+nx6qhNw@mail.gmail.com> <20140114154142.GG7572@laptop.programming.kicks-ass.net>
In-Reply-To: <20140114154142.GG7572@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 07:41 AM, Peter Zijlstra wrote:
>>>
>>> I am *guessing* that m68k is has get_fs() == KERNEL_DS at the point that
>>> futex_init() is called.  This would seem a bit of a peculiarity to m68k,
>>> and as such it would seem like it would be better for it to belong in
>>> the m68k-specific code, but since futex_init() is init code and only
>>> called once anyway it shouldn't cause any harm...
>>
>> Yes it does. So when getting the exception on 68030, we notice it's a kernel
>> space access error, not a user space access error, and crash.
> 
> Is there a good reason m68k works like this? That is, shouldn't we fix
> the arch code instead of littering the generic code with weirdness like
> this?
> 

Given that futex_init is called from initcall, this seems *really* weird
on the part of m68k.  I agree this should be fixed where the problem sits.

	-hpa

