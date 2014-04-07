Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaDGTtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:49:33 -0400
Received: from smtp1.ngi.it ([88.149.128.112]:37266 "EHLO smtp1.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbaDGTt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:49:28 -0400
Message-ID: <5343015C.5090309@katamail.com>
Date: Mon, 07 Apr 2014 21:49:48 +0200
From: Michele Ballabio <barra_cuda@katamail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, toralf.foerster@gmx.de, fweisbec@gmail.com,
        mingo@kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
References: <5341707F.5000406@katamail.com> <20140407150337.GO10526@twins.programming.kicks-ass.net> <20140407150705.GB13658@twins.programming.kicks-ass.net>
In-Reply-To: <20140407150705.GB13658@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 17:07, Peter Zijlstra wrote:
> On Mon, Apr 07, 2014 at 05:03:37PM +0200, Peter Zijlstra wrote:
>> So what I suspect at this point is that because i386 and x86_64 have a
>> difference in current_thread_info() (i386 is stack based), we end up
>> setting the TIF_NEED_RESCHED bit on the wrong stack.
>>
>> Now I have some vague memories of propagating the TIF flags on stack
>> switch, but I cannot remember what arch we did that for. Let me stare at
>> this a little more.
>>
>> Also, IFF this is the case, then the fingered patch above (and your
>> suggested 'fix') aren't the real curlpit/cure but simply make it
>> more/less likely to happen.

Understood.

>> Now, Steve had a patch somewhere that would make i386 use per-cpu
>> variables for current_thread_info() just like x86_64 already does I
>> think. Let me go find them too.
> 
> Ohh, goodie, they're already in Linus' tree. Could you see if current
> git still suffers this problem?

It is fixed on current -master (3.14.0-10773-gb8780c3).

Thanks.

