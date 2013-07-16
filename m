Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab3GPXje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:39:34 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41841 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab3GPXjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:39:33 -0400
MIME-Version: 1.0
In-Reply-To: <51E5C65A.9010605@zytor.com>
References: <20130716183441.GA14232@www.outflux.net>
	<CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com>
	<CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com>
	<1374006818.6458.62.camel@gandalf.local.home>
	<CAGXu5jJNjHFJS0GfJVQm2++YtTn2yUfCAkf3u10REh=8DdeZCg@mail.gmail.com>
	<51E5C31C.8000606@zytor.com>
	<CAE9FiQW-3H=rx-VewjMQjx2EOwcyDt351aQ0wnP8op6ZLViZag@mail.gmail.com>
	<51E5C65A.9010605@zytor.com>
Date: Tue, 16 Jul 2013 16:39:32 -0700
X-Google-Sender-Auth: dLdwKsbYh13NChU8FUsvTyCvbqY
Message-ID: <CAE9FiQVMQyhy57MhrkCH7TYqhwgb5tHFjSxhCh8KcN+DNuXE4Q@mail.gmail.com>
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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

On Tue, Jul 16, 2013 at 3:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/16/2013 03:13 PM, Yinghai Lu wrote:
>>
>> ok, then should change
>>
>>> +/* No need to be aligned, but done to keep all IDTs defined the same way. */
>>> +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_bss;
>>
>> ==>
>>
>>> +/* Only need to be cacheline aligned, but keep all IDTs defined the same way to be page aligned. */
>>> +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_bss;
>
> It doesn't need to be cacheline aligned, either, to the best of my
> knowledge.  The former comment is more correct.

ok. so the old code is just for optimization to keep it cacheline aligned?
