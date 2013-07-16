Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796Ab3GPWDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:03:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59683 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597Ab3GPWDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:03:49 -0400
Message-ID: <51E5C31C.8000606@zytor.com>
Date: Tue, 16 Jul 2013 15:03:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
References: <20130716183441.GA14232@www.outflux.net> <CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com> <CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com> <1374006818.6458.62.camel@gandalf.local.home> <CAGXu5jJNjHFJS0GfJVQm2++YtTn2yUfCAkf3u10REh=8DdeZCg@mail.gmail.com>
In-Reply-To: <CAGXu5jJNjHFJS0GfJVQm2++YtTn2yUfCAkf3u10REh=8DdeZCg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 01:47 PM, Kees Cook wrote:
> On Tue, Jul 16, 2013 at 1:33 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Tue, 2013-07-16 at 13:28 -0700, Kees Cook wrote:
>>> On Tue, Jul 16, 2013 at 1:21 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> On Tue, Jul 16, 2013 at 11:34 AM, Kees Cook <keescook@chromium.org> wrote:
>>>>> Since the IDT is referenced from a fixmap, make sure it is page aligned.
>>>>> Merge with 32-bit one, since it was already aligned to deal with F00F
>>>>> bug. Since bss is cleared before IDT setup, it can live there. This also
>>>>> moves the other *_idt_table variables into common locations.
>>>>>
>>
>>> It seemed more correct to me to define all the IDTs the same, but
>>> there was no technical reason for that, just one of regularity. I only
>>> care about keeping the real IDT page aligned. :) I'm fine to do
>>> whatever is deemed "correct". :)
>>
>> I'm actually unfamiliar with the F00F bug (heard of it, but have no idea
>> what it is). What happens if the F00F bug exists and we switch to an IDT
>> that's not paged aligned? Is that an issue?
> 
> Regardless of F00F, the IDT is now unconditionally being set up in a
> fixmap entry (so that the unprivileged "sidt" instruction won't leak a
> "real" kernel address, and so that this exposed address is read-only).
> If the real IDT is not page aligned, the fixmap IDT will appear offset
> and everything starts calling the wrong handlers.
> 
> The other IDTs don't need to be page aligned, but I marked them that
> way in the clean up because it seemed sensible to define these tables
> similarly. I can change the others to be __cacheline_aligned_bss if
> that's desired.
> 

I'm fine keeping them as page aligned.  They are page-sized on x86-64
anyway (half page on i386).

	-hpa


