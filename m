Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaKQGEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:04:11 -0500
Received: from mailsec118.isp.belgacom.be ([195.238.20.114]:46690 "EHLO
	mailsec118.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbaKQGEJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:04:09 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=IWjTSwFp5QM033bvc92RfzEeQuXC3aWfw/K7N4S/aa4= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=Z4Rwk6OoAAAA:8 a=O4TCXyt8H8cDE_SnhCoA:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoIMADGPaVTD7hTU/2dsb2JhbAAZAUGDDoEugwa1QQabCgKBFRYBAQEBAX2EAgEBAQMBI1YFCwUEAhgCAhgOAgJXBhMRiCcNnUlLnHGHAo5YAQsggS2FEYoxMweCd4FUBZIdjWOHCo48g308MIJLAQEB
Date: Mon, 17 Nov 2014 07:04:08 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Message-ID: <470730419.148617.1416204248375.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <CA+55aFyj4pA6hmCrsCNgzR47mt4Ayh+xqueQwcX_WOWvtBguYQ@mail.gmail.com>
References: <393289076.116745.1416126792518.open-xchange@webmail.nmp.skynet.be> <CA+55aFwq2gash0+scfR_aefxyGfHeNT4CgNopgVMO-RA7dkiLQ@mail.gmail.com> <2103975015.146682.1416170523484.open-xchange@webmail.nmp.skynet.be> <CA+55aFyj4pA6hmCrsCNgzR47mt4Ayh+xqueQwcX_WOWvtBguYQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4: revert suggestion
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 17 November 2014 at 01:35 Linus Torvalds <torvalds@linux-foundation.org>
> wrote:
>
>
> On Sun, Nov 16, 2014 at 12:42 PM, Fabian Frederick <fabf@skynet.be> wrote:
> >
> > Thomas talked about csd_lock and the last reliable stack function
> > being smp_call_function_single, I thought it could be interesting
> > to bisect directly in smp.c as I only read about reverting mm/memory.c
> > stuff ... Maybe not too much original but who knows ? :)
>
> Fair enough.
>
> I'd be almost have been more inclined to look at the apic changes,
> like commit 4ba2968420fa ("percpu: Resolve ambiguities in
> __get_cpu_var/cpumask_var_t") that was horribly buggy. It was fixed in
> 59f6e2073c72, though, and the end result looks sane, so I don't think
> it's that particular thing. The rest seems to be either kvm-related or
> just clearly trivial.
>
> Which is why I think even a partial bisection would be nice - as it is
> we're kind of just guessing, and I'm not all the confident in the
> guesses. Sure, they may be right, but bisection is guaranteed to at
> least narrow the suspects down, while guesses *could* hit jack-pot,
> but could also be a total waste of time.
>
> I guess I'm not much of a gambler. I'll take a steady slow guarantee
> of progress over a jackpot just about every day.
>
>                        Linus

Ok Linus, you're not a gambler but honestly, you created
Git and Linux: the best games I know about on earth ;)

Regards,
Fabian
