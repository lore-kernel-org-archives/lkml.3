Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab3GPUrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:47:52 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59188 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933670Ab3GPUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:47:51 -0400
MIME-Version: 1.0
In-Reply-To: <1374006818.6458.62.camel@gandalf.local.home>
References: <20130716183441.GA14232@www.outflux.net>
	<CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com>
	<CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com>
	<1374006818.6458.62.camel@gandalf.local.home>
Date: Tue, 16 Jul 2013 13:47:50 -0700
X-Google-Sender-Auth: RUGoALxsYRM4dsEE9NitXoLXpvA
Message-ID: <CAGXu5jJNjHFJS0GfJVQm2++YtTn2yUfCAkf3u10REh=8DdeZCg@mail.gmail.com>
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
From: Kees Cook <keescook@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 1:33 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2013-07-16 at 13:28 -0700, Kees Cook wrote:
>> On Tue, Jul 16, 2013 at 1:21 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Tue, Jul 16, 2013 at 11:34 AM, Kees Cook <keescook@chromium.org> wrote:
>> >> Since the IDT is referenced from a fixmap, make sure it is page aligned.
>> >> Merge with 32-bit one, since it was already aligned to deal with F00F
>> >> bug. Since bss is cleared before IDT setup, it can live there. This also
>> >> moves the other *_idt_table variables into common locations.
>> >>
>
>> It seemed more correct to me to define all the IDTs the same, but
>> there was no technical reason for that, just one of regularity. I only
>> care about keeping the real IDT page aligned. :) I'm fine to do
>> whatever is deemed "correct". :)
>
> I'm actually unfamiliar with the F00F bug (heard of it, but have no idea
> what it is). What happens if the F00F bug exists and we switch to an IDT
> that's not paged aligned? Is that an issue?

Regardless of F00F, the IDT is now unconditionally being set up in a
fixmap entry (so that the unprivileged "sidt" instruction won't leak a
"real" kernel address, and so that this exposed address is read-only).
If the real IDT is not page aligned, the fixmap IDT will appear offset
and everything starts calling the wrong handlers.

The other IDTs don't need to be page aligned, but I marked them that
way in the clean up because it seemed sensible to define these tables
similarly. I can change the others to be __cacheline_aligned_bss if
that's desired.

-Kees

--
Kees Cook
Chrome OS Security
