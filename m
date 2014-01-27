Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaA0FbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:31:11 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53520 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaA0FbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:31:09 -0500
X-AuditID: 9c930179-b7c84ae000000e38-9a-52e5ef1b5a30
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/5] perf tools: Count filtered entries to total period also
References: <1390433333-15350-1-git-send-email-namhyung@kernel.org>
	<1390433333-15350-2-git-send-email-namhyung@kernel.org>
	<20140123132100.GA1180@krava.brq.redhat.com>
Date: Mon, 27 Jan 2014 14:31:07 +0900
In-Reply-To: <20140123132100.GA1180@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 23 Jan 2014 14:21:00 +0100")
Message-ID: <8738ka6les.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 14:21:00 +0100, Jiri Olsa wrote:
> On Thu, Jan 23, 2014 at 08:28:49AM +0900, Namhyung Kim wrote:
>> Currently if a sample was filtered by command line option, it just
>> dropped.  But this affects final output in that the percentage can be
>> different since the filtered entries were not included to the total.
>> 
>> But user might want to see the original percentages when filter
>> applied so change the behavior depends on a new symbol_conf.filter_
>> relative value in order to be controlled by user later.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> SNIP
>
>> +++ b/tools/perf/util/hist.h
>> @@ -14,6 +14,13 @@ struct hist_entry;
>>  struct addr_location;
>>  struct symbol;
>>  
>> +enum hist_filter {
>> +	HIST_FILTER__DSO,
>> +	HIST_FILTER__THREAD,
>> +	HIST_FILTER__PARENT,
>> +	HIST_FILTER__SYMBOL,
>> +};
>
> in thread__find_addr_map we still have:
> 		...
>                 if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
>                         cpumode == PERF_RECORD_MISC_GUEST_KERNEL) &&
>                         !perf_guest)
>                         al->filtered = true;
>                 if ((cpumode == PERF_RECORD_MISC_USER ||
>                         cpumode == PERF_RECORD_MISC_KERNEL) &&
>                         !perf_host)
>                         al->filtered = true;
> 		...
>
> seems like we need HIST_FILTER__GUEST|HOST
>
> also in machine__resolve_callchain_sample there's old (and superfluos) init:
> 		...
>                 al.filtered = false;
>                 thread__find_addr_location(thread, machine, cpumode,
>                                            MAP__FUNCTION, ip, &al);
> 		...

Both seems to need to be changed - will fix.

Thanks,
Namhyung
