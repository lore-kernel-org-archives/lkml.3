Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721Ab3LIH7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:59:13 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49540 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3LIH7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:59:12 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-3b-52a5784d5f57
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 2/3] perf tools: Record sampling time for each entry
References: <1386061229-19514-1-git-send-email-namhyung@kernel.org>
	<1386061229-19514-2-git-send-email-namhyung@kernel.org>
	<529E04C7.5090804@gmail.com>
Date: Mon, 09 Dec 2013 16:59:09 +0900
In-Reply-To: <529E04C7.5090804@gmail.com> (David Ahern's message of "Tue, 03
	Dec 2013 09:20:23 -0700")
Message-ID: <8738m2mp4i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 03 Dec 2013 09:20:23 -0700, David Ahern wrote:
> On 12/3/13, 2:00 AM, Namhyung Kim wrote:
>> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
>> index 20a7c653b74b..ac65fc67972c 100644
>> --- a/tools/perf/util/evsel.h
>> +++ b/tools/perf/util/evsel.h
>> @@ -69,6 +69,7 @@ struct perf_evsel {
>>   	struct hists		hists;
>>   	u64			first_timestamp;
>>   	u64			last_timestamp;
>> +	u64			*prev_timestamps;
>
>
> Why plural and why dynamically allocated? The allocation only does a
> single u64, not an array.

Nope, it'll be an array if the session was a system-wide one, so plural.

But, I think the current code won't work well if there're multiple
unrelated processes recorded - e.g. perf record -u `id -u` - since it'll
intermix all timestamps between the samples regardless of process.

Hmm.. I think there's not much thing we can do for this without help
from kernel side (PERF_SAMPLE_READ?).  So I'll just drop this unless I
can come up with a better idea.  But the patch 1/3 still makes some
sense and worth to merge by itself IMHO.

What do you think?

Thanks,
Namhyung
