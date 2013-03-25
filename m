Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab3CYR6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:58:33 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:44650 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327Ab3CYR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:58:32 -0400
MIME-Version: 1.0
In-Reply-To: <1364210014.5053.2.camel@laptop>
References: <1363949499-3728-1-git-send-email-eranian@google.com>
	<1363949499-3728-2-git-send-email-eranian@google.com>
	<1364210014.5053.2.camel@laptop>
Date: Mon, 25 Mar 2013 18:58:31 +0100
Message-ID: <CABPqkBQ+6=3-cf+N+Dv=cD8GX6wxMKgdqHBRsXBtp=HMdwEdWQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] perf: use hrtimer for event multiplexing
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 12:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2013-03-22 at 11:51 +0100, Stephane Eranian wrote:
>> +#define PERF_CPU_HRTIMER (1000 / HZ)
>> +static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer
>> *hr)
>> +{
>> +       struct perf_cpu_context *cpuctx;
>> +       enum hrtimer_restart ret = HRTIMER_NORESTART;
>> +       unsigned long flags;
>> +       int rotations = 0;
>> +
>> +       cpuctx = container_of(hr, struct perf_cpu_context, hrtimer);
>> +
>> +       local_irq_save(flags);
>> +
>> +       rotations = perf_rotate_context(cpuctx);
>> +
>> +       local_irq_restore(flags);
>
> IIRC hrtimer callbacks are always ran with interrupts disabled.. not a
> big deal though. I'll continue reading.

I can create a V6 to remove this if necessary.
