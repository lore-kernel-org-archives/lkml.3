Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab3GPWN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:13:58 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:34754 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3GPWNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:13:54 -0400
MIME-Version: 1.0
In-Reply-To: <51E5C31C.8000606@zytor.com>
References: <20130716183441.GA14232@www.outflux.net>
	<CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com>
	<CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com>
	<1374006818.6458.62.camel@gandalf.local.home>
	<CAGXu5jJNjHFJS0GfJVQm2++YtTn2yUfCAkf3u10REh=8DdeZCg@mail.gmail.com>
	<51E5C31C.8000606@zytor.com>
Date: Tue, 16 Jul 2013 15:13:54 -0700
X-Google-Sender-Auth: hXGWA6I9HT-93q6dToxm5CLzXr4
Message-ID: <CAE9FiQW-3H=rx-VewjMQjx2EOwcyDt351aQ0wnP8op6ZLViZag@mail.gmail.com>
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

On Tue, Jul 16, 2013 at 3:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/16/2013 01:47 PM, Kees Cook wrote:

>> The other IDTs don't need to be page aligned, but I marked them that
>> way in the clean up because it seemed sensible to define these tables
>> similarly. I can change the others to be __cacheline_aligned_bss if
>> that's desired.
>>
>
> I'm fine keeping them as page aligned.  They are page-sized on x86-64
> anyway (half page on i386).

ok, then should change

> +/* No need to be aligned, but done to keep all IDTs defined the same way. */
> +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_bss;

==>

> +/* Only need to be cacheline aligned, but keep all IDTs defined the same way to be page aligned. */
> +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_bss;
