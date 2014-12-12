Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaLLXzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:55:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46603 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaLLXza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:55:30 -0500
Message-ID: <548B8046.4040808@oracle.com>
Date: Fri, 12 Dec 2014 18:54:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141201230339.GA20487@ret.masoncoding.com>	<1417529606.3924.26.camel@maggy.simpson.net>	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>	<1417540493.21136.3@mail.thefacebook.com>	<20141203184111.GA32005@redhat.com>	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>	<20141205171501.GA1320@redhat.com>	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>	<1417806247.4845.1@mail.thefacebook.com>	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>	<20141211145408.GB16800@redhat.com>	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>	<548A122C.8000906@oracle.com> <CA+55aFw68nC+5s=iX2R4SLsgG3nBvURmDXYvX5pFJgHBnQoHMA@mail.gmail.com> <548A2165.9030107@oracle.com>
In-Reply-To: <548A2165.9030107@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 05:57 PM, Sasha Levin wrote:
> On 12/11/2014 05:36 PM, Linus Torvalds wrote:
>> > On Thu, Dec 11, 2014 at 1:52 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>>> >> >
>>>> >> > Is it possible that Dave and myself were seeing the same problem after
>>>> >> > all?
>> > Could be. You do have commonalities, even if the actual symptoms then
>> > differ. And while it looked different when you could trigger it with
>> > 3.16 but DaveJ couldn't, that's up in the air now that I doubt that
>> > 3.16 really is ok for DaveJ after all..
>> > 
>> > And you might have a better luck bisecting it, since you seem to be
>> > able to trigger your RCU lockup much more quickly (and apparently
>> > reliably? Correct?)
> Right, and it reproduces in 3.10 as well, so it's not really a new thing.
> 
> What's odd is that I don't remember seeing this bug so long in the past,
> I'll try bisecting trinity rather than the kernel - it's the only other
> thing that changed.

So I checked out trinity from half a year ago, and could not reproduce the
stall any more. Not on v3.16 nor on the current -next.

I ran bisection on trinity, rather than the kernel, and got the following
result:

commit f2be2d5ffe4bf896eb5418972013822a2bef0cee
Author: Dave Jones <davej@redhat.com>
Date:   Mon Aug 4 19:55:17 2014 -0400

    begin some infrastructure to use a bunch of test files for fsx like ops.

I've been running trinity f2be2d5ff^ on -next for two hours now, and there's
no sign of a lockup. Previously it took ~10 minutes trigger.


Thanks,
Sasha
