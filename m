Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab3BLR0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:26:16 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:62964 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3BLR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:26:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130212172319.GB30387@tassilo.jf.intel.com>
References: <1360678168-6974-1-git-send-email-eranian@google.com>
	<20130212172319.GB30387@tassilo.jf.intel.com>
Date: Tue, 12 Feb 2013 18:26:12 +0100
Message-ID: <CABPqkBTZ+ooWHFvagR=YFDUdnnW9az0LXg1-etNfgC2Af8yA-w@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf stat: add per-core count aggregation
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 6:23 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Tue, Feb 12, 2013 at 03:09:26PM +0100, Stephane Eranian wrote:
>> This patch series contains improvement to the aggregation support
>> in perf stat.
>>
>> First, the aggregation code is refactored and a aggr_mode enum
>> is defined. There is also an important bug fix for the existing
>> per-socket aggregation.
>>
>> Second, the patch adds a new --aggr-core option to perf stat.
>
> Perhaps it's just me, but the option name is ugly (and sounds
> aggressive)
>
> --per-core perhaps?
>
I chose that name to be similar to ---aggr-socket.
But we could change both at this point.


> The idea itself is useful.
>
Yes, it is.

>> It aggregates counts per physical core and becomes useful on
>> systems with hyper-threading. The cores are presented per
>> socket: S0-C1, means socket 0 core 1. Note that the core number
>> represents its physical core id. As such, numbers may not always
>> be contiguous. All of this is based on topology information available
>> in sysfs.
>>
>> Per-core aggregation can be combined with interval printing:
>
> FWIW this would be much nicer if stat had a Kevents or Mevents mode.
> Usually we don't need all the digits.  But that could be added separately
>
> Does it work for multiple events in parallel?

Yes, it does. It's all regular perf stat.


>>
>>  # perf stat -a --aggr-core -I 1000 -e cycles sleep 100
>>  #           time core         cpus             counts events
>>       1.000101160 S0-C0           2      6,051,254,899 cycles
>>       1.000101160 S0-C1           2      6,379,230,776 cycles
>>       1.000101160 S0-C2           2      6,480,268,471 cycles
>>       1.000101160 S0-C3           2      6,110,514,321 cycles
>>       2.000663750 S0-C0           2      6,572,533,016 cycles
>>       2.000663750 S0-C1           2      6,378,623,674 cycles
>>       2.000663750 S0-C2           2      6,264,127,589 cycles
>>       2.000663750 S0-C3           2      6,305,346,613 cycles
>
> -Andi
