Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaAMItF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:49:05 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55312 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaAMItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:49:03 -0500
X-AuditID: 9c93016f-b7c41ae000003ec1-08-52d3a87da492
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 23/28] perf tools: Factor out hist_entry_iter code
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
	<1389170793-21926-24-git-send-email-namhyung@kernel.org>
	<20140111162408.GE1131@krava.brq.redhat.com>
Date: Mon, 13 Jan 2014 17:49:01 +0900
In-Reply-To: <20140111162408.GE1131@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sat, 11 Jan 2014 17:24:08 +0100")
Message-ID: <87sissb72a.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 17:24:08 +0100, Jiri Olsa wrote:
> On Wed, Jan 08, 2014 at 05:46:28PM +0900, Namhyung Kim wrote:
>> Now the hist_entry_iter code will be shared with perf top code base.
>> So move it to util/hist.c and do some necessary cleanups and renames.
>
> factoring code from this very patchset.. looks like it could be easily
> squashed with:
>   perf tools: Introduce struct hist_entry_iter

OK, I'll squash it.  It was a result of extending it to support perf top
but yes, it'd be better if it's in the separate code from the beginning.


[SNIP]
>> @@ -555,23 +103,19 @@ static int process_sample_event(struct perf_tool *tool,
>>  		return 0;
>>  
>>  	if (sort__mode == SORT_MODE__BRANCH)
>> -		iter = &branch_iter;
>> +		iter = &hist_iter_branch;
>>  	else if (rep->mem_mode == 1)
>> -		iter = &mem_iter;
>> +		iter = &hist_iter_mem;
>>  	else if (symbol_conf.cumulate_callchain)
>> -		iter = &cumulative_iter;
>> +		iter = &hist_iter_cumulative;
>>  	else
>> -		iter = &normal_iter;
>> +		iter = &hist_iter_normal;
>
> looks like we could add 'struct hist_entry_iter_ops' and ops
> pointer in 'struct hist_entry_iter' ...just feel better ;-)

Yes, it looks better - I'll change it too.

Thanks for your review!
Namhyung
