Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3JGQYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:24:22 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:35355 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3JGQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:24:19 -0400
MIME-Version: 1.0
In-Reply-To: <20131007161928.GC5517@pd.tnic>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
	<20131007161928.GC5517@pd.tnic>
Date: Mon, 7 Oct 2013 18:24:18 +0200
Message-ID: <CABPqkBShrCr0ycApxLFFhUCeu5=mFMw=w9HNPKd1FV7DNTN6Hw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 6:19 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Oct 07, 2013 at 06:09:15PM +0200, Stephane Eranian wrote:
>> The counters all count in the same unit. The perf_events API
>> exposes all RAPL counters as 64-bit integers counting in unit
>> of 1/2^32 Joules (or 0.23 nJ). User level tools must convert
>> the counts by multiplying them by 0.23 and divide 10^9 to
>> obtain Joules.  The reason for this is that the kernel avoids
>> doing floating point math whenever possible because it is
>> expensive (user floating-point state must be saved). The method
>> used avoids kernel floating-point and minimizes the loss of
>> precision (bits). Thanks to PeterZ for suggesting this approach.
>>
>> To convert the raw count in Watt: W = C * 0.23 / (1e9 * time)
>
> ...
>
>> $ perf stat -a -e rapl/rapl-energy-cores/,rapl/rapl-energy-pkg/ -I 1000 sleep 10
>>             time             counts events
>>      1.000345931        772 278 493 rapl/rapl-energy-cores/
>>      1.000345931     55 539 138 560 rapl/rapl-energy-pkg/
>>      2.000836387        771 751 936 rapl/rapl-energy-cores/
>>      2.000836387     55 326 015 488 rapl/rapl-energy-pkg/
>
> So can we do the Watt conversion in perf tool and make that "counts"
> output more human-friendly like what those numbers are, to which
> core/LLC they belong, etc, etc?
>
We could but that means we would need to special case the events in perf.
I was trying to avoid that.

> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
