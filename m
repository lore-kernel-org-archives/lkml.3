Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaJUNIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:08:34 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33403 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaJUNId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <20141021130320.GE12706@worktop.programming.kicks-ass.net>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
	<20141021112501.GY23531@worktop.programming.kicks-ass.net>
	<CABPqkBTDz56a9Hoy04W6VmTG_FTOE72037D0tmnh+ntw+VW0ZQ@mail.gmail.com>
	<20141021130320.GE12706@worktop.programming.kicks-ass.net>
Date: Tue, 21 Oct 2014 15:08:32 +0200
Message-ID: <CABPqkBQuf_W1X_VbVzLhKbv6AZwKE3YyHGpT=cRFNBEak5wz_Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/12] perf/x86: implement HT leak workaround for SNB/IVB/HSW
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Liang, Kan" <kan.liang@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 3:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Oct 21, 2014 at 02:28:06PM +0200, Stephane Eranian wrote:
>> Peter,
>>
>> On Tue, Oct 21, 2014 at 1:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> >
>> > lkml.kernel.org/r/CABPqkBRbst4sgpgE5O_VXt-CSC0VD=aP2KWA0e3Uy64tw7df3A@mail.gmail.com
>> >
>> > I missed that 3 lines if they were in here.
>> >
>> I did not put them in there because there is another problem.
>> If you partition the generic counters 2 and 2, then some CPUs will not
>> be able to measure some events.
>> Unfortunately, there is no way to partition the 4 counters such that
>> all the events can be measured by
>> each CPU. Some events or precise sampling requires counter 2 for
>> instance (like prec_dist).
>> That's why I did not put this fix in.
>
> Ah, I wasn't thinking about a hard partition, just a limit on the number
> of exclusive counters any one CPU can claim such as to not starve. Or is
> that what you were talking about? I feel not being able to starve
> another CPU is more important than a better utilization bound for
> counter scheduling.

So you're saying, just limit number of used counters to 2 regardless
of which one
they are. So sometimes, this will avoid the problem aforementioned and sometimes
not. We can try that.
