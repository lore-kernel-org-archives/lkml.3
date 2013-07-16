Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044Ab3GPUo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:44:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59008 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933910Ab3GPUoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:44:25 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1374006818.6458.62.camel@gandalf.local.home>
References: <20130716183441.GA14232@www.outflux.net> <CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com> <CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com> <1374006818.6458.62.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 16 Jul 2013 13:43:26 -0700
To: Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Message-ID: <20c92485-49b5-438e-9786-9e7a2ac95788@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The F00F big just means the IDT must be readonly.

Steven Rostedt <rostedt@goodmis.org> wrote:

>On Tue, 2013-07-16 at 13:28 -0700, Kees Cook wrote:
>> On Tue, Jul 16, 2013 at 1:21 PM, Yinghai Lu <yinghai@kernel.org>
>wrote:
>> > On Tue, Jul 16, 2013 at 11:34 AM, Kees Cook <keescook@chromium.org>
>wrote:
>> >> Since the IDT is referenced from a fixmap, make sure it is page
>aligned.
>> >> Merge with 32-bit one, since it was already aligned to deal with
>F00F
>> >> bug. Since bss is cleared before IDT setup, it can live there.
>This also
>> >> moves the other *_idt_table variables into common locations.
>> >>
>
>> It seemed more correct to me to define all the IDTs the same, but
>> there was no technical reason for that, just one of regularity. I
>only
>> care about keeping the real IDT page aligned. :) I'm fine to do
>> whatever is deemed "correct". :)
>
>I'm actually unfamiliar with the F00F bug (heard of it, but have no
>idea
>what it is). What happens if the F00F bug exists and we switch to an
>IDT
>that's not paged aligned? Is that an issue?
>
>-- Steve

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
