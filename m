Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaFENQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:16:50 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:57833 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaFENQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140605125929.GH6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-10-git-send-email-eranian@google.com>
	<CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
	<CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
	<CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
	<CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
	<CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
	<20140605125022.GF6758@twins.programming.kicks-ass.net>
	<CABPqkBQMi5NoL1EFB8ajopF8QbF3kiFgk6NkSkaqzruVaEQJOQ@mail.gmail.com>
	<20140605125929.GH6758@twins.programming.kicks-ass.net>
Date: Thu, 5 Jun 2014 15:16:47 +0200
Message-ID: <CABPqkBQq1ifgVEK-kdnyMRz5bmMPgfkoZ7VyP=2U37cUUDMvog@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 2:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jun 05, 2014 at 02:55:05PM +0200, Stephane Eranian wrote:
>> On Thu, Jun 5, 2014 at 2:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, Jun 05, 2014 at 12:16:01PM +0100, Matt Fleming wrote:
>> >> On 5 June 2014 11:19, Stephane Eranian <eranian@google.com> wrote:
>> >> > How would you know that you have a uniform workload from inside
>> >> > the kernel?
>> >>
>> >> That's what I'm asking you ;-)
>> >>
>> >> >> Does cpu_sibling_map not give you some indication of whether HT is
>> >> >> enabled? I think the topology_thread_cpumask() is the topology API for
>> >> >> that. But I could most definitely be wrong. Hopefully someone on the
>> >> >> Cc list will know.
>> >> >>
>> >> > Remember trying some of that, but when perf_event is initialized, those
>> >> > masks are not yet setup properly.
>> >>
>> >> Oh, bummer.
>> >
>> > So we init perf very early to get nmi-watchdog up and running, but
>> > there's no reason you cannot register a second initcall later and flip
>> > the switch from it there.
>>
>> and what initcall would that be?
>
> Pretty much anything !early_initcall() is ran after SMP bringup iirc.

Ok, we can try this. Need to check the impact on NMI watchdog if
already active.
