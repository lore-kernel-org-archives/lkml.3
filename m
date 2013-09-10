Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3IJWHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:07:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44988 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3IJWHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:07:30 -0400
Message-ID: <522F97DD.1060002@zytor.com>
Date: Tue, 10 Sep 2013 15:06:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
References: <20130910130811.507933095@infradead.org> <20130910135152.GD7537@gmail.com> <20130910135636.GA8268@gmail.com> <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com> <20130910164519.GL31370@twins.programming.kicks-ass.net> <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com> <20130910212509.GA18147@laptop.programming.kicks-ass.net> <CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com> <522F9464.9070806@zytor.com> <CA+55aFwabYsi=FvrAX+hqbpw5XUXqsokHn_Cyypv-JXmca6Q6Q@mail.gmail.com>
In-Reply-To: <CA+55aFwabYsi=FvrAX+hqbpw5XUXqsokHn_Cyypv-JXmca6Q6Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 03:02 PM, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 2:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 09/10/2013 02:43 PM, Linus Torvalds wrote:
>>
>> Actually, the right thing here really is "er" (which I think you meant,
>> but just to make it clear.)
> 
> Yes, I was just answering the i-vs-e confusion.
> 
>> "e" doesn't work on versions of gcc older than the first x86-64 release,
>> but we don't care about that anymore.
> 
> Indeed.
> 
>> A final good question is if we should encapsulate the add/inc and
>> sub/dec into a single function; one could easily do somethin glike:
> 
> Yes. However, I would do that at a higher level than the one that
> builds the actual functions.
> 
> That said, there's a few cases where you might want to specify
> add-vs-sub explicitly, but they are rather odd, namely the fact that
> "-128" fits in a byte, but "128" does not.
> 
> So it can be better to add 128 by doing a "subl $-128" than by doing
> an "add $128".
> 
> But we probably don't have any situation where we care about that
> special value of "128". I've seen the trick, though.
> 

Yes, and if __builtin_constant_p() we could even do it explicitly.
Unfortunately I don't think gcc allows alternatives in asm() statements,
unlike in its own pattern tables.

	-hpa

