Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903AbaKPUmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:42:07 -0500
Received: from mailsec118.isp.belgacom.be ([195.238.20.114]:21349 "EHLO
	mailsec118.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbaKPUmF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:42:05 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=IWjTSwFp5QM033bvc92RfzEeQuXC3aWfw/K7N4S/aa4= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=Z4Rwk6OoAAAA:8 a=-GKNRN7d8TklkOJGITcA:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoIMAHQLaVTD7hTU/2dsb2JhbAAZAUGDDoEugwa1RwabCgKBCRYBAQEBAX2EAgEBAQMBI1YFCwUEAhgCAhgOAgJXBhMRiCcNnTBGnHGHAo5GAQEIAgEfgS2FEYoxMweCd4FUBZIdjWOHCo48g308MIJLAQEB
Date: Sun, 16 Nov 2014 21:42:03 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Message-ID: <2103975015.146682.1416170523484.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <CA+55aFwq2gash0+scfR_aefxyGfHeNT4CgNopgVMO-RA7dkiLQ@mail.gmail.com>
References: <393289076.116745.1416126792518.open-xchange@webmail.nmp.skynet.be> <CA+55aFwq2gash0+scfR_aefxyGfHeNT4CgNopgVMO-RA7dkiLQ@mail.gmail.com>
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



> On 16 November 2014 at 21:03 Linus Torvalds <torvalds@linux-foundation.org>
> wrote:
>
>
> On Sun, Nov 16, 2014 at 12:33 AM, Fabian Frederick <fabf@skynet.be> wrote:
> >
> >         Have you tried reverting the following patches (all from rc1) ?
>
> Hmm. Any particular reason you're looking at those?
>
> >         c6f4459 v3.18-rc1 smp: Add new wake_up_all_idle_cpus() function
> >         bb964a9 v3.18-rc1 kernel misc: Replace __get_cpu_var uses
> >         2ed903c v3.18-rc1 cpuidle: Use wake_up_all_idle_cpus() to wake up
> >all idle cpus
>
> It does strike me that the reschedule IPI is somewhat special in that
> we don't try to serialize it at all, on the grounds that a lost IPI is
> ok (ie smp_send_reschedule() is very much a special case of IPI). Or
> am I mis-remembering? Does that series end up adding a lot more of
> those things, rather than using the normal smp_call_function().
>
> The normal smp_function_mask() thing tries to make sure only one entry
> is ever active at a time (even a non-blocking one will use the whole
> "queue it on a llist, only send the IPI if the llist was empty", so
> this is not about the IPI's being synchronous).  The rescheduling
> thing is rather special, isn't it.
>
> The softlockup thing *did* look like some IPI got lost. Could an IPI
> overflow on the RESCHEDULE_VECTOR end up affecting other vectors? It's
> been too long since I worked with the APIC (and by "too long", I
> obviously mean "thank God I haven't had to" ;^) but there used to be
> grouping of the vectors..
>
> Maybe that is all barking up the wrong tree, but I'm wondering why
> Fabian picked that particular set of commits. Fabian?

Thomas talked about csd_lock and the last reliable stack function
being smp_call_function_single, I thought it could be interesting
to bisect directly in smp.c as I only read about reverting mm/memory.c
stuff ... Maybe not too much original but who knows ? :)
 
Regards,
Fabian

>
>                      Linus
