Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab3BGHfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:35:43 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:58188 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3BGHfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:35:41 -0500
MIME-Version: 1.0
In-Reply-To: <87fw18svky.fsf@sejong.aot.lge.com>
References: <1360161962-9675-1-git-send-email-eranian@google.com>
	<87fw18svky.fsf@sejong.aot.lge.com>
Date: Thu, 7 Feb 2013 08:35:31 +0100
Message-ID: <CABPqkBTv0aZ1_MiFkQPAc=CyxBaHY7MMELfWL0Ni2syzLXOSrQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf stat: add per processor socket count aggregation
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 3:31 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Stephane,
>
> On Wed,  6 Feb 2013 15:46:00 +0100, Stephane Eranian wrote:
>> This patch adds per-processor socket count aggregation
>> for system-wide mode measurements. This is a useful
>> mode to detect imbalance between sockets for uniform
>> workloads.
>>
>> To enable this mode, use --aggr-socket in addition
>> to -a. (system-wide). This mode can be combined with
>> interval printing.
>>
>> The output includes the socket number and the number
>> of online processors on that socket. This is useful
>> to gauge the amount of aggregation.
>>
>>  # ./perf stat -I 1000 -a --aggr-socket -e cycles sleep 2
>>  #           time socket cpus             counts events
>>       1.000097680 S0        4          5,788,785 cycles
>>       2.000379943 S0        4         27,361,546 cycles
>>       2.001167808 S0        4            818,275 cycles
>
> Can it be genericized to support arbitrary cpu topology like per-core,
> per-numa-node or something?
>
Yes, we could. I think that could be useful too. I will look into
this. But please don't
ask for stupid scripting to do this. We need to keep things simple. I
think perf has
gotten to be a very complex tool, hard to read code, more difficult to maintain.

As for the particular feature, I know how to make it work on x86, but
it is not clear to me how portable is the sysfs topology tree? For instance,
on PPC, would that work? Worst case, we can make the topology routines
arch specific and use weak functions to cover any architecture which does
not have topology info.
