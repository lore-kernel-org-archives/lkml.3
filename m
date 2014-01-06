Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaAFIej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:34:39 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42382 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaAFIei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:34:38 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-e4-52ca6a9dd673
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 18/21] perf top: Support callchain accumulation
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-19-git-send-email-namhyung@kernel.org>
	<20140105180154.GM10018@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 17:34:37 +0900
In-Reply-To: <20140105180154.GM10018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Sun, 5 Jan 2014 19:01:54 +0100")
Message-ID: <87txdhcxuq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 19:01:54 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:24PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Enable cumulation of callchain of children in perf top.
>> 
>> Cc: Arun Sharma <asharma@fb.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/builtin-top.c | 106 +++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 103 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index 48c527a0f4c8..6a7a76496c94 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -657,6 +657,99 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
>>  	return 0;
>>  }
>>  
>> +static int process_cumulative_entry(struct perf_top *top,
>> +				    struct hist_entry *he,
>> +				    struct perf_evsel *evsel,
>> +				    struct addr_location *al,
>> +				    struct perf_sample *sample,
>> +				    struct symbol *parent)
>> +{
>
> hum, I wonder how hard would it be to export the iterator
> stuff out of the report command and export it to be usable
> from here as well.. to much code dusplicated below :-\

Yeah, I should find a way to reuse the code.

Thanks,
Namhyung
