Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750741AbaKURaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:30:21 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:41480 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaKURaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:30:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
References: <alpine.DEB.2.11.1411202204030.3950@nanos> <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos> <20141120230514.GB25393@htj.dyndns.org>
 <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org> <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
 <20141121162742.GB15461@htj.dyndns.org> <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
 <CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
 <20141121170805.GD30603@home.goodmis.org> <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 09:22:41 -0800
Message-ID: <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 9:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 21, 2014 at 9:08 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> Actually, in_nmi() is now safe for vmalloc faults. In fact, it handles the
>> clobbering of the cr2 register just fine.
>
> That's not what I object to and find incorrect wrt NMI.
>
> Compare the simple and correct 32-bit code to the complex and
> incorrect 64-bit code.
>
> In particular, look at how the 32-bit code relies *entirely* on hardware state.
>
> Then look at where the 64-bit code does not.

Both mystify me.  Why does the 32-bit version walk down the hierarchy
at all instead of just touching the top level?

And why does the 64-bit version assert that the leaves of the tables
match?  It's already asserted that it's walking down pgd pointers that
are *exactly the same pointers*, so of course the stuff they point to
is the same.

--Andy
