Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaJWI6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:58:03 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:38593 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaJWI56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:57:58 -0400
MIME-Version: 1.0
In-Reply-To: <20141023085310.GN21513@worktop.programming.kicks-ass.net>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
	<20141021112501.GY23531@worktop.programming.kicks-ass.net>
	<CABPqkBTDz56a9Hoy04W6VmTG_FTOE72037D0tmnh+ntw+VW0ZQ@mail.gmail.com>
	<20141021130320.GE12706@worktop.programming.kicks-ass.net>
	<CABPqkBQuf_W1X_VbVzLhKbv6AZwKE3YyHGpT=cRFNBEak5wz_Q@mail.gmail.com>
	<20141022091239.GG12706@worktop.programming.kicks-ass.net>
	<CABPqkBQSSsSFMfq=Wb7pZZD_gjCvqh4mTt88FL3Eq-fgduEriQ@mail.gmail.com>
	<20141023085310.GN21513@worktop.programming.kicks-ass.net>
Date: Thu, 23 Oct 2014 10:57:57 +0200
Message-ID: <CABPqkBTQ2JLakE3yfS7RzX7dy15O9FFG0H8dhwPC-XOxUTbtcg@mail.gmail.com>
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

On Thu, Oct 23, 2014 at 10:53 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Oct 22, 2014 at 11:04:31PM +0200, Stephane Eranian wrote:
>> Here is a simple case:
>> Limiting each HT to only 2 counters, can be any, 2 out of 4 possible.
>>
>> HT0: you measure a MEM* in ctr2, it is started first, and it keeps running
>> HT1: you measure PREC_DIST with PEBS (it requires ctr2)
>>
>> HT0 is measuring a corrupting event on ctr2, this prevents ctr2 on HT1
>> from being used.
>> HT1 is starved, it cannot measure PREC_DIST
>>
>> Yes you have a quota of 2 out of 4 counters.
>>
>> The quota dynamic or static can help mitigate the starvation. The only
>> way to eliminate
>> it is to force multiplexing even though you are using fewer counters
>> than actually avail.
>
> Ah yes, the very narrowly constrained events. Those suck indeed. And I
> imagine rotation might not even help here -- rotation doesn't guarantee
> SMT1 will try and schedule before SMT0, in fact there are setups
> (staggered tick) where its almost guaranteed not to.
>
> Still I suppose for 'normal' event its a much better state, SMT1 can
> always schedule some events.

Yes, I agree with you. The soft partition helps. I will add that in V3.
Thanks.
