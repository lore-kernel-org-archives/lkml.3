Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaKUTwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:52:51 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55572 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKUTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:52:49 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com>
References: <alpine.DEB.2.11.1411202204030.3950@nanos> <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos> <20141120230514.GB25393@htj.dyndns.org>
 <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org> <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
 <20141121162742.GB15461@htj.dyndns.org> <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
 <CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
 <20141121170805.GD30603@home.goodmis.org> <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
 <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
 <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
 <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
 <20141121142301.564f7eb7@gandalf.local.home> <CA+55aFw6w+pkG7fs7tBVm7jV_TjsnEyG5XDdk+Ghf5Af+ELUeA@mail.gmail.com>
 <CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 11:52:27 -0800
Message-ID: <CALCETrX9CNx+Zs3timzxoccrqia1RiaOe5dj7crENnt2W6PGjg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 21, 2014 at 11:34 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So I kind of agree, but it wouldn't be my primary worry. My primary
>> worry is actually paravirt doing something insane.
>
> Btw, on that tangent, does anybody actually care about paravirt any more?
>

Amazon, for better or for worse.

> I'd love to start moving away from it. It makes a lot of the low-level
> code completely impossible to follow due to the random indirection
> through "native" vs "paravirt op table". Not just the page table
> handling, it's all over.
>
> Anybody who seriously does virtualization uses hw virtualization that
> is much better than it used to be. And the non-serious users aren't
> that performance-sensitive by definition.
>
> I note that the Fedora kernel config seems to include paravirt by
> default, so you get a lot of the crazy overheads..

I think that there is a move toward deprecating Xen PV in favor of
PVH, but we're not there yet.

--Andy
