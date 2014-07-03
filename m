Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbaGCSWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:22:32 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:49555 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaGCSWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:22:31 -0400
Message-ID: <1404411745.8764.27.camel@j-VirtualBox>
Subject: Re: [RFC] Cancellable MCS spinlock rework
From: Jason Low <jason.low2@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jej B <James.Bottomley@hansenpartnership.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Date: Thu, 03 Jul 2014 11:22:25 -0700
In-Reply-To: <CA+55aFy=CnCLet=B9Q5dYU9w885sXNuYVDSkjHAp5V+nczbn3Q@mail.gmail.com>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
	 <20140702162749.GP19379@twins.programming.kicks-ass.net>
	 <1404320356.3170.12.camel@j-VirtualBox>
	 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
	 <1404322203.3170.17.camel@j-VirtualBox>
	 <1404362358.8764.6.camel@j-VirtualBox>
	 <CA+55aFw6CF0La9FO5jX_BvukjwW618vihqVm-hPXfUpL_5dhBA@mail.gmail.com>
	 <CA+55aFy=CnCLet=B9Q5dYU9w885sXNuYVDSkjHAp5V+nczbn3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 08:35 -0700, Linus Torvalds wrote:
> On Thu, Jul 3, 2014 at 8:31 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I don't think we'll support 2 _billion_ processes/threads waiting on
> > the same semaphore any time soon, so the 'long' seems a bit of an
> > overkill on 64-bit architectures.
> 
> Oh, never mind. The 'struct semaphore' uses it as just a plain count,
> but the rwsem ends up splitting up the bits for readers/writers, so we
> actually do want the full 64-bit value there.

Yeah, that was the key to reducing the struct size as the rwsem count
can't share a 64 bit chunk with the spinlock, unlike some of the other
lock.

Thanks,
Jason

