Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaFEMCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:02:54 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:51990 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFEMCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:02:52 -0400
MIME-Version: 1.0
In-Reply-To: <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-10-git-send-email-eranian@google.com>
	<CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
	<CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
	<CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
	<CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
	<CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
Date: Thu, 5 Jun 2014 14:02:51 +0200
Message-ID: <CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Stephane Eranian <eranian@google.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 1:16 PM, Matt Fleming <matt@console-pimps.org> wrote:
> On 5 June 2014 11:19, Stephane Eranian <eranian@google.com> wrote:
>> How would you know that you have a uniform workload from inside
>> the kernel?
>
> That's what I'm asking you ;-)
>
No way to know this otherwise we could play some tricks.

>>> Does cpu_sibling_map not give you some indication of whether HT is
>>> enabled? I think the topology_thread_cpumask() is the topology API for
>>> that. But I could most definitely be wrong. Hopefully someone on the
>>> Cc list will know.
>>>
>> Remember trying some of that, but when perf_event is initialized, those
>> masks are not yet setup properly.
>
> Oh, bummer.
>
I think those should be initialized earlier on during booting.

> If there's no way to detect whether we should enable this workaround
> at runtime (and it sounds like there isn't a good way), then that's
> fair enough.
>
> We should think twice about allowing it to be disabled via sysfs,
> however. Because what is guaranteed to happen is that some user will
> report getting bogus results from perf for these events and we'll
> spend days trying to figure out why, only to discover they disabled
> the workaround and didn't tell us or didn't realise that they'd
> disabled it.
>
> If the workaround is low overhead, can't we just leave it enabled?

It is enabled by default. Nothing is done to try and disable it later
even once the kernel is fully booted. So this is mostly for testing
and power-users.
