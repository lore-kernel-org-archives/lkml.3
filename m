Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab3GPUdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:33:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5833 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab3GPUdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:33:46 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=rTyptnn7BogA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RMKxM6tspQQA:10 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8 a=_6Ub_wPkdrvKiN6t9agA:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=zv9_9hqRWm8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374006818.6458.62.camel@gandalf.local.home>
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
From: Steven Rostedt <rostedt@goodmis.org>
To: Kees Cook <keescook@chromium.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Date: Tue, 16 Jul 2013 16:33:38 -0400
In-Reply-To: <CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com>
References: <20130716183441.GA14232@www.outflux.net>
	 <CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com>
	 <CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 13:28 -0700, Kees Cook wrote:
> On Tue, Jul 16, 2013 at 1:21 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Tue, Jul 16, 2013 at 11:34 AM, Kees Cook <keescook@chromium.org> wrote:
> >> Since the IDT is referenced from a fixmap, make sure it is page aligned.
> >> Merge with 32-bit one, since it was already aligned to deal with F00F
> >> bug. Since bss is cleared before IDT setup, it can live there. This also
> >> moves the other *_idt_table variables into common locations.
> >>

> It seemed more correct to me to define all the IDTs the same, but
> there was no technical reason for that, just one of regularity. I only
> care about keeping the real IDT page aligned. :) I'm fine to do
> whatever is deemed "correct". :)

I'm actually unfamiliar with the F00F bug (heard of it, but have no idea
what it is). What happens if the F00F bug exists and we switch to an IDT
that's not paged aligned? Is that an issue?

-- Steve


