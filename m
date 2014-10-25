Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbaJYAvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 20:51:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18588 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaJYAvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 20:51:51 -0400
Message-ID: <544AF3E6.7090003@oracle.com>
Date: Fri, 24 Oct 2014 20:50:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Andreas Dilger <adilger@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michal Marek <mmarek@suse.cz>, "x86@kernel.org" <x86@kernel.org>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com> <5444EBFA.5030103@samsung.com> <20141020124929.GA23177@thunk.org> <54451501.2070700@samsung.com> <5445179A.4080804@redhat.com> <20141020141635.GA4499@thunk.org> <20141024100108.GF12706@worktop.programming.kicks-ass.net> <544A52D7.6000202@oracle.com> <20141024134205.GB21513@worktop.programming.kicks-ass.net> <544A6A6B.3040602@oracle.com> <CACT4Y+boMTKpTovCWYQa6baSAWjagCN=mwXBZGAjbobzG80oWA@mail.gmail.com> <2E512EF7-577C-43C2-AB95-30DC25AD059D@dilger.ca> <544AD123.1010304@zytor.com>
In-Reply-To: <544AD123.1010304@zytor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 06:22 PM, H. Peter Anvin wrote:
>> By the principle of least surprise, I would expect "__u32 >> N", where
>> > N >= 32 to return zero instead of random garbage.  For N < 32 it will
>> > return progressively smaller numbers, until it has shifted away all of
>> > the set bits, at which turn it will return 0.  For it suddenly to jump
>> > up once N = 32 is used, is counter-intuitive.
>> > 
> That's why it is undefined.

Now I'm curious about things like "memcpy(ptr, NULL, 0)". According to the
standard they're undefined, and since we're using gcc's implementation for
memcpy() we are doing "undefined memcpy" in quite a few places in the kernel.

Is it an issue, or would you expect memcpy() to not deref the "from" ptr
since length is 0?


Thanks,
Sasha
