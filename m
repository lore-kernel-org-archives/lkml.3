Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab3LLBRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:17:55 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43775 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3LLBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:17:52 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBTufgMk=iqXM87+psUeLd865QF9tCEVHT6hwT4=TtetfQ@mail.gmail.com>
References: <1386376451-24593-1-git-send-email-sonnyrao@chromium.org>
 <20131209074933.GA2922@jtriplet-mobl1> <CABPqkBTufgMk=iqXM87+psUeLd865QF9tCEVHT6hwT4=TtetfQ@mail.gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 11 Dec 2013 17:17:30 -0800
X-Google-Sender-Auth: wZX_Pptpg7bBbjJZBjjm7yfWGqU
Message-ID: <CAPz6YkU6-ccJ8eJwYUgs_Gjo5rYeSh3ftSgd_MzCXRTyzhPiiQ@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: char: Add a dynamic clock for the trace clock
To: Stephane Eranian <eranian@google.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Olof Johansson <olof@lixom.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, pawel.moll@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 11:30 AM, Stephane Eranian <eranian@google.com> wrote:
> Sonny,
>
> Your patch has a couple of problems for me:
>  - requires CONFIG_TRACING
>
> You should directly invoke getrawmonotonic()
>  and inline the code from trace_clock_getres().
>
> That's how I managed to compile your kernel module on my system.

You need the changes in kernel/trace/trace.c which is why it's
dependent on CONFIG_TRACING.
If we put those functions elsewhere we could remove that dependency,
but it sounds like people want to just fix the clock that perf uses so
that it's exportable and not handle this with something like this
patch, which is better.

Also, we should ensure that perf and ftrace are guaranteed to use the
same clock, I think it just happens to be the same right now.

>
>
> On Mon, Dec 9, 2013 at 8:49 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>> On Fri, Dec 06, 2013 at 04:34:11PM -0800, Sonny Rao wrote:
>>> Based on a suggestion from John Stultz.
>>>
>>> This adds a dynamic clock device which can be used with clock_gettime
>>> to sample the clock source used for time stamping trace events in the
>>> kernel.  The only use for this clock source is to associate user space
>>> events with kernel events on a given kernel.  It is explicitly not
>>> supposed to be used as a generic time source and won't necessarily be
>>> consistent between kernels.
>>>
>>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>>
>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
