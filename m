Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab3HSObd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:31:33 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60495 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3HSObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:31:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130819111616.GA1145@krava.brq.redhat.com>
References: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
	<1376411952-16718-2-git-send-email-jolsa@redhat.com>
	<20130815114040.GR24092@twins.programming.kicks-ass.net>
	<20130815135314.GE19750@two.firstfloor.org>
	<CABPqkBQAnj+tNBpQ+ebjTTe2Ht1__w9HzZnB15QGc+czCaYULg@mail.gmail.com>
	<20130819111616.GA1145@krava.brq.redhat.com>
Date: Mon, 19 Aug 2013 16:31:31 +0200
Message-ID: <CABPqkBSNv-=3+BCopb8KZC5ZdwKFERS2as4wJ-Yu0_cX-vUY3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf x86: Make intel_pmu_enable_all to enable only
 active events
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 19, 2013 at 1:16 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Aug 19, 2013 at 11:16:54AM +0200, Stephane Eranian wrote:
>> On Thu, Aug 15, 2013 at 3:53 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >>
>> >> I think its a NOP; this is the global ctrl register but
>> >> intel_pmu_disable_event() writes PERFEVTSELx.EN = 0, so even if you
>> >> enable it in the global mask, the event should still be disabled.
>> >
>> > Yes the hardware ANDs the various enable bits in the different
>> > registers.
>> >
>> Andi is correct. There is a logical AND between GLOBAL_CTRL and
>> the individual PERFEVTCTL.EN bits. If the EN bit is zero, then the
>> counter does not count. That also applies to fixed counters.
>
> right, peter mentioned I could have seen already queded
> NMI comming in for that event..
>
Yeah, I think you can have one NMI pending because it came
while you were already servicing an NMI interrupt. Though, this
is very unlikely.
