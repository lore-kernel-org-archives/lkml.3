Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965973AbaLMIT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 03:19:59 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35615 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965934AbaLMIT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 03:19:58 -0500
Date: Sat, 13 Dec 2014 09:19:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213081953.GG32572@gmail.com>
References: <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Dec 12, 2014 at 10:54 AM, Dave Jones <davej@redhat.com> wrote:
>
> >
> > Something that's still making me wonder if it's some kind of 
> > hardware problem is the non-deterministic nature of this bug.
> 
> I'd expect it to be a race condition, though. Which can easily 
> cause these kinds of issues, and the timing will be pretty 
> random even if the load is very regular.
> 
> And we know that the scheduler has an integer overflow under 
> Sasha's loads, although I didn't hear anything from Ingo and 
> friends about it. Ingo/Peter, you were cc'd on that report, 
> where at least one of the multiplcations in wake_affine() ended 
> up overflowing..

Just to make sure, is there any other wake_affine report other 
than the one in this thread? (I tried a wake_affine full text 
search on my inbox and didn't find anything that appeared 
relevant.)

> Some scheduler thing that overflows only under heavy load, and 
> screws up scheduling could easily account for the RCU thread 
> thing. I see it *less* easily accounting for DaveJ's case, 
> though, because the watchdog is running at RT priority, and the 
> scheduler would have to screw up much more to then not schedule 
> an RT task, but..

Yeah, the RT scheduler is harder (but not impossible) to confuse 
due to its simplicity, but scheduler counts overflowing could 
definitely cause all sorts of trouble and make debugging harder, 
so we want to fix it regardless of its likelihood of causing 
lockups.

Thanks,

	Ingo
