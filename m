Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbbAVMjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:39:19 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59559 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbAVMjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:39:16 -0500
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20150122101720.GA2896@worktop.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1501211348470.22707@vincent-weaver-1.umelst.maine.edu>
	<CAMsRxfJVxUcTvpaUSvTY19Ha93J1R-=o97hO+bfgkL3zU7Nrpw@mail.gmail.com>
	<20150122101720.GA2896@worktop.programming.kicks-ass.net>
Date: Thu, 22 Jan 2015 04:39:16 -0800
Message-ID: <CAMsRxfKnDVxc4awnGPQ+7s1BvsUHDQV5GwDRmV2J9BGKP2EMXg@mail.gmail.com>
Subject: Re: perf: easily crash kernel with rapl event close
From: Stephane Eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 2:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jan 21, 2015 at 09:13:11PM -0800, Stephane Eranian wrote:
>> Vince,
>>
>> On Wed, Jan 21, 2015 at 10:55 AM, Vince Weaver <vincent.weaver@maine.edu> wrote:
>> > Hello
>> >
>> > on my haswell system, running 3.19-rc5, and with
>> >         echo "0" > /proc/sys/kernel/perf_event_paranoid
>> >
>> > I can easily crash my system with the attached test program that simply
>> > opens a RAPL event and then closes it.
>> >
>> > This bug was found by the perf_fuzzer.
>> >
>> > It looks like somehow rapl_pmu gets freed to NULL but the
>> > call in rapl_scale()
>> >         __this_cpu_read(rapl_pmu->hw_unit)
>> > still happens.
>> >
>> I don't see how this can happen.
>>
>> I get some crashes but not with your program on my laptop.
>> But I cannot catch the serial console from my laptop.
>> Will try with another machine tomorrow.
>
> I saw it today as well on an ivb-ep. I disabled rapl for now since I'm
> chasing other things.

I will fix that today.
