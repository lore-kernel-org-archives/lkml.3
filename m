Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaKQAf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:35:59 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41522 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaKQAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:35:57 -0500
MIME-Version: 1.0
In-Reply-To: <2103975015.146682.1416170523484.open-xchange@webmail.nmp.skynet.be>
References: <393289076.116745.1416126792518.open-xchange@webmail.nmp.skynet.be>
	<CA+55aFwq2gash0+scfR_aefxyGfHeNT4CgNopgVMO-RA7dkiLQ@mail.gmail.com>
	<2103975015.146682.1416170523484.open-xchange@webmail.nmp.skynet.be>
Date: Sun, 16 Nov 2014 16:35:56 -0800
X-Google-Sender-Auth: wwRW4JU935kEIzEfdM4DSiq-1aY
Message-ID: <CA+55aFyj4pA6hmCrsCNgzR47mt4Ayh+xqueQwcX_WOWvtBguYQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4: revert suggestion
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 12:42 PM, Fabian Frederick <fabf@skynet.be> wrote:
>
> Thomas talked about csd_lock and the last reliable stack function
> being smp_call_function_single, I thought it could be interesting
> to bisect directly in smp.c as I only read about reverting mm/memory.c
> stuff ... Maybe not too much original but who knows ? :)

Fair enough.

I'd be almost have been more inclined to look at the apic changes,
like commit 4ba2968420fa ("percpu: Resolve ambiguities in
__get_cpu_var/cpumask_var_t") that was horribly buggy. It was fixed in
59f6e2073c72, though, and the end result looks sane, so I don't think
it's that particular thing. The rest seems to be either kvm-related or
just clearly trivial.

Which is why I think even a partial bisection would be nice - as it is
we're kind of just guessing, and I'm not all the confident in the
guesses. Sure, they may be right, but bisection is guaranteed to at
least narrow the suspects down, while guesses *could* hit jack-pot,
but could also be a total waste of time.

I guess I'm not much of a gambler. I'll take a steady slow guarantee
of progress over a jackpot just about every day.

                       Linus
