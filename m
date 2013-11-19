Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3KSTSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:18:23 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:62770 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3KSTSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:18:10 -0500
Date: Tue, 19 Nov 2013 20:18:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] core kernel update
Message-ID: <20131119191806.GA22620@gmail.com>
References: <20131119154253.GA12219@gmail.com>
 <CA+55aFzyBxFi8_4C4hAz6+SAgtHCmQtpxSyJhRyWzggoRGTD5w@mail.gmail.com>
 <20131119190904.GA22076@gmail.com>
 <20131119191434.GQ16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119191434.GQ16796@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Nov 19, 2013 at 08:09:04PM +0100, Ingo Molnar wrote:
> > The actual value of the limit - here's the on-stack cpumask sizes of 
> > the candidate range:
> > 
> > 	128 CPUs: 16 byte cpumasks
> > 	256 CPUs: 32 byte cpumasks
> > 	512 CPUs: 64 byte cpumasks
> 
> So 512 / 64bytes is a single cacheline and feels like a nice cut-off
> before requiring an extra indirection and more cachelines.
> 
> 64 bytes also doesn't sound _that_ big to have on-stack.

The cacheline size itself isn't necessarily super meaningful for 
on-stack variables: they are rarely cacheline aligned so they will 
take part in two cachelines.

> So I'd go for having the cut-off on >512, unless of course theres 
> evidence 64bytes is already too much.

I'm fine with that in any case, for the other reason I outlined: it's 
the highest one and we can iterate down if it proves to be bad. If we 
start out too low we'll probably never know it was too low.

Thanks,

	Ingo
