Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaBXHth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:49:37 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46143 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaBXHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:49:36 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-f4-530af98e9358
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 7/8] perf ui/tui: Add 'F' hotkey to toggle percentage output
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
	<1392000446-14744-9-git-send-email-namhyung@kernel.org>
	<20140220105402.GE11018@krava.brq.redhat.com>
Date: Mon, 24 Feb 2014 16:49:34 +0900
In-Reply-To: <20140220105402.GE11018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 20 Feb 2014 11:54:02 +0100")
Message-ID: <8761o5vtkh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 11:54:02 +0100, Jiri Olsa wrote:
> On Mon, Feb 10, 2014 at 11:47:25AM +0900, Namhyung Kim wrote:
>> Add 'F' hotkey to toggle relative and absolute percentage of filtered
>> entries.
>> 
>> Suggested-by: Jiri Olsa <jolsa@redhat.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/ui/browsers/hists.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
>> index 14ba6d524943..681c484c5c8e 100644
>> --- a/tools/perf/ui/browsers/hists.c
>> +++ b/tools/perf/ui/browsers/hists.c
>> @@ -1447,6 +1447,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>>  	"C             Collapse all callchains\n"			\
>>  	"d             Zoom into current DSO\n"				\
>>  	"E             Expand all callchains\n"				\
>> +	"F             Toggle percentage of filtered entries\n"		\
>>  
>>  	/* help messages are sorted by lexical order of the hotkey */
>>  	const char report_help[] = HIST_BROWSER_HELP_COMMON
>> @@ -1552,6 +1553,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>>  			if (env->arch)
>>  				tui__header_window(env);
>>  			continue;
>> +		case 'F':
>> +			symbol_conf.filter_relative ^= 1;
>> +			continue;
>>  		case K_F1:
>>  		case 'h':
>>  		case '?':
>> -- 
>> 1.7.11.7
>> 
>
> when in relative mode i get 0 samples count
> also in --stdio:
>
> [jolsa@krava perf]$ ./perf report -s symbol --symbols=system_call,vfs_write --stdio --percentage=relative
> Failed to open /tmp/perf-1063.map, continuing without symbols
> # To display the perf.data header info, please use --header/--header-only options.
> #
> # Samples: 0  of event 'cycles'
> # Event count (approx.): 6046797
> #
> # Overhead           Symbol
> # ........  ...............
> #
>     57.05%  [k] system_call
>     42.95%  [k] vfs_write  

Oops, I found that I missed to increase it when adding hist
entries.. will fix.

Thanks,
Namhyung
