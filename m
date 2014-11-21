Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaKUUCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:02:44 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51598 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaKUUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:02:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141121200052.GA28668@redhat.com>
References: <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
 <CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
 <20141121170805.GD30603@home.goodmis.org> <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
 <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
 <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
 <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
 <20141121142301.564f7eb7@gandalf.local.home> <CA+55aFw6w+pkG7fs7tBVm7jV_TjsnEyG5XDdk+Ghf5Af+ELUeA@mail.gmail.com>
 <CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com> <20141121200052.GA28668@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 12:02:19 -0800
Message-ID: <CALCETrWgS5fitrkGjbu=TNKp2YbNYeS8WBpPvS50Xf1kp116zw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Josh Boyer <jboyer@redhat.com>, Justin Forbes <jforbes@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 12:00 PM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Nov 21, 2014 at 11:46:57AM -0800, Linus Torvalds wrote:
>
>  > Anybody who seriously does virtualization uses hw virtualization that
>  > is much better than it used to be. And the non-serious users aren't
>  > that performance-sensitive by definition.
>  >
>  > I note that the Fedora kernel config seems to include paravirt by
>  > default, so you get a lot of the crazy overheads..
>
> I'm not sure how many people actually use paravirt these days,
> but the reason Fedora has it enabled still at least is probably
> because..
>
> config KVM_GUEST
>          bool "KVM Guest support (including kvmclock)"
>          depends on PARAVIRT
>
> But tbh I've not looked at this stuff since it first got merged.
> Will a full-virt system kvm boot a guest without KVM_GUEST enabled ?
> (ie, is this just an optimisation for the paravirt case?)
>

It will boot just fine, although there may be some timing glitches.

I think we should have PARAVIRT_LITE that's just enough for KVM.  That
probably involves some apic changes and nothing else.

--Andy

> I'm not a heavy virt user, so I don't even remember how a lot of
> this stuff is supposed to work.
>
>         Dave
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
