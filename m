Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbaLKVxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:53:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50858 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaLKVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:53:29 -0500
Message-ID: <548A122C.8000906@oracle.com>
Date: Thu, 11 Dec 2014 16:52:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141201230339.GA20487@ret.masoncoding.com>	<1417529606.3924.26.camel@maggy.simpson.net>	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>	<1417540493.21136.3@mail.thefacebook.com>	<20141203184111.GA32005@redhat.com>	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>	<20141205171501.GA1320@redhat.com>	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>	<1417806247.4845.1@mail.thefacebook.com>	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>	<20141211145408.GB16800@redhat.com> <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
In-Reply-To: <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 04:49 PM, Linus Torvalds wrote:
> On Thu, Dec 11, 2014 at 6:54 AM, Dave Jones <davej@redhat.com> wrote:
>> >
>> > So either one of those 'good's actually wasn't, or I'm just cursed.
> Even if there was a good that wasn't, that last "bad"  (6f929b4e5a02)
> is already sufficient just on its own to say that likely v3.16 already
> had the problem.
> 
> Just do
> 
>    gitk v3.16..6f929b4e5a02
> 
> and cry.
> 
> (or "git diff --stat -M v3.16...6f929b4e5a02" to see what that commit
> brought in from the common ancestor).
> 
> So I'd call that bisect a failure, and your "v3.16 is fine" is
> actually suspect after all. Which *might* mean that it's some hardware
> issue after all. Or there are multiple different problems, and while
> v3.16 was fine, the problem was introduced earlier (in the common
> ancestor of that staging tree), then fixed for 3.16, and then
> re-introduced later again.

Is it possible that Dave and myself were seeing the same problem after
all?

I'll go bisect it even further back...


Thanks,
Sasha
