Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3DYF6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:58:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45632 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3DYF6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:58:14 -0400
X-AuditID: 9c93016f-b7b70ae0000038d5-b8-5178c5f4d5ba
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/14] perf util: Use evsel->name to get tracepoint_paths
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-3-git-send-email-namhyung@kernel.org>
	<20130424124257.GE971@krava.brq.redhat.com>
Date: Thu, 25 Apr 2013 14:58:09 +0900
In-Reply-To: <20130424124257.GE971@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 24 Apr 2013 14:42:57 +0200")
Message-ID: <87k3nr9moe.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, 24 Apr 2013 14:42:57 +0200, Jiri Olsa wrote:
> On Tue, Apr 23, 2013 at 05:31:00PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Most tracepoint events already have their system and event name in
>> ->name field so that searching whole event tracing directory for each
>> evsel to match given id is suboptimal.
>> 
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/util/trace-event-info.c | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>> 
>> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
>> index ab18bf12d54a..dcfc1869c9af 100644
>> --- a/tools/perf/util/trace-event-info.c
>> +++ b/tools/perf/util/trace-event-info.c
>> @@ -414,12 +414,31 @@ get_tracepoints_path(struct list_head *pattrs)
>>  		if (pos->attr.type != PERF_TYPE_TRACEPOINT)
>>  			continue;
>>  		++nr_tracepoints;
>> +
>> +		if (pos->name && strchr(pos->name, ':')) {
>> +			char *str = strchr(pos->name, ':');
>> +
>> +			ppath->next = zalloc(sizeof(path));
>> +			if (!ppath->next)
>> +				goto error;
>> +
>> +			ppath->next->system = strndup(pos->name, str - pos->name);
>> +			ppath->next->name = strdup(str+1);
>> +
>> +			if (!ppath->next->system || !ppath->next->name)
>> +				goto error;
>> +
>> +			goto next;
>> +		}
>
> good idea, could you please move this ^^^ into function ?
> something like 'tracepoint_name_to_path'

Will do!

Thanks,
Namhyung
