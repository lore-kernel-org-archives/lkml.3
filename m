Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaEPGXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:23:50 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56511 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaEPGXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:23:48 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 06/20] perf tools: Consolidate output field handling to hpp format routines
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
	<1399876133-17963-7-git-send-email-namhyung@kernel.org>
	<20140515120703.GA25858@krava.brq.redhat.com>
Date: Fri, 16 May 2014 15:23:36 +0900
In-Reply-To: <20140515120703.GA25858@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 15 May 2014 14:07:04 +0200")
Message-ID: <87iop6kzrr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 14:07:04 +0200, Jiri Olsa wrote:
> On Mon, May 12, 2014 at 03:28:39PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> -		}
>> -
>>  		if (symbol_conf.use_callchain && sort__has_sym) {
>>  			if (callchain_param.mode == CHAIN_GRAPH_REL)
>>  				total = h->stat.period;
>> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
>> index c65a7fd744c6..32d2dfd794d9 100644
>> --- a/tools/perf/ui/hist.c
>> +++ b/tools/perf/ui/hist.c
>> @@ -352,8 +352,18 @@ LIST_HEAD(perf_hpp__sort_list);
>>  #undef __HPP_ENTRY_RAW_FN
>>  
>>  
>> +void perf_hpp__setup_output_field(void);
>
> should go to util/hist.h

Okay.

>
>>  {
>> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
>> index 9eccf7f4f367..e6920d124c60 100644
>> --- a/tools/perf/ui/stdio/hist.c
>> +++ b/tools/perf/ui/stdio/hist.c
>> @@ -353,8 +353,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
>>  	if (size == 0 || size > bfsz)
>>  		size = hpp.size = bfsz;
>>  
>> -	ret = hist_entry__period_snprintf(&hpp, he);
>> -	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
>> +	hist_entry__period_snprintf(&hpp, he);
>
> so it's no longer just period.. should we rename it? like
>   hist_entry__hpp_snprintf
>   hist_entry__snprintf

The hist_entry__snprintf() looks better to me.

Thanks,
Namhyung
