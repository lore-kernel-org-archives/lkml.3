Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaKTHpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:45:10 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43715 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaKTHpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:45:08 -0500
Date: Thu, 20 Nov 2014 08:45:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack
 in schedule and __might_sleep
Message-ID: <20141120074501.GA3805@gmail.com>
References: <cover.1416352397.git.luto@amacapital.net>
 <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
 <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
 <20141119192928.GL12538@two.firstfloor.org>
 <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
 <CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com>
 <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
 <CALCETrVJJUcPRfkWRouLJCNUVNRH3aWX0X_K8L62yrUu1aR8Vg@mail.gmail.com>
 <CA+55aFy0neTJAAm-8KsmPPU33zevyHmYa+vZjPk-DozSPPW_nQ@mail.gmail.com>
 <CALCETrXzMe2WcpY3yX48WtvdRQDvSg7CZRO1T1TdLynmAcJHXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXzMe2WcpY3yX48WtvdRQDvSg7CZRO1T1TdLynmAcJHXg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> On Wed, Nov 19, 2014 at 3:59 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, Nov 19, 2014 at 3:49 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >>
> >> My only real objection is that it's going to be ugly and 
> >> error prone. It'll have to be something like:
> >
> > No.
> >
> >> because the whole point of this series is to make the IST 
> >> entries not be atomic when they come from userspace.
> >
> > Andy, you need to lay off the drugs.
> >
> 
> No drugs, just imprecision.  This series doesn't change NMI 
> handling at all.  It only changes machine_check int3, debug, 
> and stack_segment. (Why is #SS using IST stacks anyway?)

We made most of those preemptible in -rt and changed it away from 
the IST. I never got a good explanation from anyone for why they 
were IST in the first place - histeric accident or such.

Feel free to clean this up too!

Thanks,

	Ingo
