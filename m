Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaKRT2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:28:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:41058 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaKRT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:28:05 -0500
Date: Tue, 18 Nov 2014 20:28:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFxttmjXJX4wtwSpTOdDCMwpSopAsL3MJ1n8mJSJOEpyhQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411182023360.3909@nanos>
References: <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com> <20141115213405.GA31971@redhat.com> <20141116014006.GA5016@redhat.com> <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com> <20141117170359.GA1382@redhat.com>
 <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com> <20141118020959.GA2091@redhat.com> <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com> <20141118023930.GA2871@redhat.com> <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com> <CA+55aFxttmjXJX4wtwSpTOdDCMwpSopAsL3MJ1n8mJSJOEpyhQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Linus Torvalds wrote:
> On Tue, Nov 18, 2014 at 6:52 AM, Dave Jones <davej@redhat.com> wrote:
> >
> > Here's the first hit. Curiously, one cpu is missing.
> 
> That might be the CPU3 that isn't responding to IPIs due to some bug..
> 
> > NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c180:17837]
> > RIP: 0010:[<ffffffffa91a0db0>]  [<ffffffffa91a0db0>] bad_range+0x0/0x90
> 
> Hmm. Something looping in the page allocator? Not waiting for a lock,
> but livelocked? I'm not seeing anything here that should trigger the
> NMI watchdog at all.
> 
> Can the NMI watchdog get confused somehow?

That's the soft lockup detector which runs from the timer interrupt
not from NMI.
 
> So it does look like CPU3 is the problem, but sadly, CPU3 is
> apparently not listening, and doesn't even react to the NMI, much less

As I said in the other mail. It gets the NMI and reacts on it. It's
just mangled into the CPU0 backtrace. 

Thanks,

	tglx
