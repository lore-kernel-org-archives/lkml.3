Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaKTXZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:25:59 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:51802 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbaKTXZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:25:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141120102836.GB791@pd.tnic>
References: <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
 <20141119192928.GL12538@two.firstfloor.org> <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
 <CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com>
 <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
 <CALCETrVJJUcPRfkWRouLJCNUVNRH3aWX0X_K8L62yrUu1aR8Vg@mail.gmail.com>
 <CA+55aFy0neTJAAm-8KsmPPU33zevyHmYa+vZjPk-DozSPPW_nQ@mail.gmail.com>
 <CALCETrXzMe2WcpY3yX48WtvdRQDvSg7CZRO1T1TdLynmAcJHXg@mail.gmail.com>
 <CA+55aFxNkD8=1JB0-4EyQTR+Yd0YaofB3+E5J+L3vsfki-RUSQ@mail.gmail.com>
 <CALCETrWBpmS_W3sN3Pf-qRL8jgxoBoQWnQuk3r_TT_eBm9eNqQ@mail.gmail.com> <20141120102836.GB791@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Nov 2014 15:25:35 -0800
Message-ID: <CALCETrVKJr9YFoU584didHR=18Fyj3xCevdT6Ro4fEEjzf8kfA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack in
 schedule and __might_sleep
To: Borislav Petkov <bp@alien8.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 20, 2014 2:28 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>
> On Wed, Nov 19, 2014 at 04:46:29PM -0800, Andy Lutomirski wrote:
> > So we'd do, in do_machine_check:
> >
> > irq_enter();
> >
> > do atomic stuff;
> >
> > ist_stop_being_atomic(regs);
> > local_irq_enable();
> > ...
> > local_irq_disable();
> > ist_start_being_atomic_again();
>
> Well, why would I want to go atomic again? We just do the minimally
> needed atomic stuff, irq_exit() and then do the rest.

Because ist_exit will get confused otherwise, and you still need to
call something on the way out for context tracking.

Yes, I could rearrange it a bit.  Will ponder.

--Andy

>
> >
> > irq_exit();
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
