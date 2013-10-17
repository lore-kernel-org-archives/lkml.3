Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762744Ab3JQUJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:09:51 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63309 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762318Ab3JQUJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <20131017090730.GK2675@laptop.programming.kicks-ass.net>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
	<20131010180049.GD9929@pd.tnic>
	<20131016124627.GA2611@gmail.com>
	<CABPqkBRQcisi8ukhD=6fKMq+iqwM+Qgxd3=jo82EUJB5coXs1A@mail.gmail.com>
	<20131016175302.GB4100@infradead.org>
	<CABPqkBSs1YwTiy_nkyXc89vg8-Tg=ONqCk930A+ksoLKsGLdHw@mail.gmail.com>
	<20131017081420.GB22705@gmail.com>
	<20131017090730.GK2675@laptop.programming.kicks-ass.net>
Date: Thu, 17 Oct 2013 22:09:48 +0200
Message-ID: <CABPqkBRHie1ojpipUyKaYz7k0GZ2qEDwSGunQW2rK6fzwmSSZQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Thu, Oct 17, 2013 at 11:07 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Oct 17, 2013 at 10:14:20AM +0200, Ingo Molnar wrote:
>> > > I.e. you would be encoding the counter unit as the suffix, might as well
>> > > call it "power/cores.joules" and use the dot as the separator for the
>> > > unit, but would be just a compact form to encode the counter->unit
>> > > table.
>> >
>> > May be easier to add a sysfs entry with the unit to display.
>>
>> Yes - with no entry meaning a raw 'count' or such.
>
> The downside to such a sysfs entry will be the scope. It would either be
> pmu wide (unwieldy for many PMUs) or be only per listed event; and we
> really don't want exhaustive event lists in the kernel.
>
Why not put in the events subdir:

/sys/devices/power/events/energy-cores
/sys/devices/power/events/energy-cores.unit
/sys/devices/power/events/energy-cores.scaling
$ cat energy-core.unit
Joules
$ cat energy-core.scaling
0.00000000023

Perf could easily lookup those files and if they are not present it will print
the event as it does today. If present, then it will print the unit and apply
the scaling factor to the raw cont (already scaled for multiplexing).

Borislav, the scaling factor cannot be hardcoded into perf because it
can change for processor to processor.
